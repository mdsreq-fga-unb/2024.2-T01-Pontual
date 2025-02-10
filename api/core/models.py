from django.db import models
from django.utils import timezone
from django.contrib.postgres.fields import ArrayField
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
from users.models import User


class Class(models.Model):
    DAYS_OF_WEEK = [
        (0, 'Sunday'),
        (1, 'Monday'),
        (2, 'Tuesday'),
        (3, 'Wednesday'),
        (4, 'Thursday'),
        (5, 'Friday'),
        (6, 'Saturday')
    ]

    name = models.CharField(blank=False, null=False, max_length=32)

    start_range = models.DateTimeField(
        blank=False, null=False, default=timezone.now)
    end_range = models.DateTimeField(blank=False, null=False)

    days = ArrayField(
        models.IntegerField(choices=DAYS_OF_WEEK),
        blank=False, null=False
    )
    start_time = models.TimeField(blank=False, null=False)
    end_time = models.TimeField(blank=False, null=False)

    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.name} - {self.user}'

    def clean(self):
        super().clean()
        if not self.end_range:
            raise ValidationError(
                _("The 'end' range must valid.")
            )

        if self.start_range > self.end_range:
            raise ValidationError(
                _("The 'start' range must be earlier than the 'end' range.")
            )

        if self.start_time > self.end_time:
            raise ValidationError(
                _("The 'start' time must be earlier than the 'end' time.")
            )

    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)


class Status(models.Model):
    TYPES = [
        ('vip', 'VIP'),
        ('rep', 'REP'),
        ('std', 'STD')
    ]

    NOTES = [
        ('faltou', 'FALTOU'),
        ('esqueceu', 'ESQUECEU'),
        ('atestado', 'ATESTADO')
    ]

    kind = models.CharField(
        blank=False, null=False,
        max_length=3, choices=TYPES
    )
    notes = models.CharField(
        blank=True, null=True,
        max_length=9, choices=NOTES
    )
    expected = ArrayField(
        models.DateTimeField(blank=False, null=False),
        blank=False, null=False, max_length=2
    )
    register = ArrayField(
        models.DateTimeField(blank=False, null=False),
        blank=True, null=True, max_length=2
    )
    classy = models.ForeignKey(
        Class, on_delete=models.CASCADE,
        related_name="status",
        blank=True, null=True
    )
    user = models.ForeignKey(
        User, on_delete=models.CASCADE,
        blank=True, null=True
    )

    def clean(self):
        super().clean()
        if self.kind in ['std', 'rep'] and not self.classy:
            raise ValidationError(
                _("'classy' must be set for this kind of status."))

        if self.kind == 'vip' and not self.user:
            raise ValidationError(
                _("'user' must be set for this kind of status."))

        if (self.classy is None and self.user is None) or (self.classy is not None and self.user is not None):
            raise ValidationError(
                _("Either 'classy' or 'user' must be set, but not both.")
            )

        if not self.expected:
            raise ValidationError(_("'expected' must contain two dates."))

        if len(self.expected) > 2:
            raise ValidationError(_("'expected' must contain two dates."))

        if self.register and len(self.register) > 2:
            raise ValidationError(
                _("'register' must contain two dates or less."))

    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)


class Notification(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="notifications")
    endpoint = models.URLField(blank=False, null=False)
    p256dh = models.CharField(blank=False, null=False, max_length=256)
    auth = models.CharField(blank=False, null=False, max_length=256)


class Message(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="messages")
    message = models.CharField(blank=False, null=False, max_length=512)
    created_at = models.DateTimeField(auto_now_add=True)
    checked = models.BooleanField(default=False)


class Report(models.Model):
    report = models.JSONField(default=dict)
    reviewed = models.BooleanField(default=False)
    to_review = models.BooleanField(default=False)
    end = models.DateTimeField(blank=False, null=False)
    start = models.DateTimeField(blank=False, null=False)
    absences = models.IntegerField(blank=False, null=False)
    total_minutes = models.IntegerField(blank=False, null=False)
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="reports")

    def __str__(self):
        return f"Relatório de {self.user.username} ({self.start} - {self.end})"
