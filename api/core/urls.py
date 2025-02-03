from django.urls import path
from .views.generic_views import ClassApiView, StatusApiView
from .views.user_home_views import UserDailyClassesApiView, UserSpecialDailyClassesApiView
from .views.footer import AddUserSpecialClassApiView

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
    
    # Rotas para retornar as aulas de um usuário em uma data específica
    # 
    # Buscar aulas do usuário logado para uma data específica
    # GET /api/classes/user/daily/?data=2024-08-26
    # GET /api/status/user/special-classes/?data=2024-08-26
    #
    # Buscar aulas de um usuário específico (apenas admins)
    # GET /api/classes/user/daily/?data=2024-08-26&uuid=123e4567-e89b-12d3-a456-426614174000

    path('classes/user/daily/', UserDailyClassesApiView.as_view(), name='user-daily-classes'), 
    path('status/user/special-classes/', UserDailyClassesApiView.as_view(), name='user-daily-classes'), 

    # Footer Views

    # Criação(POST) de classes vip e/ou rep
    #
    # POST /api/status/special/
    # Content-Type: application/json
    #
    # {
    # "kind": "vip",
    # "expected": ["2024-08-23T09:00:00", "2024-08-24T09:00:00"],
    # "user": "123e4567-e89b-12d3-a456-426614174000",
    # "classy": null
    # }

     path('status/special/', AddUserSpecialClassApiView.as_view(), name='special-class-create'),             # Para POST
     path('status/special/<int:pk>/', AddUserSpecialClassApiView.as_view(), name='special-class-update'),    # Para PATCH e DELETE
]