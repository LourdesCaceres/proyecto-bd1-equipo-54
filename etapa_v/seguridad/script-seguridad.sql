-- Etapa V - tema 4: "Seguridad: Manejo de permisos a nivel de usuarios y roles en SQL Server"

/*
=============================================================================
Integrar script de seguridad a la BD aplicando permisos tanto a nivel de usuarios como de roles. 
- Crea inicios de sesión (Logins)
- Crea usuarios (Users)
- Asigna roles fijos (db_owner, db_datareader) y permisos (EXECUTE).
- Crea un rol personalizado, le asigna permisos (SELECT) y agrega miembros.
- Utiliza bloques condicionales (IF NOT EXISTS) en las creaciones para 
  garantizar que el script sea seguro.
=============================================================================
*/

USE SistemaSportMax;
GO

-- *** 1. Usuarios con permisos nivel usuario  ***

-- Crear inicios de sesión (Logins) en el servidor
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_admin')
    CREATE LOGIN usuario_admin WITH PASSWORD = 'adMin456+';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_repositor')
    CREATE LOGIN usuario_repositor WITH PASSWORD = 'rePositor567+';
GO

-- Crear usuarios en la base de datos
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_admin' AND type = 'S')
    CREATE USER usuario_admin FOR LOGIN usuario_admin;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_repositor' AND type = 'S')
    CREATE USER usuario_repositor FOR LOGIN usuario_repositor;
GO

-- Asignaciones de permisos
-- Usuario con permisos de Administrador
ALTER ROLE db_owner ADD MEMBER usuario_admin;
GO

-- Usuario con permisos de lectura
ALTER ROLE db_datareader ADD MEMBER usuario_repositor;
GO

-- Asignar procedimiento para registrar nuevos productos
GRANT EXECUTE ON dbo.sp_InsertarProducto TO usuario_repositor;
GO

-- *** 2. Usuarios con permisos nivel rol  ***

-- Crear inicios de sesión en el servidor
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_con_rol')
    CREATE LOGIN usuario_con_rol WITH PASSWORD = 'roL321+';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_sin_rol')
    CREATE LOGIN usuario_sin_rol WITH PASSWORD = 'sinRol321+';
GO

-- Crear usuarios en la base de datos
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_con_rol' AND type = 'S')
    CREATE USER usuario_con_rol FOR LOGIN usuario_con_rol;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_sin_rol' AND type = 'S')
    CREATE USER usuario_sin_rol FOR LOGIN usuario_sin_rol;
GO

-- Creacion de un rol personalizado 'rol_consulta_productos'
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_consulta_productos' AND type = 'R')
BEGIN
    CREATE ROLE rol_consulta_productos;
END
GO

-- Otorgar permisos de consulta al rol personalizado
GRANT SELECT ON dbo.PRODUCTO TO rol_consulta_productos;
GO

-- Asignación del rol a un usuario
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_con_rol;
GO
