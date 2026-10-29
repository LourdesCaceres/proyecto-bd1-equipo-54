USE SistemaSportMax_Pruebas;
GO

--- Demostracion
--- Cada llamada va en su propio lote (GO), porque el procedimiento vuelve a lanzar el error.
 
--- Caso 1: stock suficiente (esperado: COMMIT)
EXEC dbo.sp_RegistroVenta
    @numero_com = 3001, @cant_cuotas = 1, @cod_pago = 1,
    @DNI_cliente = 40543222, @DNI_vendedor = 39738523,
    @cod_producto = 3, @cantidad = 5;
GO

--- Caso 2: stock insuficiente (esperado: ROLLBACK)
EXEC dbo.sp_RegistroVenta
    @numero_com = 3002, @cant_cuotas = 1, @cod_pago = 1,
    @DNI_cliente = 40543222, @DNI_vendedor = 39738523,
    @cod_producto = 3, @cantidad = 500;
GO
 
--- Caso 3: error de ejecucion, numero_com repetido (esperado: ROLLBACK y stock sin cambios)
EXEC dbo.sp_RegistroVenta
    @numero_com = 3001, @cant_cuotas = 1, @cod_pago = 1,
    @DNI_cliente = 40543222, @DNI_vendedor = 39738523,
    @cod_producto = 3, @cantidad = 5;
GO

--- Caso 4: producto inexistente (esperado: ROLLBACK por producto no encontrado)
EXEC dbo.sp_RegistroVenta    
    @numero_com = 3003, @cant_cuotas = 1, @cod_pago = 1,
    @DNI_cliente = 40543222, @DNI_vendedor = 39738523,
    @cod_producto = 12, @cantidad = 2;
GO
