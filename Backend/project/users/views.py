from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from .models import User
from .serializers import UserSerializer


@api_view(["GET"])
def users_list(request):
    users = User.objects.all().order_by("-date_joined")
    serializer = UserSerializer(users, many=True)

    return Response({
        "success": True,
        "message": "Users retrieved successfully.",
        "data": serializer.data,
    })


@api_view(["GET"])
def current_user(request):
    serializer = UserSerializer(request.user)

    return Response({
        "success": True,
        "message": "User profile retrieved successfully.",
        "data": serializer.data,
    })


