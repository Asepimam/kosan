from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User
from django import forms

class UserChangeForm(forms.ModelForm):
    password = forms.CharField(label='Password', widget=forms.PasswordInput, required=False)

    class Meta:
        model = User
        fields = '__all__'

    def clean_password(self):
        password = self.cleaned_data.get('password')
        if password:
            self.instance.set_password(password)
            return self.instance.password
        return self.instance.password
    
class CustomeUserAdmin(BaseUserAdmin):
    form = UserChangeForm
    list_display = ('username', 'email', 'first_name', 'last_name', 'is_active', 'role')
    search_fields = ('username', 'email', 'first_name', 'last_name', 'role')
    list_filter = ('is_active', 'is_staff', 'role')
    list_per_page = 25

    fieldsets = (
        (None, {'fields': ('username', 'email', 'password')}),
        ('Personal info', {'fields': ('first_name', 'last_name', 'phone_number', 'role')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('last_login', 'date_joined')}),
    )
    
admin.site.register(User, CustomeUserAdmin)