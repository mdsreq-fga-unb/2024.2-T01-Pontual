from rest_framework.permissions import IsAdminUser

UNSAFE_METHODS = ['POST', 'PATCH', 'PUT', 'DELETE']


class IsAdminUserNotSafe(IsAdminUser):
    def has_permission(self, request, view):
        if request.method in UNSAFE_METHODS:
            return super().has_permission(request, view)
        return True
