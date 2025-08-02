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

# Laravel Docker Environment

Este entorno te permite crear, registrar y administrar múltiples proyectos Laravel usando Docker en Windows, con herramientas integradas para desarrollo, depuración y calidad de código.

---

## Requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Git](https://git-scm.com/)
- Windows 10/11

---

## Instalación del entorno

1. **Clona este repositorio**  
   ```sh
   git clone https://tu-repo.git c:\laravel-docker
   cd c:\laravel-docker
   ```

2. **Ejecuta la instalación inicial**  
   Haz doble clic en `install.bat` o ejecuta en terminal:
   ```
   install.bat
   ```

---

## Uso básico

### Iniciar el entorno

```
start.bat
```

Esto levantará los servicios base (PostgreSQL, Redis, Adminer, Mailhog, PHP, Nginx).

### Crear un nuevo proyecto Laravel

```
create-project.bat nombre_proyecto
```

Esto creará un nuevo proyecto en `projects\nombre_proyecto`, configurará Nginx, la base de datos y las herramientas de calidad de código.

### Registrar un proyecto Laravel existente

```
register-project.bat nombre_proyecto
```

Esto configura Nginx y la base de datos para un proyecto ya existente en la carpeta `projects`.

### Detener el entorno

```
stop.bat
```

---

## Comandos útiles

- **Comandos Artisan**  
  ```
  artisan.bat nombre_proyecto [comando_artisan]
  ```
  Ejemplo:
  ```
  artisan.bat miapp migrate
  ```

- **Analizar calidad de código**  
  ```
  quality.bat nombre_proyecto
  ```
  Esto ejecuta PHPStan y PHP_CodeSniffer sobre el proyecto.

- **Instalar dependencias NPM**  
  ```
  docker-compose exec php npm install --prefix /var/www/html/nombre_proyecto
  ```

---

## Servicios disponibles

- **App:** http://nombre_proyecto.local  
- **Adminer:** http://localhost:8080  
- **Mailhog:** http://localhost:8025  
- **Redis:** localhost:6379  
- **PostgreSQL:** localhost:5432  

---

## Herramientas de calidad y depuración

- **PHPStan & Larastan:** Análisis estático de código PHP/Laravel.
- **PHP_CodeSniffer:** Revisión de estilo PSR-12.
- **Xdebug:** Depuración paso a paso (configura tu IDE para usar el puerto 9003).

---

## CI/CD

Incluye ejemplo de workflow para GitHub Actions en `.github/workflows/ci.yml` para pruebas y análisis automáticos.

---

## Notas

- Cada nuevo proyecto incluye scripts de calidad en `composer.json`:
  - `composer analyse`
  - `composer cs`
- Puedes personalizar la configuración de Nginx y PHP en las carpetas `nginx` y `php`.

---

¿Dudas o problemas?  
Revisa los scripts `.bat` o abre un issue en el