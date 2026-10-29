--- Tema 2: Transacciones
--- Venta con control de stock (RN.10)
--- BEGIN TRANSACTION -> registrar venta -> registrar detalle -> descontar stock
--- Implementando un bloque try-catch
--- Encapsulada en un procediemiento 'sp_RegistroVenta'


USE SistemaSportMax;
GO

--- Crear o alterar procedimiento almacenado
CREATE OR ALTER PROCEDURE dbo.sp_RegistroVenta
    @numero_com   INT,
    @cant_cuotas  INT,
    @cod_pago     INT,
    @DNI_cliente  INT,
    @DNI_vendedor INT,
    @cod_producto INT,
    @cantidad     INT
AS
BEGIN 
    DECLARE @stock_actual INT;
	
	BEGIN TRY
		BEGIN TRANSACTION;

--- Stock disponible antes de operar
		SELECT @stock_actual = cant_disponible
		FROM PRODUCTO
		WHERE cod_producto = @cod_producto;

--- Control de existencia del producto
        IF @stock_actual IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('Error: El producto especificado no existe.', 16, 1);
            RETURN;
        END

--- Validación explícita de stock insuficiente (RN.11) dentro del flujo normal
        IF @cantidad > @stock_actual
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'Se ejecuto ROLLBACK. Motivo: stock insuficiente.';
            RETURN;
        END

	--- Registrar venta
		INSERT INTO VENTAS (numero_com, cant_cuotas, cod_pago, DNI_cliente, DNI_vendedor)
        	VALUES (@numero_com, @cant_cuotas, @cod_pago, @DNI_cliente, @DNI_vendedor);

	--- Registrar detalle (el precio historico se copia de precio_actual al momento de la venta)
		INSERT INTO DETALLE_VENTA (cod_producto, numero_com, cantidad, precio_unit)
        	SELECT cod_producto, @numero_com, @cantidad, precio_actual
        	FROM PRODUCTO
	        WHERE cod_producto = @cod_producto;


	--- Descontar stock (la condicion del WHERE evita que el CHECK cant_disponible >= 0 emita un error tecnico)
		UPDATE PRODUCTO
	        SET cant_disponible = cant_disponible - @cantidad
        	WHERE cod_producto = @cod_producto

		   COMMIT TRANSACTION;
		   PRINT 'Venta registrada y stock actualizado.';

    END TRY
    BEGIN CATCH
        --- Ante cualquier error de ejecución imprevisto (ej. clave duplicada)
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT 'Se ejecuto ROLLBACK por error de ejecucion en la transaccion.';
        THROW;
    END CATCH;
END;
GO

