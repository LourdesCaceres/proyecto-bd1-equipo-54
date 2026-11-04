-- SistemaSportMax - Etapa V - Tema 4: Seguridad
-- *** CASOS DE PRUEBA ***
USE SistemaSportMax;
GO
-- ====== PARTE 1 - PERMISOS A NIVEL DE USUARIO ====== 

-- Caso 1: INSERT directo con usuario_admin (db_owner) - RESULTADO ESPERADO: ÉXITO (Fila afectada)
EXECUTE AS USER = 'usuario_admin';
GO
    PRINT '--- Caso 1: INSERT directo como usuario_admin ---';
    INSERT INTO dbo.PRODUCTO (nombre, precio_actual, cant_disponible, cod_categoria)
    VALUES ('Botines Admin', 45000.00, 10, 13);
GO
REVERT;
GO

-- Caso 2: INSERT directo con usuario_repositor (db_datareader) - RESULTADO ESPERADO: ERROR (Permiso denegado)
EXECUTE AS USER = 'usuario_repositor';
GO
    PRINT '--- Caso 2: INSERT directo como usuario_repositor ---';
    INSERT INTO dbo.PRODUCTO (nombre, precio_actual, cant_disponible, cod_categoria)
    VALUES ('Botines Repositor Directo', 30000.00, 5, 14);
GO
REVERT;
GO

-- Caso 3: INSERT mediante Procedimiento con usuario_repositor - RESULTADO ESPERADO: ÉXITO. 
-- Aunque no puede hacer INSERT directo, tiene GRANT EXECUTE sobre el procedimiento.
EXECUTE AS USER = 'usuario_repositor';
GO
    PRINT '--- Caso 3: INSERT mediante SP como usuario_repositor ---';
    EXEC dbo.sp_InsertarProducto
         @nombre = N'PRUEBA_SEG_SP',
         @precio_actual = 1000.00,
         @cant_disponible = 1,
         @cod_categoria = 1;
GO
REVERT;
GO

-- ====== PARTE 2 - PERMISOS A NIVEL DE ROLES ====== 

-- Caso 2.1: SELECT con usuario_con_rol - RESULTADO ESPERADO: ÉXITO.
EXECUTE AS USER = 'usuario_con_rol';
GO
    PRINT '--- Caso 2.1: SELECT como usuario_con_rol ---';
    SELECT * FROM dbo.PRODUCTO;
GO
REVERT;
GO

-- Caso 2.2: SELECT con usuario_sin_rol - RESULTADO ESPERADO: ERROR (Permiso denegado). No pertenece a ningún rol 
EXECUTE AS USER = 'usuario_sin_rol';
GO
    PRINT '--- Caso 2.2: SELECT como usuario_sin_rol ---';
    SELECT * FROM dbo.PRODUCTO;
GO
REVERT;
GO
