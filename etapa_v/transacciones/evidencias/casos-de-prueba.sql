USE SistemaSportMax;
GO

--- Estado ANTES de la transaccion
SELECT N'ESTADO ANTERIOR A LA TRANSACCIÓN' AS [Estado];

SELECT cod_producto, nombre, cant_disponible
FROM PRODUCTO;
GO
--- totales generales
SELECT
    COUNT(DISTINCT v.numero_com)                 AS total_ventas_realizadas,
    ISNULL(SUM(dv.cantidad * dv.precio_unit), 0) AS monto_total_vendido
FROM VENTAS v
LEFT JOIN DETALLE_VENTA dv
    ON v.numero_com = dv.numero_com;
GO

--- ========================================
--- CASOS DE PRUEBA
--- Caso 1: stock suficiente (esperado: COMMIT)
EXEC dbo.sp_RegistroVenta
    @numero_com = 2001, @cant_cuotas = 1, @cod_pago = 1,
    @DNI_cliente = 40543222, @DNI_vendedor = 39738523,
    @cod_producto = 3, @cantidad = 2;
GO

--- Verificacion (resultado obtenido)
SELECT N'VERIFICACIÓN CASO 1' AS [Resultado];
SELECT * FROM VENTAS        WHERE numero_com IN (2001);
SELECT * FROM DETALLE_VENTA WHERE numero_com IN (2001);
SELECT cod_producto, nombre, cant_disponible FROM PRODUCTO WHERE cod_producto = 3;
GO

--- Caso 2: stock insuficiente (esperado: ROLLBACK)
EXEC dbo.sp_RegistroVenta
    @numero_com = 2002, @cant_cuotas = 1, @cod_pago = 1,
    @DNI_cliente = 40543222, @DNI_vendedor = 39738523,
    @cod_producto = 3, @cantidad = 500;
GO
 
--- Verificacion (resultado obtenido)
SELECT N'VERIFICACIÓN CASO 2' AS [Resultado];
SELECT * FROM VENTAS        WHERE numero_com IN (2002);
SELECT * FROM DETALLE_VENTA WHERE numero_com IN (2002);
SELECT cod_producto, nombre, cant_disponible FROM PRODUCTO WHERE cod_producto = 3;
GO

--- Caso 3: error de ejecucion, numero_com repetido (esperado: ROLLBACK y stock sin cambios)
EXEC dbo.sp_RegistroVenta
    @numero_com = 2001, @cant_cuotas = 1, @cod_pago = 1,
    @DNI_cliente = 40543222, @DNI_vendedor = 39738523,
    @cod_producto = 5, @cantidad = 5;
GO

--- Verificacion (resultado obtenido)
SELECT N'VERIFICACIÓN CASO 3' AS [Resultado];
SELECT * FROM VENTAS        WHERE numero_com IN (2001);
SELECT * FROM DETALLE_VENTA WHERE numero_com IN (2001);
SELECT cod_producto, nombre, cant_disponible FROM PRODUCTO WHERE cod_producto = 5;
GO

--- Caso 4: producto inexistente (esperado: ROLLBACK por producto no encontrado)
EXEC dbo.sp_RegistroVenta    
    @numero_com = 2003, @cant_cuotas = 1, @cod_pago = 1,
    @DNI_cliente = 40543222, @DNI_vendedor = 39738523,
    @cod_producto = 12, @cantidad = 2;
GO

--- Verificacion (resultado obtenido)
SELECT N'VERIFICACIÓN CASO 4' AS [Resultado];
SELECT * FROM VENTAS        WHERE numero_com IN (2003);
SELECT * FROM DETALLE_VENTA WHERE numero_com IN (2003);
SELECT cod_producto, nombre, cant_disponible FROM PRODUCTO WHERE cod_producto = 12;
GO

--- ========================================
--- ESTADO POSTERIOR A LA TRANSACCION
SELECT N'ESTADO POSTERIOR A LA TRANSACCIÓN' AS [Estado];

/*
--- Ver detalle de la venta realizada con éxito resultado (venta 2001)
DECLARE @numero_com   INT = 2001;
DECLARE @cod_producto INT = 3;

--- Venta, con el nombre del cliente
SELECT
    v.numero_com,
    v.fecha,
    v.cant_cuotas,
    v.cod_pago,
    v.DNI_cliente,
    p.nombre + ' ' + p.apellido AS cliente,
    v.DNI_vendedor,
     (SELECT ISNULL(SUM(dv.cantidad * dv.precio_unit), 0)
     FROM DETALLE_VENTA dv
     WHERE dv.numero_com = v.numero_com) AS total_venta
FROM VENTAS v
INNER JOIN PERSONA p
    ON v.DNI_cliente = p.DNI
WHERE v.numero_com = @numero_com;

--- Detalle de la venta, con el nombre del producto
SELECT
    dv.numero_com,
    dv.cod_producto,
    prod.nombre AS producto,
    dv.precio_unit,
    dv.cantidad,
    dv.cantidad * dv.precio_unit AS subtotal
FROM DETALLE_VENTA dv
INNER JOIN PRODUCTO prod
    ON dv.cod_producto = prod.cod_producto
WHERE dv.numero_com = @numero_com;
*/

SELECT cod_producto, nombre, cant_disponible
FROM PRODUCTO;
GO

--- totales generales
SELECT
    COUNT(DISTINCT v.numero_com)                 AS total_ventas_realizadas,
    ISNULL(SUM(dv.cantidad * dv.precio_unit), 0) AS monto_total_vendido
FROM VENTAS v
LEFT JOIN DETALLE_VENTA dv
    ON v.numero_com = dv.numero_com;
GO
