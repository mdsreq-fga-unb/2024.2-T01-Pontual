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


class StatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = Status
        fields = '__all__'


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
