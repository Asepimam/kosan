from django.contrib.auth import get_user_model
from rest_framework.exceptions import PermissionDenied, ValidationError
from .repositories import UserRepository

User = get_user_model()

class UserService:
    def __init__(self, user_repository: UserRepository):
        self.user_repository = user_repository

    def create_user(self, **kwargs):
        email = kwargs.get('email')
        if User.objects.filter(email=email).exists():
            raise ValidationError("A user with this email already exists.")
        
        return self.user_repository.create_user(**kwargs)

    def get_all_users(self):
        return self.user_repository.get_users()

    def change_user_password(self, requesting_user, target_user_id, new_password, new_password_confirm):
        if new_password != new_password_confirm:
            raise ValidationError("Passwords do not match.")

        target_user = self.user_repository.get_user_by_id(target_user_id)
        if requesting_user.id != target_user.id:
            raise PermissionDenied("You can only change your own password.")

        self.user_repository.set_password(target_user, new_password)
        return target_user
    
    def update_profile(self, requesting_user, user_id, data):
        user = self.user_repository.get_user_by_id(user_id)
        if requesting_user.id != user.id:
            raise PermissionDenied("You can only update your own profile.")
        return self.user_repository.update_user(user, data)
    
    def get_user_by_email(self, email):
        return self.user_repository.get_user_by_email(email)