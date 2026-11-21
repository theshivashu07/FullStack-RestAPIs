from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response


@api_view(["GET"])
@permission_classes([AllowAny])
def home(request):
    return Response({
        "success": True,
        "message": "Welcome to FullStack REST APIs",
        "data": {
            "project": "FullStack REST APIs",
            "version": "1.0.0",
            "status": "running",
        },
    })
    
    