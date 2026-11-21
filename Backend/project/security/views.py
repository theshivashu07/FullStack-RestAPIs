from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from rest_framework_simplejwt.views import TokenRefreshView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.exceptions import TokenError

from .serializers import RegisterSerializer, LoginSerializer

from rest_framework.decorators import throttle_classes
from .throttles import RegisterRateThrottle, LoginRateThrottle 

@api_view(["POST"])
@permission_classes([AllowAny])
@throttle_classes([RegisterRateThrottle])
def register(request):
    serializer = RegisterSerializer(data=request.data)

    if serializer.is_valid():
        user = serializer.save()

        return Response({
            "success": True,
            "message": "Account created successfully.",
            "data": {
                "id": user.id,
                "username": user.username,
                "email": user.email,
            },
        }, status=status.HTTP_201_CREATED)

    return Response({
        "success": False,
        "message": "Registration failed.",
        "errors": serializer.errors,
    }, status=status.HTTP_400_BAD_REQUEST)


class LoginView(APIView):
    permission_classes = [AllowAny]
    throttle_classes = [LoginRateThrottle]

    def post(self, request):
        serializer = LoginSerializer(
            data=request.data,
            context={"request": request},
        )

        if serializer.is_valid():
            return Response({
                "success": True,
                "message": "Login successful.",
                "data": serializer.validated_data,
            }, status=status.HTTP_200_OK)

        return Response({
            "success": False,
            "message": "Login failed.",
            "errors": serializer.errors,
        }, status=status.HTTP_401_UNAUTHORIZED)


class RefreshTokenView(TokenRefreshView):
    permission_classes = [AllowAny]


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        refresh_token = request.data.get("refresh")

        if not refresh_token:
            return Response({
                "success": False,
                "message": "Refresh token is required.",
            }, status=status.HTTP_400_BAD_REQUEST)

        try:
            token = RefreshToken(refresh_token)
            token.blacklist()

            return Response({
                "success": True,
                "message": "Logout successful.",
            }, status=status.HTTP_200_OK)

        except TokenError:
            return Response({
                "success": False,
                "message": "Invalid or expired refresh token.",
            }, status=status.HTTP_400_BAD_REQUEST)





