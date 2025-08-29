@echo off
if "%1"=="" (
    echo Uso: quality.bat nombre_proyecto
    exit /b 1
)
set PROJECT_NAME=%1

echo ============================================
echo   ANALISIS DE CALIDAD PARA: %PROJECT_NAME%
echo ============================================

echo.
echo Ejecutando PHPStan...
docker-compose exec php composer --working-dir=/var/www/html/%PROJECT_NAME% analyse

echo.
echo Ejecutando PHP_CodeSniffer...
docker-compose exec php composer --working-dir=/var/www/html/%PROJECT_NAME% cs

echo.
echo Analisis completado para %PROJECT_NAME%.
pause
