from rest_framework import serializers
from .models import User
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
class UserSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='username')
    class Meta:
        model = User
        fields = ['id', 'user_name', 'email', 'first_name', 'last_name','phone_number','profile_picture']
        read_only_fields = ['id']
        
class CreateUserSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True)
    password = serializers.CharField(write_only=True, required=True, min_length=8)
    user_name = serializers.CharField(source='username', required=True)
    class Meta:
        model = User
        fields = ['user_name', 'email', 'password']
    
    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("A user with this email already exists.")
        return value
    
class UpdateUserSerializer(serializers.ModelSerializer):
    phone_number = serializers.CharField(required=False, allow_blank=True, min_length=0, max_length=15)
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email', 'phone_number']
        extra_kwargs = {
            'email': {'required': False},
            'first_name': {'required': False},
            'last_name': {'required': False},
            'phone_number': {'required': False},
        }
    def validate_email(self, value):
        user = self.context['request'].user
        if User.objects.exclude(id=user.id).filter(email=value).exists():
            raise serializers.ValidationError("This email is already in use.")
        return value
    
class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(write_only=True, required=True)
    new_password = serializers.CharField(write_only=True, required=True)
    new_password_confirm = serializers.CharField(write_only=True, required=True)

    def validate_old_password(self, value):
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError("Old password is incorrect.")
        return value

    def validate(self, data):
        if data['new_password'] != data['new_password_confirm']:
            raise serializers.ValidationError("New passwords do not match.")
        return data
class RequestPasswordResetSerializer(serializers.Serializer):
    email = serializers.EmailField()
    
class ChangeProfilePictureSerializer(serializers.Serializer):
    profile_picture = serializers.ImageField()
    def validate_profile_picture(self, value):
        value_size = value.size
        max_size = 2 * 1024 * 1024  # 2 MB
        if value_size > max_size:
            raise serializers.ValidationError("Profile picture size should not exceed 2 MB.")
        return value
    
class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token['email'] = user.email
        token['role'] = user.role
        return token