USE SistemaSportMax;
GO

--- ==========================================
--- Procedimiento Interno: Actualización por producto
--- ==========================================
CREATE OR ALTER PROCEDURE dbo.sp_ActualizarPrecio
    @cod_producto INT,
    @porcentaje   DECIMAL(5,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        --- Uso de la función almacenada, del tema 1
        UPDATE PRODUCTO
        SET precio_actual = dbo.fn_PrecioAjustado(precio_actual, @porcentaje)
        WHERE cod_producto = @cod_producto;

        IF @@ROWCOUNT = 0
            THROW 50005, 'Producto inexistente.', 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        --- Si se ejecuta de forma individual, hace rollback local.
        --- Si está anidado (@@TRANCOUNT > 1), el rollback global lo gestiona el procedimiento externo.
        IF @@TRANCOUNT = 1
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

--- ==========================================
--- Procedimiento Externo: Ajuste masivo por categoría
--- ==========================================
CREATE OR ALTER PROCEDURE dbo.sp_AjustarPreciosCategoria
    @cod_categoria INT,
    @porcentaje    DECIMAL(5,2)
AS
BEGIN

    DECLARE @precio_tope  DECIMAL(10,2);
    DECLARE @cod_producto INT;

    BEGIN TRY
        IF @porcentaje <= 0
            THROW 50001, 'La regla RN.13 aplica solo a aumentos (porcentaje mayor que 0).', 1;
        IF NOT EXISTS (SELECT 1 FROM PRODUCTO WHERE cod_categoria = @cod_categoria)
            THROW 50006, 'Categoría inexistente o sin productos.', 1;

        BEGIN TRANSACTION;

        --- Obtener el precio tope global antes del aumento
        SELECT @precio_tope = MAX(precio_actual) FROM PRODUCTO;

        --- Recorrer los productos de la categoría
        SELECT @cod_producto = MIN(cod_producto)
        FROM PRODUCTO
        WHERE cod_categoria = @cod_categoria;

        WHILE @cod_producto IS NOT NULL
        BEGIN
            --- Ejecución del procedimiento interno (Transacción Anidada)
            EXEC dbo.sp_ActualizarPrecio @cod_producto = @cod_producto, @porcentaje = @porcentaje;

            SELECT @cod_producto = MIN(cod_producto)
            FROM PRODUCTO
            WHERE cod_categoria = @cod_categoria
              AND cod_producto > @cod_producto;
        END;

        --- Validación RN.13: Si algún producto supera el precio tope global, se aborta todo
        IF EXISTS (SELECT 1 
                   FROM PRODUCTO 
                   WHERE cod_categoria = @cod_categoria 
                     AND precio_actual > @precio_tope)
            THROW 50003, 'Un producto supera el precio tope (RN.13).', 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
