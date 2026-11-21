from rest_framework import serializers
from .models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            "id",
            "username",
            "first_name",
            "last_name",
            "email",
            "mobile_number",
            "birth_date",
            "profile_picture",
            "bio",
            "date_joined",
        ]
        read_only_fields = fields



