from django.contrib.auth import authenticate
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError as DjangoValidationError
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from users.models import User



class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        write_only=True,
        validators=[validate_password],
    )
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            "username",
            "email",
            "first_name",
            "last_name",
            "mobile_number",
            "password",
            "confirm_password",
        ]

    def validate_email(self, value):
        value = value.lower().strip()

        if User.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError(
                "An account with this email already exists."
            )

        return value

    def validate_mobile_number(self, value):
        if value and User.objects.filter(mobile_number=value).exists():
            raise serializers.ValidationError(
                "This mobile number is already registered."
            )
        return value

    def validate(self, attrs):
        if attrs["password"] != attrs["confirm_password"]:
            raise serializers.ValidationError({
                "confirm_password": "Passwords do not match."
            })
        return attrs

    def create(self, validated_data):
        validated_data.pop("confirm_password")

        return User.objects.create_user(**validated_data)


class LoginSerializer(TokenObtainPairSerializer):
    username_field = "username"

    def validate(self, attrs):
        login_value = attrs.get("username")
        password = attrs.get("password")

        user = User.objects.filter(username__iexact=login_value).first()

        if user is None:
            user = User.objects.filter(email__iexact=login_value).first()

        if user is None:
            user = User.objects.filter(mobile_number=login_value).first()

        if user is None or not user.is_active:
            raise serializers.ValidationError(
                {"detail": "Invalid username/email/mobile or password."}
            )

        authenticated_user = authenticate(
            request=self.context.get("request"),
            username=user.username,
            password=password,
        )

        if authenticated_user is None:
            raise serializers.ValidationError(
                {"detail": "Invalid username/email/mobile or password."}
            )

        self.user = authenticated_user

        refresh = self.get_token(authenticated_user)

        return {
            "refresh": str(refresh),
            "access": str(refresh.access_token),
            "user": {
                "id": authenticated_user.id,
                "username": authenticated_user.username,
                "email": authenticated_user.email,
                "first_name": authenticated_user.first_name,
                "last_name": authenticated_user.last_name,
            },
        }




