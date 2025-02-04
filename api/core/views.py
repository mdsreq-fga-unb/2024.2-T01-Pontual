from django.db.models import Q
from django.shortcuts import render, get_object_or_404
from django.utils import timezone
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, exceptions
from rest_framework.permissions import IsAuthenticated
from core.permissions import IsAdminUserNotSafe
from .models import Class, Status
from .serializers import ClassSerializer, StatusSerializer
from rest_framework.renderers import JSONRenderer, BrowsableAPIRenderer
from users.models import User
from datetime import datetime
from core.utils import weekday


class ClassApiView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserNotSafe]
    renderer_classes = [JSONRenderer]

    def get(self, request, pk=None, uuid=None, start_date=None, end_date=None):
        if uuid:
            if not request.user.is_staff:
                return Response({"detail": "Permission denied."}, status=status.HTTP_403_FORBIDDEN)

            classes = Class.objects.filter(user__uuid=uuid)
            if not classes.exists():
                return Response({"detail": "No classes found for this user."}, status=status.HTTP_404_NOT_FOUND)
        elif pk:
            classes = Class.objects.filter(pk=pk, user=request.user)
        elif start_date and end_date:
            try:
                start_date = datetime.strptime(start_date, "%Y-%m-%dT%H:%M:%S")
                end_date = datetime.strptime(end_date, "%Y-%m-%dT%H:%M:%S")
            except:
                return Response({
                    "detail": "Invalid date format. Please use the format 'YYYY-MM-DDTHH:MM:SS'."
                }, status=status.HTTP_400_BAD_REQUEST)

            if start_date > end_date:
                return Response({
                    "detail": "The 'start' date must be earlier than the 'end' date."
                }, status=status.HTTP_400_BAD_REQUEST)

            classes = self.get_classes_in_range(
                start_date, end_date, request.user)
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

    def generate_days_range(self, start_date, end_date):
        days_in_range = []

        if weekday(start_date) < weekday(end_date):
            days_in_range = list(
                range(weekday(start_date), weekday(end_date) + 1))
        elif weekday(start_date) == weekday(end_date):
            if start_date.date() == end_date.date():
                days_in_range = [weekday(start_date)]
            else:
                days_in_range = list(range(0, 7))
        else:
            days_in_range = list(range(weekday(start_date), 7)) + \
                list(range(0, weekday(end_date) + 1))

        return days_in_range

    def get_classes_in_range(self, start_date, end_date, user):
        start_date = timezone.make_aware(start_date)
        end_date = timezone.make_aware(end_date)

        days_in_range = self.generate_days_range(start_date, end_date)
        classes = Class.objects.filter(
            Q(start_range__lte=end_date) & Q(end_range__gte=start_date),
            Q(days__overlap=days_in_range), user=user
        )

        for class_instance in classes:
            temporary_days_range = self.generate_days_range(
                start_date, class_instance.end_range)

            if not set(class_instance.days).intersection(set(temporary_days_range)):
                classes = classes.exclude(id=class_instance.id)

        return classes


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
