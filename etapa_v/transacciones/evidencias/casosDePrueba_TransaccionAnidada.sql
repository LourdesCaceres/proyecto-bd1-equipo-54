USE SistemaSportMax;
GO

--- Estado ANTES de la transaccion
SELECT N'ESTADO ANTERIOR AL AUMENTO' AS [Estado];
--- Estado inicial (productos con la descripcion de su categoria)
SELECT
    c.cod_categoria,
    c.descripcion AS categoria,
    p.cod_producto,
    p.nombre,
    p.precio_actual
FROM PRODUCTO p
INNER JOIN CATEGORIA c
    ON p.cod_categoria = c.cod_categoria
ORDER BY c.cod_categoria, p.cod_producto;
GO

--- ========================================
--- CASOS DE PRUEBA
--- Caso 1: Accesorio (2) +10 %  (esperado: COMMIT; 6050.00, 13200.00 y 16500.00)
EXEC dbo.sp_AjustarPreciosCategoria @cod_categoria = 2, @porcentaje = 10;
GO
SELECT cod_producto, nombre, precio_actual FROM PRODUCTO WHERE cod_categoria = 2;
GO

--- Caso 2: Equipo (3) +110 %  (esperado: ROLLBACK; el Bolso llegaria a 88200.00 y supera el tope; los tres precios no cambian)
EXEC dbo.sp_AjustarPreciosCategoria @cod_categoria = 3, @porcentaje = 110;
GO
SELECT cod_producto, nombre, precio_actual FROM PRODUCTO WHERE cod_categoria = 3;
GO

--- Caso 3: Indumentaria (1) +1 %  (esperado: ROLLBACK; las Zapatillas llegarian a 85850.00 y superan el tope)
EXEC dbo.sp_AjustarPreciosCategoria @cod_categoria = 1, @porcentaje = 1;
GO
SELECT cod_producto, nombre, precio_actual FROM PRODUCTO WHERE cod_categoria = 1;
GO

--- Caso 4: porcentaje no valido (esperado: error 50001 antes de abrir la transaccion)
EXEC dbo.sp_AjustarPreciosCategoria @cod_categoria = 2, @porcentaje = -8;
GO

--- Caso 5: procedimiento interno ejecutado solo (esperado: @@TRANCOUNT 1 -> 0, COMMIT real)
EXEC dbo.sp_ActualizarPrecio @cod_producto = 4, @porcentaje = 10;
GO


--- ========================================
--- ESTADO POSTERIOR A LA TRANSACCION
SELECT N'ESTADO POSTERIOR A LA TRANSACCIÓN' AS [Estado];
SELECT
    c.cod_categoria,
    c.descripcion AS categoria,
    p.cod_producto,
    p.nombre,
    p.precio_actual
FROM PRODUCTO p
INNER JOIN CATEGORIA c
    ON p.cod_categoria = c.cod_categoria
ORDER BY c.cod_categoria, p.cod_producto;
GO

--- Limpieza: restaurar los precios originales de la Etapa 3 (Accesorio, tras los casos 1 y 5)
--- UPDATE PRODUCTO
--- SET precio_actual = CASE cod_producto WHEN 4 THEN 12000.00 WHEN 5 THEN 15000.00 WHEN 6 THEN 5500.00 END
--- WHERE cod_producto IN (4, 5, 6);
--- GO
