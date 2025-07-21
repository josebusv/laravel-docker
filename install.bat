@echo off
echo ============================================
echo     INSTALACION DE AMBIENTE LARAVEL
echo ============================================
echo.

echo [1/5] Verificando Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Docker no está instalado o no está en PATH
    echo Por favor instale Docker Desktop desde: https://docker.com/products/docker-desktop
    pause
    exit /b 1
) else (
    echo ✓ Docker encontrado
)

echo [2/5] Creando estructura de directorios...
if not exist "projects" mkdir projects
if not exist "nginx" mkdir nginx
if not exist "nginx\conf.d" mkdir nginx\conf.d
if not exist "nginx\ssl" mkdir nginx\ssl
if not exist "php" mkdir php
if not exist "postgres" mkdir postgres
if not exist "postgres\init" mkdir postgres\init

echo [3/5] Verificando archivos de configuración...
if not exist "docker-compose.yml" (
    echo ✗ Falta docker-compose.yml
    echo Por favor asegúrese de tener todos los archivos del ambiente
    pause
    exit /b 1
)

if not exist "nginx\nginx.conf" (
    echo ✗ Falta nginx\nginx.conf
    pause
    exit /b 1
)

if not exist "php\Dockerfile" (
    echo ✗ Falta php\Dockerfile
    pause
    exit /b 1
)

echo [4/5] Creando configuración default de Nginx...
(
echo server {
echo     listen 80 default_server;
echo     server_name _;
echo     root /var/www/html;
echo     index index.html;
echo.
echo     location /health-check {
echo         return 200 "Laravel Environment Ready";
echo         add_header Content-Type text/plain;
echo     }
echo.
echo     location / {
echo         return 200 "Laravel Docker Environment - Use create-project.bat to create a project";
echo         add_header Content-Type text/plain;
echo     }
echo }
) | Out-File -FilePath nginx\conf.d\default.conf -Encoding utf8

echo [5/5] Construyendo imágenes Docker...
docker-compose build --no-cache php

echo.
echo ============================================
echo     INSTALACION COMPLETADA
echo ============================================
echo.
echo Próximos pasos:
echo 1. Ejecutar: start.bat
echo 2. Crear proyecto: create-project.bat mi-proyecto
echo 3. Acceder: http://mi-proyecto.local
echo.
echo Archivos importantes:
echo - start.bat: Iniciar ambiente
echo - stop.bat: Detener ambiente  
echo - create-project.bat: Crear nuevo proyecto
echo - artisan.bat: Ejecutar comandos Artisan
echo.
pause