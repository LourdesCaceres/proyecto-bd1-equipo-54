--- Tema 2: Transacciones
--- Venta con control de stock (RN.10)
--- BEGIN TRANSACTION -> registrar venta -> registrar detalle -> descontar stock -> IF/ELSE (ROLLBACK / COMMIT)


USE SistemaSportMax;
GO

--- Parametros de la prueba
--- Caso 1 (stock suficiente):   @numero_com = 2001, @cantidad = 5, 

DECLARE @numero_com   INT = 2001;
DECLARE @cod_producto INT = 3;
DECLARE @cantidad     INT = 5;
DECLARE @stock_actual INT;

BEGIN TRANSACTION;

--- Stock disponible antes de operar
SELECT @stock_actual = cant_disponible
FROM PRODUCTO
WHERE cod_producto = @cod_producto;

--- Registrar venta
INSERT INTO VENTAS (numero_com, cant_cuotas, cod_pago, DNI_cliente, DNI_vendedor)
VALUES (@numero_com, 1, 1, 40543222, 39738523);

--- Registrar detalle (el precio historico se copia de precio_actual al momento de la venta)
INSERT INTO DETALLE_VENTA (cod_producto, numero_com, cantidad, precio_unit)
SELECT cod_producto, @numero_com, @cantidad, precio_actual
FROM PRODUCTO
WHERE cod_producto = @cod_producto;

--- Descontar stock (la condicion del WHERE evita que el CHECK cant_disponible >= 0 emita un error tecnico)
UPDATE PRODUCTO
SET cant_disponible = cant_disponible - @cantidad
WHERE cod_producto = @cod_producto
  AND cant_disponible >= @cantidad;

IF @stock_actual < @cantidad
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Stock insuficiente: se ejecuto ROLLBACK. No quedo venta, detalle ni cambio de stock.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Stock suficiente: se ejecuto COMMIT. Venta registrada y stock actualizado.';
END
GO
