from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, exceptions
from rest_framework.permissions import IsAuthenticated
from core.permissions import IsAdminUserNotSafe
from django.shortcuts import get_object_or_404
from ..models import Class, Status
from ..serializers import ClassSerializer, StatusSerializer
from rest_framework.renderers import JSONRenderer, BrowsableAPIRenderer
from users.models import User
from datetime import timedelta
from django.utils import timezone
from django.core.exceptions import ValidationError
from ..permissions import IsAdminUserNotSafe


class AdminAddClassView(APIView):
    permission_classes = [IsAdminUserNotSafe]

    def post(self, request):
        serializer = ClassSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        new_class = serializer.save()

        generated_statuses = self.generate_statuses(new_class)

        return Response(
            {"message": "Classe e status criados com sucesso.", "status_count": len(generated_statuses)},
            status=status.HTTP_201_CREATED
        )

    def generate_statuses(self, class_instance):
        """Cria todos os registros de Status dentro do período da Class"""
        start_date = class_instance.start.date()
        end_date = class_instance.end.date()
        current_date = start_date
        statuses = []

        week_days_map = {
            "monday": 0, "tuesday": 1, "wednesday": 2, "thursday": 3,
            "friday": 4, "saturday": 5, "sunday": 6
        }
        selected_days = [week_days_map[day] for day in class_instance.days]

        while current_date <= end_date:
            if current_date.weekday() in selected_days:
                statuses.append(Status(
                    kind="std",
                    notes=None,
                    expected=[
                        timezone.make_aware(timezone.datetime.combine(current_date, class_instance.times[0])),
                        timezone.make_aware(timezone.datetime.combine(current_date, class_instance.times[1]))
                    ],
                    register=None,
                    classy=class_instance,
                    user=None
                ))

            current_date += timedelta(days=1)

        Status.objects.bulk_create(statuses)  # Salva todos de uma vez no banco
        
        return statuses

