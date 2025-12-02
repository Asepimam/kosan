from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny

class CheckHealthView(APIView):
    """
    View to check the health status of the application.
    """

    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        """
        Return a simple health status response.
        """
        return Response(
            {"status":"ok","message": "Application is healthy"}, status=status.HTTP_200_OK) 