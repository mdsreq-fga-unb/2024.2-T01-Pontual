from django.urls import path
from .views import ClassApiView, StatusApiView, ReportAPIView, ReportReviewAPIView, NotificationSubscribeAPIView, NotificationAPIView, MessageAPIView

urlpatterns = [
    path('classes/', ClassApiView.as_view(), name='class-list-create'),
    path('classes/<int:pk>/', ClassApiView.as_view(), name='class-detail'),
    path('classes/<str:start_date>/<str:end_date>/', ClassApiView.as_view(), name='class-range'),
    path('classes/<str:start_date>/', ClassApiView.as_view(), name='class-start-range'),
    path('classes/user/<str:uuid>/', ClassApiView.as_view(), name='class-user-list'),
    path('status/', StatusApiView.as_view(), name='status-create'),
    path('status/<int:pk>/', StatusApiView.as_view(), name='status-detail'),
    path('status/user/<str:uuid>/', StatusApiView.as_view(), name='status-by-user'),
    path('status/<str:start_date>/<str:end_date>/', StatusApiView.as_view(), name='status-range'),
    path('report/review/<int:pk>/', ReportReviewAPIView.as_view(), name='report-review'),
    path('report/<str:start_date>/<str:end_date>/', ReportAPIView.as_view(), name='report-all-range-create-request'),
    path('report/<int:pk>/', ReportAPIView.as_view(), name='report-detail-request_pk_review'),
    path('report/', ReportAPIView.as_view(), name='report-list'),
    path('notification/', NotificationSubscribeAPIView.as_view(), name='notification-subscribe'),
    path('notification/send/', NotificationAPIView.as_view(), name='notification-send'),
    path('message/', MessageAPIView.as_view(), name='message-list-create'),
]