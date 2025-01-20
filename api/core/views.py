from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, exceptions
from rest_framework.permissions import IsAuthenticated
from core.permissions import IsAdminUserNotSafe
from django.shortcuts import get_object_or_404
from .models import Class, Status
from .serializers import ClassSerializer, StatusSerializer
from rest_framework.renderers import JSONRenderer, BrowsableAPIRenderer
from users.models import User


class ClassApiView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserNotSafe]
    renderer_classes = [JSONRenderer]

    def get(self, request, pk=None, uuid=None):
        if uuid:
            if not request.user.is_staff:
                return Response({"detail": "Permission denied."}, status=status.HTTP_403_FORBIDDEN)

            classes = Class.objects.filter(user__uuid=uuid)
            if not classes.exists():
                return Response({"detail": "No classes found for this user."}, status=status.HTTP_404_NOT_FOUND)
        elif pk:
            classes = Class.objects.filter(pk=pk, user=request.user)
        else:
            classes = Class.objects.filter(user=request.user)

        serializer = ClassSerializer(classes, many=True)
        if not serializer.data:
            return Response({}, status=status.HTTP_404_NOT_FOUND)

        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = ClassSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, pk):
        instance = get_object_or_404(Class, pk=pk)
        serializer = ClassSerializer(instance, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        instance = get_object_or_404(Class, pk=pk)
        instance.delete()
        return Response({}, status=status.HTTP_204_NO_CONTENT)


class StatusApiView(APIView):
    permission_classes = [IsAuthenticated]
    renderer_classes = [JSONRenderer]

    def get(self, request, pk=None, uuid=None, year=None, month=None):
        if uuid:
            if not request.user.is_staff and request.user.uuid != uuid:
                return Response(
                    {"detail": "Permission denied."},
                    status=status.HTTP_403_FORBIDDEN
                )

            statuses = Status.objects.filter(classy__user=uuid)

            if year:
                statuses = statuses.filter(register__0__year=year)

            if month:
                statuses = statuses.filter(register__0__month=month)

            if not statuses.exists():
                return Response(
                    {"detail": "No status found for this user."},
                    status=status.HTTP_404_NOT_FOUND
                )
        elif pk:
            statuses = Status.objects.filter(pk=pk)
        else:
            statuses = Status.objects.all()

        serializer = StatusSerializer(statuses, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = StatusSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        status_instance = get_object_or_404(Status, pk=pk)
        serializer = StatusSerializer(status_instance, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, pk):
        status_instance = get_object_or_404(Status, pk=pk)
        serializer = StatusSerializer(
            status_instance, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        status_instance = get_object_or_404(Status, pk=pk)
        status_instance.delete()
        return Response({}, status=status.HTTP_204_NO_CONTENT)
