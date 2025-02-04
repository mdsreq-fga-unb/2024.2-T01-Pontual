from django.urls import path
from .views import ClassApiView, StatusApiView

urlpatterns = [
    path('classes/', ClassApiView.as_view(), name='class-list-create'),
    path('classes/<int:pk>/', ClassApiView.as_view(), name='class-detail'),
    path('classes/<str:start_date>/<str:end_date>/', ClassApiView.as_view(), name='class-range'),
    path('classes/user/<str:uuid>/', ClassApiView.as_view(), name='class-user-list'),
    path('status/', StatusApiView.as_view(), name='status-create'),
    path('status/<int:pk>/', StatusApiView.as_view(), name='status-detail'),
    path('status/user/<str:uuid>/', StatusApiView.as_view(), name='status-by-user'),
    path('status/user/<str:uuid>/<int:year>/<int:month>/', StatusApiView.as_view(), name='status-by-user-month-year')
]