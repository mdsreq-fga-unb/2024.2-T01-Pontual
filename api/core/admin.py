from django import forms
from django.contrib import admin

from users.models import User
from .models import Class, Status, Notification


class ClassForm(forms.ModelForm):
    class Meta:
        model = Class
        fields = '__all__'


@admin.register(Class)
class ClassAdmin(admin.ModelAdmin):
    form = ClassForm
    list_display = ('name', 'start_range', 'end_range', 'user')
    list_filter = ('start_range', 'end_range')
    search_fields = ('name', 'user__email')
    ordering = ('start_range',)
    fieldsets = (
        (None, {
            'fields': ('name', 'start_range', 'end_range', 'user')
        }),
        ('Schedule Details', {
            'fields': ('days', 'start_time', 'end_time'),
            'description': "Specify the days and times for the class."
        }),
    )


class StatusForm(forms.ModelForm):
    class Meta:
        model = Status
        fields = '__all__'


@admin.register(Status)
class StatusAdmin(admin.ModelAdmin):
    form = StatusForm
    list_display = ('kind', 'notes', 'classy')
    list_filter = ('kind', 'notes')
    search_fields = ('kind', 'notes')
    ordering = ('kind',)
    fieldsets = (
        (None, {
            'fields': ('kind', 'notes', 'classy', 'user')
        }),
        ('Schedule Details', {
            'fields': ('expected', 'register'),
            'description': "Specify the expected and register times for the status."
        }),
    )
