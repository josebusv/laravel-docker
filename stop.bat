@echo off
echo ============================================
echo     DETENIENDO AMBIENTE LARAVEL
echo ============================================
echo.

echo Deteniendo contenedores...
docker-compose down

echo.
echo ============================================
echo     AMBIENTE DETENIDO CORRECTAMENTE
echo ============================================
echo.
echo Para iniciar nuevamente:
echo start.bat
echo.
pause