from django.urls import path
from .views import (
    register,
    LoginView,
    RefreshTokenView,
    LogoutView,
)

app_name = "security"

urlpatterns = [
    path("register/", register, name="register"),
    path("login/", LoginView.as_view(), name="login"),
    path("token/refresh/", RefreshTokenView.as_view(), name="token_refresh"),
    path("logout/", LogoutView.as_view(), name="logout"),
]