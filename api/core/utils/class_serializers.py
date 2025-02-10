from rest_framework import serializers
from core.models import Class


class ClassOnlySerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = '__all__'
