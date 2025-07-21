# Ambiente de Desarrollo Laravel con Docker

Este ambiente de desarrollo proporciona una configuración completa para Laravel con PHP 8.0.30, PostgreSQL, Redis y todas las herramientas necesarias usando Docker y virtualhost.

## 📋 Requisitos

- Docker Desktop para Windows
- PowerShell (incluido en Windows)
- Permisos de administrador (para modificar archivo hosts)

## 🚀 Instalación

1. **Clona o descarga este repositorio**
2. **Crea la estructura de directorios necesaria:**
   ```
   laravel-docker/
   ├── docker-compose.yml
   ├── nginx/
   │   ├── nginx.conf
   │   └── conf.d/
   │       └── laravel-template.conf
   ├── php/
   │   ├── Dockerfile
   │   └── php.ini
   ├── postgres/
   │   └── init/
   │       └── init.sql
   ├── projects/          (se crea automáticamente)
   ├── start.bat
   ├── stop.bat
   ├── create-project.bat
   └── artisan.bat
   ```

3. **Ejecuta el ambiente:**
   ```bash
   start.bat
   ```

## 🔧 Uso

### Crear un nuevo proyecto Laravel

```bash
create-project.bat nombre_proyecto
```

Esto creará:
- Un nuevo proyecto Laravel en `projects/nombre_proyecto/`
- Una configuración de Nginx para `nombre_proyecto.local`
- Una base de datos PostgreSQL llamada `nombre_proyecto_db`
- Una entrada en el archivo hosts de Windows

### Ejecutar comandos Artisan

```bash
# Comando específico
artisan.bat miapp migrate

# Modo interactivo
artisan.bat miapp
```

### Controlar el ambiente

```bash
# Iniciar ambiente
start.bat

# Detener ambiente
stop.bat
```

## 🌐 Servicios Disponibles

- **Nginx**: Puerto 80 (virtualhost)
- **Adminer**: http://localhost:8080
- **Mailhog**: http://localhost:8025
- **Redis**: localhost:6379
- **PostgreSQL**: localhost:5432

## 📂 Estructura de Archivos

```
laravel-docker/
├── projects/                    # Proyectos Laravel
│   ├── proyecto1/
│   ├── proyecto2/
│   └── ...
├── nginx/                       # Configuración Nginx
├── php/                         # Configuración PHP
├── postgres/                    # Configuración PostgreSQL
└── scripts/                     # Scripts de automatización
```

## 🔑 Configuración por Defecto

### Base de Datos
- **Host**: postgres
- **Puerto**: 5432
- **Usuario**: laravel
- **Contraseña**: laravel123
- **Base de datos**: {nombre_proyecto}_db

### Redis
- **Host**: redis
- **Puerto**: 6379

### Email (Mailhog)
- **Host**: mailhog
- **Puerto**: 1025

## 📝 Comandos Útiles

```bash
# Ver logs de un servicio
docker-compose logs -f nginx

# Acceder al contenedor PHP
docker-compose exec php bash

# Ejecutar Composer
docker-compose exec php composer install --working-dir=/var/www/html/proyecto

# Ejecutar NPM
docker-compose exec php npm install --prefix /var/www/html/proyecto

# Reiniciar servicios
docker-compose restart

# Ver estado de contenedores
docker-compose ps
```

## 🛠️ Personalización

### Agregar extensiones PHP
Edita `php/Dockerfile` y agrega las extensiones necesarias:

```dockerfile
RUN docker-php-ext-install nueva_extension
```

### Configurar Nginx
Edita `nginx/conf.d/laravel-template.conf` para personalizar la configuración base de Nginx.

### Configurar PHP
Edita `php/php.ini` para ajustar la configuración de PHP.

## 🔧 Solución de Problemas

### Proyecto no accesible
1. Verifica que la entrada existe en `C:\Windows\System32\drivers\etc\hosts`
2. Reinicia Nginx: `docker-compose restart nginx`

### Permisos de archivos
```bash
docker-compose exec php chown -R www:www /var/www/html/proyecto
docker-compose exec php chmod -R 755 /var/www/html/proyecto
```

### Base de datos no conecta
1. Verifica que PostgreSQL esté corriendo: `docker-compose ps`
2. Verifica la configuración en `.env`

## 🎯 Características

- ✅ PHP 8.0.30 con todas las extensiones necesarias
- ✅ PostgreSQL 13 con extensiones útiles
- ✅ Redis para cache y sesiones
- ✅ Nginx con configuración optimizada
- ✅ Virtualhost automático (no puertos)
- ✅ Mailhog para testing de emails
- ✅ Adminer para gestión de base de datos
- ✅ Scripts automatizados para Windows
- ✅ Configuración de zona horaria (America/Bogota)
- ✅ Soporte para múltiples proyectos
- ✅ Permisos correctos automáticamente

## 🚀 Próximos Pasos

Después de crear tu proyecto, puedes:

1. Acceder a tu aplicación en `http://nombre_proyecto.local`
2. Gestionar la base de datos en `http://localhost:8080`
3. Ver emails en `http://localhost:8025`
4. Ejecutar migraciones con `artisan.bat nombre_proyecto migrate`
5. Instalar dependencias con `docker-compose exec php composer install --working-dir=/var/www/html/nombre_proyecto`