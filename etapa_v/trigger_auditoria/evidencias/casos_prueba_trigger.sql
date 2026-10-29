--CASOS DE PRUEBA--
USE SistemaSportMax;
GO

--CASO 1: modificar un producto--
--Consultamos los valores originales--
SELECT *
FROM PRODUCTO
WHERE cod_producto = 1;
GO

--Modificamos valores--
UPDATE PRODUCTO
SET precio_actual = 48000.00,
    cant_disponible = 45
WHERE cod_producto = 1;
GO

--Verificamos--
SELECT *
FROM PRODUCTO
WHERE cod_producto = 1;
GO

--Consultamos la auditoría de modificaciones
SELECT *
FROM AUDITORIA_PRODUCTOS
WHERE cod_producto = 1
ORDER BY id_auditoria DESC;
GO


--CASO 2: eliminar un producto--
--Creamos un producto de prueba--
INSERT INTO PRODUCTO
    (nombre, precio_actual, cant_disponible, cod_categoria)
VALUES
    ('Producto Prueba Auditoria', 10000.00, 10, 1);
GO

SELECT *
FROM PRODUCTO
WHERE nombre = 'Producto Prueba Auditoria';
GO

--Eliminamos el producto--
DELETE FROM PRODUCTO
WHERE nombre = 'Producto Prueba Auditoria';
GO

--Comprobamos que ya no existe--
SELECT *
FROM PRODUCTO
WHERE nombre = 'Producto Prueba Auditoria';
GO

--Comprobamos que se guardó en la tabla de eliminados--
SELECT *
FROM PRODUCTOS_ELIMINADOS
ORDER BY id_auditoria DESC;
GO

--Caso 3: límites y erróneos--
--Stock igual a 0--
UPDATE PRODUCTO
SET cant_disponible = 0
WHERE cod_producto = 2;
GO

SELECT *
FROM PRODUCTO
WHERE cod_producto = 2;
GO

SELECT *
FROM AUDITORIA_PRODUCTOS
WHERE cod_producto = 2
ORDER BY id_auditoria DESC;
GO

--Precio igual a 0--
UPDATE PRODUCTO
SET precio_actual = 0
WHERE cod_producto = 2;
GO

SELECT *
FROM AUDITORIA_PRODUCTOS
WHERE cod_producto = 2
ORDER BY id_auditoria DESC;
GO

--Caso 4: intentar eliminar una categoria--
--Verificamos primero--
SELECT *
FROM CATEGORIA
WHERE cod_categoria = 1;
GO

--Intentamos eliminarla--
DELETE FROM CATEGORIA
WHERE cod_categoria = 1;
GO

--Comprobamos que sigue existiendo--
SELECT *
FROM CATEGORIA
WHERE cod_categoria = 1;
GO

--Verificamos si la acción fue registrada--
SELECT *
FROM AUDITORIA
WHERE tabla_afectada = 'CATEGORIA'
ORDER BY id_auditoria DESC;
GO

--Caso 5: modificar un proveedor--
--Consultamos el proveedor--
SELECT *
FROM PROVEEDOR
WHERE CUIT = 55634675;
GO

--Cambiamos el teléfono--
UPDATE PROVEEDOR
SET telefono = 34556757
WHERE CUIT = 55634675;
GO

--Verificamos--
SELECT *
FROM PROVEEDOR
WHERE CUIT = 55634675;
GO

--Consultamos el registro--
SELECT *
FROM AUDITORIA
WHERE tabla_afectada = 'PROVEEDOR'
ORDER BY id_auditoria DESC;
GO