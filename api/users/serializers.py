from typing import Dict, Any

from rest_framework import serializers, exceptions
from rest_framework_simplejwt import serializers as jwt_serializers
from rest_framework_simplejwt.tokens import RefreshToken
from users.models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['name', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User(
            name=validated_data['name'],
            email=validated_data['email']
        )
        user.set_password(validated_data['password'])
        user.save()
        return user


class TokenObtainPairSerializerWithUserInfo(jwt_serializers.TokenObtainPairSerializer):

    def validate(self, attrs: Dict[str, Any]) -> Dict[str, str]:
        data = super().validate(attrs)

        data['name'] = self.user.name
        data['email'] = self.user.email

        return data


class ManageUserSerializer(serializers.Serializer):
    email = serializers.EmailField(required=True)

    def update(self, validated_data):
        user = User.objects.get(email=validated_data.get('email'))
        if not user:
            raise exceptions.NotFound(
                f"User with email '{validated_data.get('email')}' not found."
            )

        user.is_active = True
        user.save()
        return user
