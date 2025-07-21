@echo off
echo ============================================
echo     INICIANDO AMBIENTE LARAVEL
echo ============================================
echo.

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo Error: Docker no está corriendo. Por favor inicie Docker Desktop.
    pause
    exit /b 1
)

echo [1/5] Creando directorios necesarios...
if not exist "projects" mkdir projects
if not exist "nginx\conf.d" mkdir nginx\conf.d
if not exist "nginx\ssl" mkdir nginx\ssl
if not exist "postgres\init" mkdir postgres\init

echo [2/5] Creando configuracion default de Nginx...
set "TMP_PS_SCRIPT=%TEMP%\nginx_default_conf.ps1"
(
    echo @'
    echo server {
    echo     listen 80 default_server^;
    echo     server_name _^;
    echo     root /var/www/html^;
    echo     index index.html^;
    echo.
    echo     location /health-check {
    echo         return 200 'OK'^;
    echo         add_header Content-Type text/plain^;
    echo     }
    echo.
    echo     location / {
    echo         return 404 'No Laravel project configured. Use create-project.bat to create one.'^;
    echo         add_header Content-Type text/plain^;
    echo     }
    echo }
    echo '@ ^| Set-Content -Path 'nginx\conf.d\default.conf' -Encoding utf8
) > "%TMP_PS_SCRIPT%"

powershell -ExecutionPolicy Bypass -File "%TMP_PS_SCRIPT%"
del "%TMP_PS_SCRIPT%"

echo [3/5] Iniciando servicios base...
docker-compose up -d postgres redis

echo [4/5] Esperando servicios base...
timeout /t 10 /nobreak > nul

echo [5/5] Iniciando PHP y Nginx...
docker-compose up -d php nginx adminer mailhog

echo.
echo Esperando que todos los servicios estén listos...
timeout /t 15 /nobreak > nul

echo.
echo Verificando estado de los contenedores...
docker-compose ps

echo.
echo ============================================
echo     AMBIENTE INICIADO CORRECTAMENTE
echo ============================================
echo.
echo Servicios disponibles:
echo - Nginx: http://localhost (página de estado)
echo - Adminer: http://localhost:8080
echo - Mailhog: http://localhost:8025
echo - Redis: localhost:6379
echo - PostgreSQL: localhost:5432
echo.
echo Para crear un nuevo proyecto:
echo create-project.bat nombre_proyecto
echo.
echo Para ver logs en tiempo real:
echo docker-compose logs -f
echo.
pause