from django.urls import path
from .views.generic_views import ClassApiView, StatusApiView
from .views.user_home_views import UserDailyClassesApiView

urlpatterns = [
    # Generic Views
    
    # path('classes/', ClassApiView.as_view(), name='class-list-create'),  # Para GET (lista) e POST
    # path('classes/<int:pk>/', ClassApiView.as_view(), name='class-detail'),  # Para GET (detalhe), PATCH, e DELETE
    # path('classes/user/<str:uuid>/', ClassApiView.as_view(), name='class-user-list'),
    # path('status/', StatusApiView.as_view(), name='status-list'),  # Todos os status
    # path('status/<int:pk>/', StatusApiView.as_view(), name='status-detail'),  # Status específico
    # path('status/user/<str:uuid>/', StatusApiView.as_view(), name='status-by-user'),  # Status por usuário
    # path('status/user/<str:uuid>/<int:year>/<int:month>/', StatusApiView.as_view(), name='status-by-user-month-year'),  # Status por usuário, mês e ano

    # User Home Page Views
    
    # Rota para retornar as aulas de um usuário em uma data específica
    # 
    # Buscar aulas do usuário logado para uma data específica
    # GET /api/classes/user/daily/?data=2024-08-26
    #
    # Buscar aulas de um usuário específico (apenas admins)
    # GET /api/classes/user/daily/?data=2024-08-26&uuid=123e4567-e89b-12d3-a456-426614174000

    path('classes/user/daily/', UserDailyClassesApiView.as_view(), name='user-daily-classes'), 
]