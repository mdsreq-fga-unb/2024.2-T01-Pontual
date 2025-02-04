from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from django.utils.timezone import datetime
import calendar
from ..models import Status
from ..serializers import StatusSerializer
from users.models import User


class StatusMonthAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        try:
            year = int(request.query_params.get("year", datetime.now().year))
            month = int(request.query_params.get("month", datetime.now().month))
            user_id = request.query_params.get("user_id")

            if request.user.is_staff and user_id:
                try:
                    user = User.objects.get(id=user_id)
                except User.DoesNotExist:
                    return Response({"error": "Usuário não encontrado."}, status=status.HTTP_404_NOT_FOUND)
            else:
                user = request.user

            statuses = Status.objects.filter(
                expected__0__year=year,
                expected__0__month=month,
                user=user
            ).select_related("classy").order_by("expected__0")

            grouped_statuses = {}

            for status_instance in statuses:
                date_str = status_instance.expected[0].strftime("%A, %d/%m/%y")
                date_str = calendar.day_name[status_instance.expected[0].weekday()] + date_str[3:]

                if date_str not in grouped_statuses:
                    grouped_statuses[date_str] = {"data": date_str, "Statuses": []}

                aula_name = status_instance.classy.name if status_instance.classy else status_instance.kind

                grouped_statuses[date_str]["Statuses"].append({
                    "id": status_instance.id,
                    "Aula": aula_name,
                    "Entrada": status_instance.expected[0],
                    "Saída": status_instance.expected[1],
                    "Registro": status_instance.register
                })

            result = {"Ponto": list(grouped_statuses.values())}

            return Response(result, status=status.HTTP_200_OK)

        except ValueError:
            return Response({"error": "Parâmetros inválidos."}, status=status.HTTP_400_BAD_REQUEST)
