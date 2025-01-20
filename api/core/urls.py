from django.urls import path
from .views import ClassApiView, StatusApiView

urlpatterns = [
    path('classes/', ClassApiView.as_view(), name='class-list-create'),  # Para GET (lista) e POST
    path('classes/<int:pk>/', ClassApiView.as_view(), name='class-detail'),  # Para GET (detalhe), PATCH, e DELETE
    path('classes/user/<str:uuid>/', ClassApiView.as_view(), name='class-user-list'),
    path('status/', StatusApiView.as_view(), name='status-list'),  # Todos os status
    path('status/<int:pk>/', StatusApiView.as_view(), name='status-detail'),  # Status específico
    path('status/user/<str:uuid>/', StatusApiView.as_view(), name='status-by-user'),  # Status por usuário
    path('status/user/<str:uuid>/<int:year>/<int:month>/', StatusApiView.as_view(), name='status-by-user-month-year'),  # Status por usuário, mês e ano
]