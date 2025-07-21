-- Configuración inicial de PostgreSQL para Laravel

-- Crear extensiones útiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- Configurar timezone
SET timezone = 'America/Bogota';

-- Mensaje de confirmación
SELECT 'PostgreSQL configurado correctamente para Laravel' AS status;