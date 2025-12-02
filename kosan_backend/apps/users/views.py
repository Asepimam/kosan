from urllib import request
from django.shortcuts import render
from django.views import View
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated,AllowAny
from rest_framework.views import APIView
from apps.users.serializers import UserSerializer,CreateUserSerializer, ChangePasswordSerializer,CustomTokenObtainPairSerializer, RequestPasswordResetSerializer, ChangeProfilePictureSerializer
from .repositories import User, UserRepository
from .services import UserService
from rest_framework.permissions import IsAdminUser
from rest_framework_simplejwt.views import TokenObtainPairView
from kosan_backend import settings
from django.utils.http import urlsafe_base64_encode
from django.utils.encoding import force_bytes
from django.contrib.auth.tokens import default_token_generator
from django.template.loader import render_to_string
from django.core.mail import send_mail
from rest_framework import status

class UserViews(APIView):
    permission_classes = [IsAdminUser]
    def get(self, request):
        repo = UserRepository()
        svc = UserService(repo)
        users = svc.get_all_users()
        serializer = UserSerializer(users, many=True)
        return Response({
            "message":"success",
            "data": serializer.data
        })

class UserCreateView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        repo = UserRepository()
        svc = UserService(repo)
        serialize = CreateUserSerializer(data=request.data)
        if serialize.is_valid():
            svc.create_user(**serialize.validated_data)
            return Response({"message": "User created successfully!"})
        return Response(serialize.errors, status=400)

class PasswordResetRequestAPIView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = RequestPasswordResetSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        email = serializer.validated_data['email']

        try:
            repo = UserRepository()
            svc = UserService(repo)
            user = svc.get_user_by_email(email)
        except Exception:  # Tangani User.DoesNotExist atau kesalahan lain
            # Tetap kirim respons sukses — jangan bocorkan keberadaan user
            return Response({
                'message': 'If an account with that email exists, a reset link has been sent.'
            }, status=status.HTTP_200_OK)

        # Buat UID dan token
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)

        # Siapkan konteks untuk template
        context = {
            'user': user,
            'uid': uid,
            'token': token,
            'protocol': 'https',
            'domain': 'your-frontend.com',  # Ganti dengan domain frontend Anda
        }

        # Render template email
        email_html = render_to_string('emails/password_reset.html', context)
        email_text = render_to_string('emails/password_reset.txt', context)  

        try:
            send_mail(
                subject='Reset Password Anda',
                message=email_text,          
                html_message=email_html,     
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[email],
                fail_silently=False,         
            )
        except Exception as e:
            print(f"Failed to send email: {e}")
            return Response({
                'message': 'If an account with that email exists, a reset link has been sent.'
            }, status=status.HTTP_200_OK)

        return Response({
            'message': 'If an account with that email exists, a reset link has been sent.'
        }, status=status.HTTP_200_OK)
        
class CustomTokenObtainPairView(TokenObtainPairView):
     serializer_class = CustomTokenObtainPairSerializer

class ChangePasswordView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            repo = UserRepository()
            svc = UserService(repo)
            svc.change_user_password(request.user, request.user.id, serializer.validated_data['new_password'], serializer.validated_data['new_password_confirm'])
            return Response({"message": "Password changed successfully!"})
        return Response(serializer.errors, status=400)
    
class ProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)

class ChangeProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request):
        repo = UserRepository()
        svc = UserService(repo)
        serializer = UserSerializer(data=request.data, context={'request': request}, partial=True)
        if serializer.is_valid():
            updated_user = svc.update_profile(request.user, request.user.id, serializer.validated_data)
            updated_serializer = UserSerializer(updated_user)
            return Response(updated_serializer.data)
        return Response(serializer.errors, status=400)
    
class ChangeProfilePictureView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ChangeProfilePictureSerializer(data=request.data)
        if serializer.is_valid():
            request.user.profile_picture = serializer.validated_data['profile_picture']
            request.user.save()
            return Response({"message": "Success!"})
        return Response(serializer.errors, status=400)