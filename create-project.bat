@echo off
setlocal enabledelayedexpansion

echo ============================================
echo     LARAVEL PROJECT CREATOR
echo ============================================
echo.

if "%1"=="" (
    echo Error: Debe proporcionar un nombre de proyecto
    echo Uso: create-project.bat nombre_proyecto
    exit /b 1
)

set PROJECT_NAME=%1

echo Creando proyecto Laravel: %PROJECT_NAME%
echo.

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo Error: Docker no está corriendo. Por favor inicie Docker Desktop.
    exit /b 1
)

REM Crear directorio del proyecto si no existe
if not exist "projects" mkdir projects

REM Crear el proyecto Laravel
echo [1/6] Creando proyecto Laravel...
docker-compose exec php composer create-project laravel/laravel /var/www/html/%PROJECT_NAME% --prefer-dist

REM Configurar permisos
echo [2/6] Configurando permisos...
docker-compose exec php chown -R www:www /var/www/html/%PROJECT_NAME%
docker-compose exec php chmod -R 755 /var/www/html/%PROJECT_NAME%
docker-compose exec php chmod -R 775 /var/www/html/%PROJECT_NAME%/storage
docker-compose exec php chmod -R 775 /var/www/html/%PROJECT_NAME%/bootstrap/cache

REM Crear configuración de Nginx
echo [3/6] Configurando Nginx...
powershell -Command "(Get-Content nginx/conf.d/laravel-template.conf) -replace 'PROJECT_NAME', '%PROJECT_NAME%' | Out-File -FilePath nginx/conf.d/%PROJECT_NAME%.conf -Encoding utf8"

REM Crear archivo .env personalizado
echo [4/6] Configurando archivo .env...
(
echo APP_NAME=%PROJECT_NAME%
echo APP_ENV=local
echo APP_KEY=
echo APP_DEBUG=true
echo APP_URL=http://%PROJECT_NAME%.local
echo.
echo LOG_CHANNEL=stack
echo LOG_DEPRECATIONS_CHANNEL=null
echo LOG_LEVEL=debug
echo.
echo DB_CONNECTION=pgsql
echo DB_HOST=postgres
echo DB_PORT=5432
echo DB_DATABASE=%PROJECT_NAME%_db
echo DB_USERNAME=laravel
echo DB_PASSWORD=laravel123
echo.
echo BROADCAST_DRIVER=log
echo CACHE_DRIVER=redis
echo FILESYSTEM_DRIVER=local
echo QUEUE_CONNECTION=redis
echo SESSION_DRIVER=redis
echo SESSION_LIFETIME=120
echo.
echo MEMCACHED_HOST=127.0.0.1
echo.
echo REDIS_HOST=redis
echo REDIS_PASSWORD=null
echo REDIS_PORT=6379
echo.
echo MAIL_MAILER=smtp
echo MAIL_HOST=mailhog
echo MAIL_PORT=1025
echo MAIL_USERNAME=null
echo MAIL_PASSWORD=null
echo MAIL_ENCRYPTION=null
echo MAIL_FROM_ADDRESS=noreply@%PROJECT_NAME%.local
echo MAIL_FROM_NAME="${APP_NAME}"
echo.
echo AWS_ACCESS_KEY_ID=
echo AWS_SECRET_ACCESS_KEY=
echo AWS_DEFAULT_REGION=us-east-1
echo AWS_BUCKET=
echo AWS_USE_PATH_STYLE_ENDPOINT=false
echo.
echo PUSHER_APP_ID=
echo PUSHER_APP_KEY=
echo PUSHER_APP_SECRET=
echo PUSHER_APP_CLUSTER=mt1
echo.
echo MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
echo MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
) > projects\%PROJECT_NAME%\.env

REM Generar APP_KEY
echo [5/6] Generando APP_KEY...
docker-compose exec php php /var/www/html/%PROJECT_NAME%/artisan key:generate

REM Crear base de datos
echo [6/6] Creando base de datos...
docker-compose exec postgres createdb -U laravel %PROJECT_NAME%_db

REM Agregar entrada al archivo hosts
echo.
echo Agregando entrada al archivo hosts...
echo 127.0.0.1 %PROJECT_NAME%.local >> C:\Windows\System32\drivers\etc\hosts

REM Recargar Nginx
docker-compose exec nginx nginx -s reload

echo.
echo ============================================
echo     PROYECTO CREADO EXITOSAMENTE
echo ============================================
echo.
echo Proyecto: %PROJECT_NAME%
echo URL: http://%PROJECT_NAME%.local
echo Base de datos: %PROJECT_NAME%_db
echo.
echo Servicios disponibles:
echo - Adminer: http://localhost:8080
echo - Mailhog: http://localhost:8025
echo - Redis: localhost:6379
echo - PostgreSQL: localhost:5432
echo.
echo Para ejecutar comandos Artisan:
echo docker-compose exec php php /var/www/html/%PROJECT_NAME%/artisan [comando]
echo.
echo Para instalar dependencias NPM:
echo docker-compose exec php npm install --prefix /var/www/html/%PROJECT_NAME%
echo.
pause