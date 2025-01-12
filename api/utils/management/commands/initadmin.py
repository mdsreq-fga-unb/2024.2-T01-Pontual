from django.core.management.base import BaseCommand
from users.models import User
from decouple import config


class Command(BaseCommand):

    def handle(self, *args, **options):
        email = config("ADMIN_EMAIL")
        if not len(User.objects.all().filter(email=email)):
            password = config("ADMIN_PASS")
            print(f'Conta do usuário {email} será criada!')
            User.objects.create_superuser(email=email, password=password)
        else:
            print('Conta de administrador já existe!')
