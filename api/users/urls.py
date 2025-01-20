from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from users import views

app_name = 'users'

urlpatterns = [
    path('register/', views.Register.as_view(), name='user-register'),
    path('login/', views.Login.as_view(), name='user-login'),
    path('refresh/', views.Refresh.as_view(), name='user-refresh'),
    path('manage/', views.Manage.as_view(), name='user-manage'),
]

urlpatterns = format_suffix_patterns(urlpatterns)
