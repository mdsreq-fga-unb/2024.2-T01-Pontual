from django.contrib import admin
from django import forms
from django.core.exceptions import ValidationError
from .models import User


class UserForm(forms.ModelForm):
    password = forms.CharField(
        widget=forms.PasswordInput(),
        required=True,
        label="Password",
        help_text="Enter a secure password"
    )
    confirm_password = forms.CharField(
        widget=forms.PasswordInput(),
        required=True,
        label="Confirm Password",
        help_text="Re-enter the password to confirm"
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        for field in self.fields:
            self.fields[field].required = False
        self.fields['email'].required = True
        self.fields['password'].required = True
        self.fields['confirm_password'].required = True

    def clean(self):
        cleaned_data = super().clean()
        password = cleaned_data.get("password")
        confirm_password = cleaned_data.get("confirm_password")

        if password != confirm_password:
            raise ValidationError(
                {"confirm_password": "Passwords do not match."})

        return cleaned_data

    class Meta:
        model = User
        fields = '__all__'


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    form = UserForm
    list_display = ['uuid', 'email']
    search_fields = ['email']
    fields = ['name', 'email', 'password', 'confirm_password']
