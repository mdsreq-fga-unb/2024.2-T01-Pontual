from typing import Dict, Any
from django.db.models import Q
from rest_framework import serializers, exceptions
from rest_framework_simplejwt import serializers as jwt_serializers
from rest_framework_simplejwt.tokens import RefreshToken
from core.utils.class_serializers import ClassOnlySerializer
from users.models import User
from core.models import Class, Status, Report
import json


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['uuid', 'name', 'email', 'password']
        extra_kwargs = {
            'password': {'write_only': True},
            'uuid': {'read_only': True}
        }

    def create(self, validated_data):
        user = User(
            name=validated_data['name'],
            email=validated_data['email']
        )
        user.set_password(validated_data['password'])
        user.save()
        return user


class UserGetSerializer(serializers.ModelSerializer):
    classes = serializers.SerializerMethodField()

    def get_classes(self, obj):
        return Class.objects.filter(user=obj).count()

    class Meta:
        model = User
        fields = ['uuid', 'name', 'email', 'is_staff', 'is_active', 'classes']
        extra_kwargs = {'uuid': {'read_only': True}}


class UserGetUniqueSerializer(serializers.ModelSerializer):
    classes = serializers.SerializerMethodField()
    status_count = serializers.SerializerMethodField()
    report_check = serializers.SerializerMethodField()

    def get_classes(self, obj):
        return ClassOnlySerializer(Class.objects.filter(user=obj), many=True).data

    def get_status_count(self, obj):
        return Status.objects.filter(Q(user=obj) | Q(classy__user=obj)).count()

    def get_report_check(self, obj):
        reports = Report.objects.filter(user=obj)
        for instance in reports:
            for report in instance.report:
                for status in report['statuses']:
                    if status['type_id'] == 'class' and status['id'] == obj.id:
                        return True
        return False

    class Meta:
        model = User
        fields = ['uuid', 'name', 'email', 'classes',
                  'status_count', 'report_check']
        extra_kwargs = {'uuid': {'read_only': True}}


class TokenObtainPairSerializerWithUserInfo(jwt_serializers.TokenObtainPairSerializer):

    def validate(self, attrs: Dict[str, Any]) -> Dict[str, str]:
        data = super().validate(attrs)

        data['name'] = self.user.name
        data['email'] = self.user.email
        data['uuid'] = self.user.uuid
        data['is_staff'] = self.user.is_staff

        return data


class ManageUserSerializer(serializers.Serializer):
    email = serializers.EmailField(required=True)

    def update(self, validated_data):
        user = User.objects.get(email=validated_data.get('email'))
        if not user:
            raise exceptions.NotFound(
                f"User with email '{validated_data.get('email')}' not found."
            )

        user.is_active = not user.is_active
        user.save()
        return user


class PasswordChangeSerializer(serializers.Serializer):
    password = serializers.CharField(required=True)

    def update(self, user, validated_data):
        user.set_password(validated_data.get('password'))
        user.save()
        return user
