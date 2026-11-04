USE SistemaSportMax;
GO

----------------------------------------------------------------------------------
-- 1. CARGA MASIVA (1 millón de registros sin índice en fecha)
----------------------------------------------------------------------------------
IF OBJECT_ID('VENTAS_MASIVA', 'U') IS NOT NULL
    DROP TABLE VENTAS_MASIVA;
GO

CREATE TABLE VENTAS_MASIVA (
    id_venta INT IDENTITY(1,1) NOT NULL,
    fecha DATETIME NOT NULL,
    total_venta DECIMAL(10,2) NOT NULL,
    dni_cliente INT NOT NULL
);
GO

DECLARE @contador INT = 1;
DECLARE @lote INT = 100000;

WHILE @contador <= 1000000
BEGIN
    INSERT INTO VENTAS_MASIVA (fecha, total_venta, dni_cliente)
    SELECT TOP (@lote)
        DATEADD(SECOND, ABS(CHECKSUM(NEWID())) % 51840000, '2025-01-01 00:00:00'),
        CAST((ABS(CHECKSUM(NEWID())) % 85000) + 5000 AS DECIMAL(10,2)),
        40000000 + (ABS(CHECKSUM(NEWID())) % 10000)
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b;

    SET @contador = @contador + @lote;
END;
GO

----------------------------------------------------------------------------------
-- 2. BÚSQUEDA POR PERÍODO (SIN ÍNDICE)
----------------------------------------------------------------------------------
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT 
    id_venta, 
    fecha, 
    total_venta, 
    dni_cliente
FROM VENTAS_MASIVA
WHERE fecha >= '2025-10-01 00:00:00' 
  AND fecha <= '2025-10-31 23:59:59';
GO

----------------------------------------------------------------------------------
-- 3. CREAR ÍNDICE AGRUPADO EN FECHA Y REPETIR CONSULTA
----------------------------------------------------------------------------------
CREATE CLUSTERED INDEX VENTAS_AGRUPADAS
ON VENTAS_MASIVA (fecha);
GO

SELECT 
    id_venta, 
    fecha, 
    total_venta, 
    dni_cliente
FROM VENTAS_MASIVA
WHERE fecha >= '2025-10-01 00:00:00' 
  AND fecha <= '2025-10-31 23:59:59';
GO

----------------------------------------------------------------------------------
-- 4. BORRAR EL ÍNDICE CREADO
----------------------------------------------------------------------------------
DROP INDEX VENTAS_AGRUPADAS ON VENTAS_MASIVA;
GO

----------------------------------------------------------------------------------
-- 5. CREAR ÍNDICE CON COLUMNAS INCLUIDAS (INCLUDE) Y REPETIR CONSULTA
----------------------------------------------------------------------------------
CREATE NONCLUSTERED INDEX VENTAS_AGRUPADAS
ON VENTAS_MASIVA (fecha)
INCLUDE (total_venta, dni_cliente);
GO

SELECT 
    id_venta, 
    fecha, 
    total_venta, 
    dni_cliente
FROM VENTAS_MASIVA
WHERE fecha >= '2025-10-01 00:00:00' 
  AND fecha <= '2025-10-31 23:59:59';
GO

----------------------------------------------------------------------------------
-- LIMPIEZA FINAL DE ESTADÍSTICAS
----------------------------------------------------------------------------------
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO