USE SistemaSportMax;
GO

-- Inserción tradicional (Nuevos productos)
-- cod_categoria: 1 = Indumentaria, 2 = Accesorio, 3 = Equipo
INSERT INTO PRODUCTO (nombre, precio_actual, cant_disponible, cod_categoria)
VALUES 
('Camiseta Suplente Alternativa Negra', 47000.00, 45, 1),
('Short Térmico Primera Capa', 23500.00, 30, 1),
('Shaker Mezclador de Proteína 700ml', 9500.00, 65, 2);
GO

-- Inserción usando el procedimiento almacenado sp_InsertarProducto
EXEC sp_InsertarProducto 
    @nombre = 'Cinta Kinesiológica deportiva 5m', 
    @precio_actual = 8500.00, 
    @cant_disponible = 50, 
    @cod_categoria = 2;

EXEC sp_InsertarProducto 
    @nombre = 'Kettlebell de Hierro 10kg', 
    @precio_actual = 48000.00, 
    @cant_disponible = 15, 
    @cod_categoria = 3;

EXEC sp_InsertarProducto 
    @nombre = 'Mochila Urbana Impermeable 35L', 
    @precio_actual = 52000.00, 
    @cant_disponible = 18, 
    @cod_categoria = 3;
GO

-- Actualizar precio y stock utilizando los nombres de los productos recién insertados
DECLARE @id_camisa INT, @id_shaker INT, @id_mochila INT, @id_cinta INT;

SELECT @id_camisa = cod_producto FROM PRODUCTO WHERE nombre = 'Camiseta Suplente Alternativa Negra';
SELECT @id_shaker = cod_producto FROM PRODUCTO WHERE nombre = 'Shaker Mezclador de Proteína 700ml';
SELECT @id_mochila = cod_producto FROM PRODUCTO WHERE nombre = 'Mochila Urbana Impermeable 35L';
SELECT @id_cinta = cod_producto FROM PRODUCTO WHERE nombre = 'Cinta Kinesiológica deportiva 5m';

-- Pruebas de actualización
EXEC sp_ActualizarProducto 
    @cod_producto = @id_camisa, 
    @precio_nuevo = 49500.00, 
    @stock_nuevo = 40;

EXEC sp_ActualizarProducto 
    @cod_producto = @id_shaker, 
    @precio_nuevo = 10200.00, 
    @stock_nuevo = 60;
GO

-- Pruebas de eliminación por SP
DECLARE @id_mochila INT, @id_cinta INT;

SELECT @id_mochila = cod_producto FROM PRODUCTO WHERE nombre = 'Mochila Urbana Impermeable 35L';
SELECT @id_cinta = cod_producto FROM PRODUCTO WHERE nombre = 'Cinta Kinesiológica deportiva 5m';

EXEC sp_EliminarProducto @cod_producto = @id_mochila;
EXEC sp_EliminarProducto @cod_producto = @id_cinta;
GO

-- Eliminamos los productos restantes creados durante las pruebas
DELETE FROM PRODUCTO 
WHERE nombre IN (
    'Camiseta Suplente Alternativa Negra',
    'Short Térmico Primera Capa',
    'Shaker Mezclador de Proteína 700ml',
    'Kettlebell de Hierro 10kg'
);
GO