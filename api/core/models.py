from django.db import models
from django.utils import timezone
from django.contrib.postgres.fields import ArrayField
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _

from users.models import User


class Class(models.Model):
    DAYS_OF_WEEK = [
        ('monday', 'Monday'),
        ('tuesday', 'Tuesday'),
        ('wednesday', 'Wednesday'),
        ('thursday', 'Thursday'),
        ('friday', 'Friday'),
        ('saturday', 'Saturday'),
        ('sunday', 'Sunday'),
    ]

    name = models.CharField(blank=False, null=False, max_length=32)
    start = models.DateTimeField(blank=False, null=False, default=timezone.now)
    end = models.DateTimeField(blank=False, null=False)
    days = ArrayField(
        models.CharField(max_length=10, choices=DAYS_OF_WEEK),
        blank=False, null=False
    )
    times = ArrayField(
        models.TimeField(blank=False, null=False),
        blank=False, null=False
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.name} - {self.user}'

    def clean(self):
        super().clean()
        if len(self.days) != len(self.times):
            raise ValidationError(
                _("The 'days' and 'times' arrays must have the same length.")
            )

        if self.start > self.end:
            raise ValidationError(
                _("The 'start' date and time must be earlier than the 'end' date and time.")
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
        models.TimeField(blank=False, null=False),
        blank=False, null=False, max_length=2
    )
    register = ArrayField(
        models.TimeField(blank=False, null=False),
        blank=False, null=False, max_length=2
    )
    classy = models.ForeignKey(
        Class, on_delete=models.CASCADE,
        blank=True, null=True
    )


class Message(models.Model):
    title = models.CharField(
        blank=False, null=False,
        max_length=64
    )
    message = models.CharField(
        blank=False, null=False,
        max_length=244
    )


class Notification(models.Model):
    STATUS = [
        ('sent', 'SENT'),
        ('awaiting', 'AWAITING')
    ]

    message = models.ForeignKey(Message, on_delete=models.CASCADE)
    status = models.CharField(
        blank=False, null=False,
        choices=STATUS, max_length=9
    )
    created_at = models.DateTimeField(
        blank=False, null=False,
        default=timezone.now
    )
    destination = models.DateTimeField(
        blank=False, null=False,
        default=timezone.now
    )
    classy = models.ForeignKey(
        Class, on_delete=models.CASCADE,
        blank=True, null=True
    )
    sender = models.ForeignKey(
        User, on_delete=models.PROTECT,
        blank=False, null=False,
        related_name='sent_notifications'
    )
    receiver = models.ForeignKey(
        User, on_delete=models.PROTECT,
        blank=False, null=False,
        related_name='received_notifications'
    )
