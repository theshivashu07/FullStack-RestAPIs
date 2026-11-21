
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    fieldsets = UserAdmin.fieldsets + (
        (
            "Additional Information",
            {
                "fields": (
                    "mobile_number",
                    "birth_date",
                    "profile_picture",
                    "bio",
                )
            },
        ),
    )

    add_fieldsets = UserAdmin.add_fieldsets + (
        (
            "Additional Information",
            {
                "fields": (
                    "mobile_number",
                    "birth_date",
                    "profile_picture",
                    "bio",
                )
            },
        ),
    )
