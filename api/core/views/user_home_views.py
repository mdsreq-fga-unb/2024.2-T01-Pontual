from datetime import datetime
from django.utils.dateparse import parse_date
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.utils.translation import gettext_lazy as _
from ..models import Class
from ..serializers import ClassSerializer
from ..permissions import IsAdminUserNotSafe
from rest_framework.renderers import JSONRenderer, BrowsableAPIRenderer
from django.utils.timezone import make_aware


class UserDailyClassesApiView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserNotSafe]

    def get(self, request, pk=None, uuid=None):
        data_selecionada = request.query_params.get("data")
        if not data_selecionada:
            return Response(
                {"detail": _("A data deve ser informada no formato YYYY-MM-DD.")},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            data_selecionada = parse_date(data_selecionada)
            if data_selecionada is None:
                raise ValueError
        except ValueError:
            return Response(
                {"detail": _("Formato de data inválido. Use YYYY-MM-DD.")},
                status=status.HTTP_400_BAD_REQUEST,
            )

        dia_da_semana = data_selecionada.strftime("%A").lower()  # Obtém o dia da semana em inglês

        if uuid:
            if not request.user.is_staff:
                return Response(
                    {"detail": "Permission denied."},
                    status=status.HTTP_403_FORBIDDEN,
                )

            classes = Class.objects.filter(user__uuid=uuid)
        else:
            classes = Class.objects.filter(user=request.user)

        classes_filtradas = classes.filter(
            start__lte=data_selecionada,
            end__gte=data_selecionada,
            days__contains=[dia_da_semana],
        ).values("id", "name", "times")

        if not classes_filtradas.exists():
            return Response(
                {"detail": "Nenhuma aula encontrada para essa data."},
                status=status.HTTP_404_NOT_FOUND,
            )

        return Response(list(classes_filtradas), status=status.HTTP_200_OK)
