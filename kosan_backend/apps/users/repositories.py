from django.contrib.auth import get_user_model

User = get_user_model()

class UserRepository:
    @staticmethod
    def create_user(**kwargs):
        password = kwargs.pop('password', None)
        if not password:
            raise ValueError("Password must be provided.")
        user = User(**kwargs)
        user.set_password(password)
        user.save()
        return user
    
    @staticmethod
    def get_users():
        return User.objects.all()
    
    @staticmethod
    def get_user_by_id(user_id):
        return User.objects.get(id=user_id)

    @staticmethod
    def update_user(user, data):
        for attr, value in data.items():
            setattr(user, attr, value)
        user.save()
        return user

    @staticmethod
    def set_password(user, password):
        user.set_password(password)
        user.save()
        
    @staticmethod
    def get_user_by_email(email):
        return User.objects.get(email=email)