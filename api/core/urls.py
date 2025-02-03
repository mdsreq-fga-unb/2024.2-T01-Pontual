from django.urls import path
from .views.generic_views import ClassApiView, StatusApiView
from .views.user_home_views import UserDailyClassesApiView, UserSpecialDailyClassesApiView, UserDailyStatusApiView
from .views.footer import AddUserSpecialClassApiView
from .views.admin_add_class import AdminAddClassView

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
    # GET /api/special-classes/user/daily/?data=2024-08-26
    #
    # Buscar aulas de um usuário específico (apenas admins)
    # GET /api/classes/user/daily/?data=2024-08-26&uuid=123e4567-e89b-12d3-a456-426614174000
    #
    # Rotas para retornar todos os status de uma data
    #
    # /api/status/user/daily/?data=2024-02-01
    # Retorna todos os status onde expected[0] == 2024-02-01.
    # Buscar status de uma data e de uma classe específica
    #
    # GET /api/status/user/daily/?data=2024-02-01&id_classe=3
    # Retorna apenas os status onde expected[0] == 2024-02-01 e classy == 3.
    #
    # Rota para marcar ponto -> faz um append da data no resgiter no máximo duas vezes
    #
    # PATCH /api/status/user/register/5/
    # Content-Type: application/json
    # {
    #     "register": "2024-02-01T09:00:00Z"
    # }
    #
    # PATCH /api/special-classes/user/register/3/
    # Content-Type: application/json
    # {
    #     "register": "2024-08-23T08:30:00Z"
    # }
    #
    # Rota para editar aulas especiais
    #
    # PUT /api/special-classes/user/update/3/
    # Content-Type: application/json
    # {
    #     "kind": "vip",
    #     "notes": "faltou",
    #     "expected": ["2024-02-01T10:00:00Z", "2024-02-01T12:00:00Z"],
    #     "register": ["2024-02-01T09:00:00Z", "2024-02-02T09:00:00Z"],
    #     "classy": 0,
    #     "user": 3
    # }

    path('classes/user/daily/', UserDailyClassesApiView.as_view(), name='user-daily-classes'), 
    path('special-classes/user/daily/', UserSpecialDailyClassesApiView.as_view(), name='user-special-daily-classes'),
    path('special-classes/user/register/<int:pk>/', UserSpecialDailyClassesApiView.as_view(), name='user-special-classes-update-register'), # Para PATCH
    path('special-classes/user/update/<int:pk>/', UserSpecialDailyClassesApiView.as_view(), name='user-special-classes-update'),    # Para PUT
    path('status/user/daily/', UserDailyStatusApiView.as_view(), name='user-daily-status'), 
    path('status/user/register/<int:pk>/', UserDailyStatusApiView.as_view(), name='user-status-update-register'), 

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

     # Admin Create Class
     #
     # Criação de Classe
     #
     # POST /api/classes/admin/
     # {
     # "name": "Turma 1",
     # "start": "2024-02-01T00:00:00Z",
     # "end": "2024-06-30T00:00:00Z",
     # "days": ["monday", "wednesday", "friday"],
     # "times": ["08:00:00", "09:30:00"],
     # "user": 5
     # }

    path('classes/admin/', AdminAddClassView.as_view(), name='standard-class-create'),    # Para POST

]