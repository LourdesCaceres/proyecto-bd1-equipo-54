USE SistemaSportMax;
GO

-- Retorna el stock disponible de un producto segun su codigo
CREATE FUNCTION fn_ObtenerStockProducto (@cod_prod INT)
RETURNS INT
AS
BEGIN
    DECLARE @stock INT;
    SELECT @stock = cant_disponible FROM PRODUCTO WHERE cod_producto = @cod_prod;
    RETURN ISNULL(@stock, 0);
END;
GO

-- Calcula el monto total gastado por un cliente especifico segun su DNI
CREATE FUNCTION fn_TotalComprasCliente (@dni_cliente INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);
    SELECT @total = SUM(dv.cantidad * dv.precio_unit)
    FROM VENTAS v
    INNER JOIN DETALLE_VENTA dv ON v.numero_com = dv.numero_com
    WHERE v.DNI_cliente = @dni_cliente;
    RETURN ISNULL(@total, 0.00);
END;
GO

-- Calcular el precio final de un producto aplicando un porcentaje de ajuste
CREATE FUNCTION dbo.fn_PrecioAjustado (
    @precio DECIMAL(10,2),
    @porcentaje DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN ROUND(@precio * (1 + @porcentaje / 100.0), 2);
END;
GO