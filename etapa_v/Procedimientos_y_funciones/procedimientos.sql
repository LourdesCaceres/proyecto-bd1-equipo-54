USE SistemaSportMax;
GO

-- Insertar un Producto
CREATE PROCEDURE sp_InsertarProducto
    @nombre VARCHAR(100),
    @precio_actual DECIMAL(10,2),
    @cant_disponible INT,
    @cod_categoria INT
AS
BEGIN
    INSERT INTO PRODUCTO (nombre, precio_actual, cant_disponible, cod_categoria)
    VALUES (@nombre, @precio_actual, @cant_disponible, @cod_categoria);
END;
GO

-- Actualizar un Producto
CREATE PROCEDURE sp_ActualizarProducto
    @cod_producto INT,
    @precio_nuevo DECIMAL(10,2),
    @stock_nuevo INT
AS
BEGIN
    UPDATE PRODUCTO
    SET precio_actual = @precio_nuevo,
        cant_disponible = @stock_nuevo
    WHERE cod_producto = @cod_producto;
END;
GO

-- Eliminar un Producto
CREATE PROCEDURE sp_EliminarProducto
    @cod_producto INT
AS
BEGIN
    DELETE FROM PROVEEDOR_PRODUCTO WHERE cod_producto = @cod_producto;
    DELETE FROM PRODUCTO WHERE cod_producto = @cod_producto;
END;
GO