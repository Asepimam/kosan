
from django.conf import settings
from django.contrib import admin
from django.urls import path
from django.urls import include
from apps.users.views import CustomTokenObtainPairView,PasswordResetRequestAPIView,UserCreateView
from rest_framework_simplejwt.views import TokenRefreshView
from django.contrib.auth import views as auth_views
from apps.healt.views import CheckHealthView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('apps.users.urls')),
    path('api/auth/login/', CustomTokenObtainPairView.as_view()),
    path('api/auth/register/', UserCreateView.as_view()),
    path('api/auth/refresh/', TokenRefreshView.as_view()),
    path('password_reset/', PasswordResetRequestAPIView.as_view(), name='password_reset'),
    path('reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    path('health/', CheckHealthView.as_view(), name='check_health'),
]

if settings.DEBUG:
    from django.conf import settings
    from django.conf.urls.static import static
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)