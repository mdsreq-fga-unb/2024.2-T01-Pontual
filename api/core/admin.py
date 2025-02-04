from django import forms
from django.contrib import admin

from users.models import User
from .models import Class, Status, Message, Notification


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


class MessageForm(forms.ModelForm):
    class Meta:
        model = Message
        fields = '__all__'


@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    form = MessageForm
    list_display = ('title', 'message')
    list_filter = ('title', 'message')
    search_fields = ('title', 'message')
    ordering = ('title',)


class NotificationForm(forms.ModelForm):
    STATUS = [
        ('sent', 'SENT'),
        ('awaiting', 'AWAITING')
    ]

    message = forms.ModelChoiceField(
        queryset=Message.objects.all(),
        required=True,
        label="Message"
    )

    status = forms.ChoiceField(
        choices=STATUS,
        required=True,
        label="Status"
    )

    created_at = forms.DateTimeField(
        required=True,
        label="Created At"
    )

    destination = forms.DateTimeField(
        required=True,
        label="Destination"
    )

    classy = forms.ModelChoiceField(
        queryset=Class.objects.all(),
        required=False,
        label="Class"
    )

    sender = forms.ModelChoiceField(
        queryset=User.objects.all(),
        required=True,
        label="Sender"
    )

    receiver = forms.ModelChoiceField(
        queryset=User.objects.all(),
        required=True,
        label="Receiver"
    )

    class Meta:
        model = Notification
        fields = '__all__'


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    form = NotificationForm
    list_display = ('message', 'status', 'created_at',
                    'destination', 'classy', 'sender', 'receiver')
    list_filter = ('message', 'status', 'created_at',
                   'destination', 'classy', 'sender', 'receiver')
    search_fields = ('message', 'status', 'created_at',
                     'destination', 'classy', 'sender', 'receiver')
    ordering = ('message', 'status', 'created_at',
                'destination', 'classy', 'sender', 'receiver')
