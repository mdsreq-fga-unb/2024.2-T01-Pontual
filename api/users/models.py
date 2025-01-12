from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _

from uuid import uuid4

from .managers import UserManager


class User(AbstractUser):
    username = None

    uuid = models.UUIDField(default=uuid4, primary_key=True)
    name = models.CharField(blank=False, null=False, max_length=64)
    email = models.EmailField(_('email address'), unique=True, blank=False, null=False)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = UserManager()

    def __str__(self):
        return self.email
