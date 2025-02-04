from django.conf import settings
from django.shortcuts import render
from rest_framework import request, response, views, permissions, status, exceptions
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework_simplejwt.settings import api_settings
from rest_framework_simplejwt import tokens
from users import models, serializers


class Register(views.APIView):
    def post(self, request, *args, **kwargs):
        serializer = serializers.UserSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.create(serializer.validated_data)

        return response.Response(status=status.HTTP_201_CREATED, data=serializer.data)


class Manage(views.APIView):
    permission_classes = [permissions.IsAdminUser]

    def post(self, request, *args, **kwargs):
        serializer = serializers.ManageUserSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.update(serializer.validated_data)

        data = {
            'message': 'User Active'
        }
        data.update(serializer.validated_data)

        return response.Response(status=status.HTTP_200_OK, data=data)


class RefreshTokenTreats():
    DEVICES = ['MOBILE', 'DESKTOP', None]

    def handle_remember_me(self, request, response):
        remember_me = request.data.get('remember_me', True)

        refresh_token = response.data.pop('refresh')
        if remember_me:
            jwt_settings = settings.SIMPLE_JWT
            response.set_cookie(key="refresh", value=refresh_token,
                                max_age=jwt_settings["REFRESH_TOKEN_LIFETIME"],
                                secure=jwt_settings["REFRESH_TOKEN_SECURE"],
                                httponly=True, samesite="Lax")

        return response

    def handle_mobile_or_desktop(self, request, response):
        device_type = request.headers.get('Device-Type')
        if device_type not in self.DEVICES:
            raise exceptions.ValidationError("Device type not recognized")
        elif device_type == 'MOBILE':
            return response

        response = self.handle_remember_me(request, response)

        return response


class Login(TokenObtainPairView, RefreshTokenTreats):

    def post(self, request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)

        return self.handle_mobile_or_desktop(request, response)


class Refresh(TokenRefreshView, RefreshTokenTreats):
    def post(self, request: request.Request, *args, **kwargs):
        refresh_ck = request.COOKIES.get('refresh')
        serializer = self.get_serializer(data=request.data)

        if not serializer.is_valid() and not refresh_ck:
            raise exceptions.ValidationError("Refresh token not provided")
        refresh = refresh_ck or serializer.validated_data.get('refresh')

        request.data.update({
            'refresh': refresh
        })

        response = super().post(request, *args, **kwargs)

        access_token = tokens.AccessToken(response.data.get('access'))
        user_id = access_token.payload.get(api_settings.USER_ID_CLAIM)

        user = models.User.objects.get(uuid=user_id)

        response.data['name'] = user.name
        response.data['email'] = user.email

        return self.handle_mobile_or_desktop(request, response)
