from datetime import datetime
from django.utils.dateparse import parse_date
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.utils.translation import gettext_lazy as _
from ..models import Class, Status
from ..serializers import ClassSerializer
from ..permissions import IsAdminUserNotSafe
from rest_framework.renderers import JSONRenderer, BrowsableAPIRenderer
from django.utils.timezone import make_aware
from django.shortcuts import get_object_or_404


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

        dia_da_semana = data_selecionada.strftime("%A").lower()

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


class UserSpecialDailyClassesApiView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        data_selecionada = request.query_params.get("data")
        if not data_selecionada:
            return Response(
                {"detail": "A data deve ser informada no formato YYYY-MM-DD."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            data_selecionada = parse_date(data_selecionada)
            if data_selecionada is None:
                raise ValueError
        except ValueError:
            return Response(
                {"detail": "Formato de data inválido. Use YYYY-MM-DD."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        statuses = Status.objects.filter(
            user=request.user,
            expected__0__date=data_selecionada,
            kind__in=["VIP", "vip", "REP", "rep"]
        ).values("id", "kind", "expected", "register")

        if not statuses.exists():
            return Response(
                {"detail": "Nenhuma aula especial encontrada para essa data."},
                status=status.HTTP_404_NOT_FOUND,
            )

        return Response(list(statuses), status=status.HTTP_200_OK)
    
    # Para Marcar o Ponto da Aula Especial
    def patch(self, request, pk):
        try:
            status_instance = Status.objects.get(id=pk, user=request.user, kind__in=["VIP", "vip", "REP", "rep"])
        except Status.DoesNotExist:
            return Response({"detail": "Status não encontrado ou sem permissão."}, status=status.HTTP_404_NOT_FOUND)

        register_data = request.data.get("register")

        if not register_data:
            return Response(
                {"detail": "O campo 'register' é obrigatório para a atualização do ponto."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            register_datetime = parse_datetime(register_data)
            if register_datetime is None:
                raise ValueError
        except ValueError:
            return Response(
                {"detail": "Formato de data de 'register' inválido. Use o formato ISO 8601."},
                status=status.HTTP_400_BAD_REQUEST
            )

        if status_instance.register:
            if len(status_instance.register) < 2:
                status_instance.register.append(register_datetime)
            else:
                return Response(
                    {"detail": "O campo 'register' já contém o número máximo de 2 datas."},
                    status=status.HTTP_400_BAD_REQUEST
                )
        else:
            status_instance.register = [register_datetime]

        status_instance.save()

        serializer = SpecialClassSerializer(status_instance)
        
        return Response(serializer.data, status=status.HTTP_200_OK)

    # Para editar dados da aula especial
    def put(self, request, pk):
        try:
            status_instance = Status.objects.get(id=pk, user=request.user, kind__in=["VIP", "vip", "REP", "rep"])
        except Status.DoesNotExist:
            return Response({"detail": "Status não encontrado ou sem permissão."}, status=status.HTTP_404_NOT_FOUND)

        serializer = SpecialClassSerializer(status_instance, data=request.data, partial=False)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        try:
            status_instance = Status.objects.get(id=pk, user=request.user, kind__in=["VIP", "vip", "REP", "rep"])
        except Status.DoesNotExist:
            return Response(
                {"detail": "Aula especial não encontrada ou sem permissão."},
                status=status.HTTP_404_NOT_FOUND,
            )

        status_instance.delete()
        return Response(
            {"detail": "Aula especial excluída com sucesso."},
            status=status.HTTP_204_NO_CONTENT,
        )


class UserDailyStatusApiView(APIView):
    def get(self, request):
        data_selecionada = request.query_params.get("data")
        id_classe = request.query_params.get("id_classe")

        if not data_selecionada:
            return Response(
                {"detail": "A data deve ser informada no formato YYYY-MM-DD."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            data_selecionada = parse_date(data_selecionada)
            if data_selecionada is None:
                raise ValueError
        except ValueError:
            return Response(
                {"detail": "Formato de data inválido. Use YYYY-MM-DD."},
                status=status.HTTP_400_BAD_REQUEST
            )

        statuses = Status.objects.filter(
            expected__0=data_selecionada
        )

        if id_classe:
            statuses = statuses.filter(classy_id=id_classe)

        if not statuses.exists():
            return Response(
                {"detail": "Nenhum status encontrado para os filtros informados."},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = StatusSerializer(statuses, many=True)
        
        return Response(serializer.data, status=status.HTTP_200_OK)

    def patch(self, request, pk):
        status_instance = get_object_or_404(Status, pk=pk)

        register_data = request.data.get("register")

        if not register_data:
            return Response(
                {"detail": "O campo 'register' é obrigatório para a atualização do status."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            register_datetime = parse_datetime(register_data)
            if register_datetime is None:
                raise ValueError
        except ValueError:
            return Response(
                {"detail": "Formato de data de 'register' inválido. Use o formato ISO 8601."},
                status=status.HTTP_400_BAD_REQUEST
            )

        if status_instance.register:
            if len(status_instance.register) < 2:
                status_instance.register.append(register_datetime)
            else:
                return Response(
                    {"detail": "O campo 'register' já contém o número máximo de 2 datas."},
                    status=status.HTTP_400_BAD_REQUEST
                )
        else:
            status_instance.register = [register_datetime]

        status_instance.save()

        serializer = StatusSerializer(status_instance)
        return Response(serializer.data, status=status.HTTP_200_OK)



