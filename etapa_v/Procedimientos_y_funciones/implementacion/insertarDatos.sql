USE SistemaSportMax;
GO

-- Inserción de un lote de datos usando INSERT tradicional de SQL

INSERT INTO PRODUCTO (nombre, precio_actual, cant_disponible, cod_categoria)
VALUES 
('Camiseta Titular Selección Argentina', 45000.00, 50, 1),
('Short de Entrenamiento Deportivo', 25000.00, 35, 1),
('Botella de Agua Térmica 1L', 15000.00, 40, 2);
GO

-- Inserción de otro lote de datos invocados a los SPs creados
-- Aquí usamos el procedimiento almacenado 'sp_InsertarProducto'
EXEC sp_InsertarProducto 
    @nombre = 'Muñequera Toalla Absorbente x2', 
    @precio_actual = 5500.00, 
    @cant_disponible = 80, 
    @cod_categoria = 2;

EXEC sp_InsertarProducto 
    @nombre = 'Mancuernas Hexagonales 5kg', 
    @precio_actual = 35000.00, 
    @cant_disponible = 20, 
    @cod_categoria = 3;

EXEC sp_InsertarProducto 
    @nombre = 'Bolso Deportivo 50 Litros', 
    @precio_actual = 42000.00, 
    @cant_disponible = 12, 
    @cod_categoria = 3;
GO

