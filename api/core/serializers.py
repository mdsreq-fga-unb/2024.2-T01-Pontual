from rest_framework import serializers
from .models import *
from django.core.exceptions import ValidationError
from django.utils.dateparse import parse_time
from datetime import datetime


class ClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = '__all__'
        extra_kwargs = {'user': {'write_only': True}}


class SpecialClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Status
        fields = '__all__'
    
    def validate_kind(self, value):
        if value not in ['vip', 'rep']:
            raise serializers.ValidationError("O campo 'kind' deve ser 'vip' ou 'rep'.")
        return value

    def validate_expected(self, value):
        if len(value) != 2:
            raise serializers.ValidationError("O campo 'expected' deve conter exatamente duas datas.")
        return value
    
    def validate_register(self, value):
        if len(value) > 2:
            raise serializers.ValidationError("O campo 'register' deve conter no máximo duas datas.")
        return value

    def validate(self, data):
        user = data.get('user')
        classy = data.get('classy')

        if user is None or classy is not None:
            raise serializers.ValidationError(
                _("O campo 'user' deve estar preenchido, e o campo 'classy' deve ser nulo.")
            )

        return data


class StatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = Status
        fields = '__all__'
    
    def validate(self, data):
        user = data.get('user')
        classy = data.get('classy')

        if user and classy is not None:
            raise serializers.ValidationError(
                _("Quando o campo 'user' está preenchido, o campo 'classy' deve ser nulo.")
            )

        if not user and classy is None:
            raise serializers.ValidationError(
                _("Quando o campo 'classy' está preenchido, o campo 'user' deve ser preenchido.")
            )

        return data


class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = '__all__'


class NotificationSerializer(serializers.ModelSerializer):
    STATUS = [
        ('sent', 'SENT'),
        ('awaiting', 'AWAITING')
    ]

    message = serializers.PrimaryKeyRelatedField(
        queryset=Message.objects.all(), required=True)
    status = serializers.ChoiceField(choices=STATUS, required=True)
    created_at = serializers.DateTimeField(required=True)
    destination = serializers.DateTimeField(required=True)
    classy = serializers.PrimaryKeyRelatedField(
        queryset=Class.objects.all(), required=False)
    sender = serializers.PrimaryKeyRelatedField(
        queryset=User.objects.all(), required=True)
    receiver = serializers.PrimaryKeyRelatedField(
        queryset=User.objects.all(), required=True)

    class Meta:
        model = Notification
        fields = '__all__'


class ReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = '__all__'

    def validate_relatorio(self, value):
        # Verifica se existe a chave "Ponto"
        if not isinstance(value, dict) or "Ponto" not in value:
            raise serializers.ValidationError("O campo 'relatorio' deve conter a chave 'Ponto'.")

        if not isinstance(value["Ponto"], list):
            raise serializers.ValidationError("O campo 'Ponto' deve ser uma lista.")

        # Valida cada entrada da lista "Ponto"
        for entry in value["Ponto"]:
            if not isinstance(entry, dict):
                raise serializers.ValidationError("Cada item em 'Ponto' deve ser um dicionário.")

            if "data" not in entry or "Statuses" not in entry:
                raise serializers.ValidationError("Cada item de 'Ponto' deve conter 'data' e 'Statuses'.")

            if not isinstance(entry["Statuses"], list):
                raise serializers.ValidationError("O campo 'Statuses' deve ser uma lista.")

            # Valida cada status dentro de "Statuses"
            for status in entry["Statuses"]:
                if not isinstance(status, dict):
                    raise serializers.ValidationError("Cada item em 'Statuses' deve ser um dicionário.")

                required_keys = {"id", "Aula", "Entrada", "Saída", "Registro_Entrada", "Registro_Saida"}
                if not required_keys.issubset(status.keys()):
                    raise serializers.ValidationError(f"O status deve conter as chaves: {required_keys}")

        return value
