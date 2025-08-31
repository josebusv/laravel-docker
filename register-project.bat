@echo off
REM filepath: c:\laravel-docker\register-project.bat

echo ============================================
echo   REGISTRAR PROYECTO LARAVEL EXISTENTE
echo ============================================
echo.

if "%1"=="" (
    echo Error: Debe proporcionar el nombre del proyecto
    echo Uso: register-project.bat nombre_proyecto
    exit /b 1
)

set PROJECT_NAME=%1

REM Verificar si el directorio existe
if not exist "projects\%PROJECT_NAME%" (
    echo Error: El directorio projects\%PROJECT_NAME% no existe.
    exit /b 1
)

REM Crear configuración de Nginx
echo [1/6] Configurando Nginx...
powershell -Command "(Get-Content nginx/conf.d/laravel-template.conf) -replace 'PROJECT_NAME', '%PROJECT_NAME%' | Out-File -FilePath nginx/conf.d/%PROJECT_NAME%.conf -Encoding utf8"

REM Copiar .env de ejemplo si no existe
if not exist "projects\%PROJECT_NAME%\.env" (
    if exist "projects\%PROJECT_NAME%\.env.example" (
        copy "projects\%PROJECT_NAME%\.env.example" "projects\%PROJECT_NAME%\.env"
        echo [2/6] Archivo .env copiado desde .env.example
    ) else (
        echo [2/6] ADVERTENCIA: No existe .env ni .env.example. Debe crearlo manualmente.
    )
) else (
    echo [2/6] Archivo .env ya existe.
)

REM Ajustar permisos
echo [3/6] Ajustando permisos...
docker-compose exec php chown -R www-data:www-data /var/www/html/%PROJECT_NAME%
docker-compose exec php chmod -R 755 /var/www/html/%PROJECT_NAME%
docker-compose exec php chmod -R 775 /var/www/html/%PROJECT_NAME%/storage
docker-compose exec php chmod -R 775 /var/www/html/%PROJECT_NAME%/bootstrap/cache

REM Crear base de datos
echo [4/6] Creando base de datos...
docker-compose exec postgres createdb -U laravel %PROJECT_NAME%_db

REM Agregar entrada al archivo hosts
echo [5/6] Agregando entrada al archivo hosts...
findstr /C:"%PROJECT_NAME%.local" C:\Windows\System32\drivers\etc\hosts >nul 2>&1
if errorlevel 1 (
    echo 127.0.0.1 %PROJECT_NAME%.local >> C:\Windows\System32\drivers\etc\hosts
    echo Entrada agregada.
) else (
    echo Entrada ya existe.
)

REM Crear configuración Supervisor para queue
echo [6/6] Configurando Supervisor...
powershell -Command "(Get-Content php/supervisor/conf.d/template.conf) -replace '%%PROJECT_NAME%%', '%PROJECT_NAME%' | Out-File -FilePath php/supervisor/conf.d/%PROJECT_NAME%.conf -Encoding utf8"
REM Recargar Supervisor
docker-compose exec php supervisorctl reread
docker-compose exec php supervisorctl update

REM Recargar Nginx
docker-compose exec nginx nginx -s reload

echo.
echo ============================================
echo   PROYECTO REGISTRADO EXITOSAMENTE
echo ============================================
echo.
echo Proyecto: %PROJECT_NAME%
echo URL: http://%PROJECT_NAME%.local
echo.
echo Recuerda revisar y ajustar el archivo .env según tus necesidades.
echo Si es la primera vez, ejecuta:
echo docker-compose exec php composer install -d /var/www/html/%PROJECT_NAME%
echo docker-compose exec php php /var/www/html/%PROJECT_NAME%/artisan key:generate
echo.
pause