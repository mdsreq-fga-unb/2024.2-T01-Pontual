from rest_framework import serializers
from core.models import *
from django.core.exceptions import ValidationError
from django.utils.dateparse import parse_time
from datetime import datetime
from users.serializers import UserSerializer


class StatusSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()
    user = serializers.SerializerMethodField()
    user_name = serializers.SerializerMethodField()

    def get_user_name(self, obj):
        return obj.user.name if obj.user else obj.classy.user.name

    def get_user(self, obj):
        return obj.user.uuid if obj.user else obj.classy.user.uuid

    def get_name(self, obj):
        return obj.classy.name if obj.classy else f"{obj.kind.upper()}: {obj.id}"

    class Meta:
        model = Status
        fields = '__all__'


class ClassPostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = '__all__'


class ClassSerializer(serializers.ModelSerializer):
    status = StatusSerializer(many=True)
    user = UserSerializer()

    class Meta:
        model = Class
        fields = '__all__'


class ClassRetrieveOnlySerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = ['id', 'name', 'days', 'start_time', 'end_time']


class ReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = '__all__'

    def validate_report(self, value):
        # Verifica se existe a chave "report"
        if not isinstance(value, list):
            raise serializers.ValidationError(
                "O campo 'report' deve ser uma lista.")

        # Valida cada entrada da lista "report"
        for entry in value:
            if not isinstance(entry, dict):
                raise serializers.ValidationError(
                    "Cada item em 'report' deve ser um dicionário.")

            if "date" not in entry or "statuses" not in entry:
                raise serializers.ValidationError(
                    "Cada item de 'report' deve conter 'date' e 'statuses'.")

            if not isinstance(entry["statuses"], list):
                raise serializers.ValidationError(
                    "O campo 'statuses' deve ser uma lista.")

            # Valida cada status dentro de "statuses"
            for status in entry["statuses"]:
                if not isinstance(status, dict):
                    raise serializers.ValidationError(
                        "Cada item em 'statuses' deve ser um dicionário.")

                required_keys = {"id", "class", "entry", "leave",
                                 "entry_report", "leave_report", "comment"}
                if not required_keys.issubset(status.keys()):
                    raise serializers.ValidationError(
                        f"O status deve conter as chaves: {required_keys}")

        return value


class ReportGetSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = Report
        fields = '__all__'


class ReportRetrieveSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = Report
        exclude = ['report']


class ReportPerRangeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = ['start', 'end']


class NotificationSubscribeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = '__all__'


class MessageSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = Message
        fields = '__all__'
