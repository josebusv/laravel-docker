@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo Error: Debe proporcionar el nombre del proyecto
    echo Uso: artisan.bat nombre_proyecto [comando_artisan]
    echo Ejemplo: artisan.bat miapp migrate
    exit /b 1
)

set PROJECT_NAME=%1
shift

set COMMAND=
:loop
if "%1"=="" goto :done
set COMMAND=%COMMAND% %1
shift
goto :loop

:done

if "%COMMAND%"=="" (
    echo Ejecutando Artisan en modo interactivo para proyecto: %PROJECT_NAME%
    docker-compose exec php php /var/www/html/%PROJECT_NAME%/artisan
) else (
    echo Ejecutando: php artisan%COMMAND% en proyecto %PROJECT_NAME%
    docker-compose exec php php /var/www/html/%PROJECT_NAME%/artisan%COMMAND%
)