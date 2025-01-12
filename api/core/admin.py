from django import forms
from django.contrib import admin

from users.models import User
from .models import Class, Status, Message, Notification


class ClassForm(forms.ModelForm):
    days = forms.MultipleChoiceField(
        choices=Class.DAYS_OF_WEEK,
        widget=forms.CheckboxSelectMultiple,
        required=True,
        label="Days of the Week"
    )

    times = forms.CharField(
        widget=forms.Textarea(attrs={'rows': 3}),
        required=True,
        label="Class Times (comma-separated HH:MM:SS)"
    )

    class Meta:
        model = Class
        fields = '__all__'

    def clean_times(self):
        times = self.cleaned_data['times']
        times_list = [t.strip() for t in times.split(',')]
        try:
            # Validate each time format (HH:MM:SS)
            validated_times = [forms.TimeField().clean(t) for t in times_list]
        except forms.ValidationError:
            raise forms.ValidationError(
                "Each time must be in HH:MM:SS format."
            )
        return validated_times

    def clean(self):
        cleaned_data = super().clean()
        days = cleaned_data.get('days', [])
        times = cleaned_data.get('times', [])
        if len(days) != len(times):
            raise forms.ValidationError(
                "The number of days must match the number of times."
            )
        return cleaned_data


@admin.register(Class)
class ClassAdmin(admin.ModelAdmin):
    form = ClassForm
    list_display = ('name', 'start', 'end', 'user')
    list_filter = ('start', 'end')
    search_fields = ('name', 'user__email')
    ordering = ('start',)
    fieldsets = (
        (None, {
            'fields': ('name', 'start', 'end', 'user')
        }),
        ('Schedule Details', {
            'fields': ('days', 'times'),
            'description': "Specify the days and times for the class."
        }),
    )


class StatusForm(forms.ModelForm):
    expected = forms.CharField(
        widget=forms.Textarea(attrs={'rows': 3}),
        required=True,
        label="Expected Times (comma-separated HH:MM:SS)"
    )

    register = forms.CharField(
        widget=forms.Textarea(attrs={'rows': 3}),
        required=True,
        label="Register Times (comma-separated HH:MM:SS)"
    )

    class Meta:
        model = Class
        fields = '__all__'

    def check_times(self, typ):
        times = self.cleaned_data[typ]
        times_list = [t.strip() for t in times.split(',')]
        try:
            # Validate each time format (HH:MM:SS)
            validated_times = [forms.TimeField().clean(t) for t in times_list]
        except forms.ValidationError:
            raise forms.ValidationError(
                "Each time must be in HH:MM:SS format."
            )
        return validated_times

    def clean_expected(self):
        return self.check_times('expected')

    def clean_register(self):
        return self.check_times('register')

    def clean(self):
        cleaned_data = super().clean()
        expected = cleaned_data.get('expected', [])
        register = cleaned_data.get('register', [])
        if len(expected) != len(register):
            raise forms.ValidationError(
                "The number of expected times must match the number of register times."
            )
        return cleaned_data


@admin.register(Status)
class StatusAdmin(admin.ModelAdmin):
    form = StatusForm
    list_display = ('kind', 'notes', 'classy')
    list_filter = ('kind', 'notes')
    search_fields = ('kind', 'notes')
    ordering = ('kind',)
    fieldsets = (
        (None, {
            'fields': ('kind', 'notes', 'classy')
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
