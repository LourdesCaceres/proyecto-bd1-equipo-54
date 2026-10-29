---IMPLEMENTACIÓN DE TRIGGERS---
--PRIMERA PARTE--
--Empezamos creando una tabla auxiliar auditoría que servirá para cada una de las tablas--

USE SistemaSportMax;
GO

CREATE TABLE AUDITORIA (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    tabla_afectada VARCHAR(50) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    valores_anteriores NVARCHAR(MAX) NOT NULL,
    fecha_hora DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    usuario_bd SYSNAME NOT NULL
);
GO

--Tabla auxiliar de auditoría que registrará las modificaciones de los productos--
--guardando su valor y stock anterior junto a los valores nuevos.--
CREATE TABLE AUDITORIA_PRODUCTOS (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    cod_producto INT NOT NULL,
    precio_antes DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    stock_antes INT,
    stock_nuevo INT,
    fecha DATETIME2 NOT NULL,
    usuario SYSNAME NOT NULL
);
GO

--Trigger sobre la actualización de elementos de la tabla PRODUCTO--
--Solo lo implementamos en PRODUCTO para probar la actualización de precios y su registro--
CREATE TRIGGER TR_PRODUCTOS_AUDITORIA
ON PRODUCTO
AFTER UPDATE
AS
BEGIN
--NOCOUNT evita el envío mensajes adicionales sobre la cantidad de filas afectadas-- 
    SET NOCOUNT ON;

    INSERT INTO AUDITORIA_PRODUCTOS
        (cod_producto, precio_antes, precio_nuevo,
         stock_antes, stock_nuevo, fecha, usuario)
    SELECT
        d.cod_producto,
        d.precio_actual,
        i.precio_actual,
        d.cant_disponible,
        i.cant_disponible,
--SYSDATETIME() obtiene el tiempo real de ejecución de la modificación y SUSER_NAME()--
--obtiene el usuario--
        SYSDATETIME(),
        SUSER_SNAME()
    FROM inserted i
--INNER JOIN para poder tener el valor anterior del producto y el valor nuevo--
    INNER JOIN deleted d
        ON i.cod_producto = d.cod_producto;
END;
GO

--Tabla auxiliar donde se guardarán los datos de los productos eliminados--
CREATE TABLE PRODUCTOS_ELIMINADOS (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    cod_producto INT,
    nombre VARCHAR(100),
    precio_actual DECIMAL(10,2),
    cant_disponible INT,
    fecha DATETIME2,
    usuario SYSNAME
);
GO

--Trigger para el DELETE de PRODUCTO--
CREATE TRIGGER TR_PRODUCTOS_DELETE
ON PRODUCTO
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PRODUCTOS_ELIMINADOS
        (cod_producto, nombre, precio_actual,
         cant_disponible, fecha, usuario)
    SELECT
        d.cod_producto,
        d.nombre,
        d.precio_actual,
        d.cant_disponible,
        SYSDATETIME(),
        SUSER_SNAME()
    FROM deleted d;
END;
GO


--Trigger para todas las demás tablas, simplificado--
--Declaración de variables, el primero representa la tabla específica--
--y el segundo almacena el código para cada trigger--
DECLARE @tabla SYSNAME;
DECLARE @sql NVARCHAR(MAX);

--Utilizamos un cursor para recorrer los resultados en cada tabla, seleccionandolo--
--por su nombre, el cursor no modifica nada y solo lo implementamos para escribir menos--
--líneas al no tener que definir un trigger para cada tabla--
DECLARE tablas CURSOR FOR
SELECT nombre
FROM (VALUES
    ('PERSONA'),
    ('MED_DE_PAGO'),
    ('CATEGORIA'),
    ('PROVEEDOR'),
    ('CLIENTE'),
    ('VENDEDOR'),
    ('VENTAS'),
    ('DETALLE_VENTA'),
    ('PROVEEDOR_PRODUCTO')
) AS T(nombre);

--Abre el cursor, obtiene la primer fila y guarda su valor en la variable tabla--
OPEN tablas;
FETCH NEXT FROM tablas INTO @tabla;

--Ciclo donde se recorrerá cada tabla hasta que terminar el cursor o llegar a un elemento que active--
--el trigger--
WHILE @@FETCH_STATUS = 0
BEGIN
    --Construye un trigger para cada tabla, guardando en una variable--
    --el código como texto concatenado--
    SET @sql = N'
    CREATE TRIGGER dbo.' + QUOTENAME('TR_AUDITAR_' + @tabla) + N'
    ON dbo.' + QUOTENAME(@tabla) + N'
    AFTER UPDATE, DELETE
    AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO dbo.AUDITORIA
            (tabla_afectada, operacion, valores_anteriores,
             fecha_hora, usuario_bd)
        SELECT
            N''' + @tabla + N''',
            CASE
                WHEN EXISTS (SELECT 1 FROM inserted)
                    THEN ''UPDATE''
                ELSE ''DELETE''
            END,
            (SELECT * FROM deleted
             FOR JSON PATH, INCLUDE_NULL_VALUES),
            SYSDATETIME(),
            SUSER_SNAME()
        WHERE EXISTS (SELECT 1 FROM deleted);
    END;';

 --Lo que está en rojo es código SQL que es guardado como una cadena, la--
 --siguiente línea hace que el programa interprete y ejecute la cadena como SQL--
    EXEC sys.sp_executesql @sql;

--Pasa a la siguiente tabla--
    FETCH NEXT FROM tablas INTO @tabla;
END;

CLOSE tablas;
DEALLOCATE tablas;
GO


--SEGUNDA PARTE--
--Trigger que impide la eliminación de un elemento en una tabla--
--Utilizamos la tabla CATEGORIA porque fue la que consideramos más apropiada--
CREATE TRIGGER TR_IMPEDIR_DELETE_CATEGORIA
ON CATEGORIA
--INSTEAD OF, impide que se elimine, reemplazando el DELETE por un mensaje de error--
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    --Imprime un mensaje de error para informar al usuario--
    RAISERROR(
        'Operacion rechazada: no se permite eliminar categorias.',
        16,
        1
    );

    RETURN;
END;
GO