USE SistemaSportMax;
GO

-- Actualizar el precio y stock de un producto usando el SP
EXEC sp_ActualizarProducto 
    @cod_producto = 1, 
    @precio_nuevo = 48000.00, 
    @stock_nuevo = 45;

EXEC sp_ActualizarProducto 
    @cod_producto = 3, 
    @precio_nuevo = 89000.00, 
    @stock_nuevo = 10;
GO

-- Eliminar un producto asegurándonos de que limpie sus dependencias
EXEC sp_EliminarProducto @cod_producto = 10;

EXEC sp_EliminarProducto @cod_producto = 6;
GO