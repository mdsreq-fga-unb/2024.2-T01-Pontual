from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from users import views

app_name = 'users'

urlpatterns = [
    path('register/', views.Register.as_view(), name='user-register'),
    path('login/', views.Login.as_view(), name='user-login'),
    path('logout/', views.Logout.as_view(), name='user-logout'),
    path('refresh/', views.Refresh.as_view(), name='user-refresh'),
    path('manage/', views.Manage.as_view(), name='user-manage'),
    path('password/', views.PasswordChange.as_view(), name='user-password'),
    path('', views.UsersView.as_view(), name='users'),
    path('<str:uuid>/', views.UsersView.as_view(), name='users-retrieve'),
]

urlpatterns = format_suffix_patterns(urlpatterns)
