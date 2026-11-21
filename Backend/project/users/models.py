from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    mobile_number = models.CharField(
        max_length=15,
        blank=True,
        null=True,
    )

    birth_date = models.DateField(
        blank=True,
        null=True,
    )

    profile_picture = models.ImageField(
        upload_to="profile_pictures/",
        blank=True,
        null=True,
    )

    bio = models.TextField(
        blank=True,
        null=True,
    )

    def __str__(self):
        return self.username





