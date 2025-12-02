from django.urls import path
from .views import UserViews, ChangePasswordView, ProfileView, ChangeProfileView,ChangeProfilePictureView
urlpatterns = [
    path('users/', UserViews.as_view(), name='user-list'),
    path('users/change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('users/profile/', ProfileView.as_view(), name='profile'),
    path('users/change-profile/', ChangeProfileView.as_view(), name='change-profile'),
    path('users/change-profile-picture/', ChangeProfilePictureView.as_view(), name='change-profile-picture'),
]
