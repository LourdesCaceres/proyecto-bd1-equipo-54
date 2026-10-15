USE SistemaSportMax;
GO

IF OBJECT_ID('VISTA_COMPROBANTE_VENTA', 'V') IS NOT NULL
    DROP VIEW VISTA_COMPROBANTE_VENTA;
GO

CREATE VIEW VISTA_COMPROBANTE_VENTA AS
SELECT 
    v.numero_com AS [N° Comprobante],
    v.fecha AS [Fecha Venta],
    (p_cli.nombre + ' ' + p_cli.apellido) AS [Cliente],
    p_cli.DNI AS [DNI Cliente],
    (p_ven.nombre + ' ' + p_ven.apellido) AS [Vendedor],
    mp.detalle AS [Medio de Pago],
    v.cant_cuotas AS [Cuotas],
    prod.nombre AS [Producto],
    dv.cantidad AS [Cantidad],
    dv.precio_unit AS [Precio Unitario],
    (dv.cantidad * dv.precio_unit) AS [Subtotal Producto],
    SUM(dv.cantidad * dv.precio_unit) OVER(PARTITION BY v.numero_com) AS [TOTAL VENTA]
FROM VENTAS v
INNER JOIN CLIENTE c ON v.DNI_cliente = c.DNI_cliente
INNER JOIN PERSONA p_cli ON c.DNI_cliente = p_cli.DNI
INNER JOIN VENDEDOR ven ON v.DNI_vendedor = ven.DNI_vendedor
INNER JOIN PERSONA p_ven ON ven.DNI_vendedor = p_ven.DNI
INNER JOIN MED_DE_PAGO mp ON v.cod_pago = mp.cod_pago
INNER JOIN DETALLE_VENTA dv ON v.numero_com = dv.numero_com
INNER JOIN PRODUCTO prod ON dv.cod_producto = prod.cod_producto;
GO

SELECT * 
FROM VISTA_COMPROBANTE_VENTA
WHERE [N° Comprobante] = 1001;
GO