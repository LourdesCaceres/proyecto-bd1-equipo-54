--- Etapa 5 - Tema 2: Transacciones anidadas
--- Aumento masivo de precios por categoria (RN.13), con TRY...CATCH en cada transaccion.
--- Requiere haber ejecutado antes fn_PrecioAjustado.sql (Tema 1).


USE SistemaSportMax;
GO

CREATE PROCEDURE dbo.sp_AjustarPreciosCategoria
    @cod_categoria INT,
    @porcentaje    DECIMAL(5,2)
AS
BEGIN
    DECLARE @precio_tope  DECIMAL(10,2);
    DECLARE @cod_producto INT;

    BEGIN TRY
        /*IF @porcentaje <= 0
            THROW 50001, 'Porcentaje invalido.', 1;*/

        BEGIN TRANSACTION;

        SELECT @precio_tope = MAX(precio_actual) FROM PRODUCTO;

        SELECT @cod_producto = MIN(cod_producto)
        FROM PRODUCTO
        WHERE cod_categoria = @cod_categoria;

        WHILE @cod_producto IS NOT NULL
        BEGIN
            UPDATE PRODUCTO
            SET precio_actual = dbo.fn_PrecioAjustado(precio_actual, @porcentaje)
            WHERE cod_producto = @cod_producto;

            SELECT @cod_producto = MIN(cod_producto)
            FROM PRODUCTO
            WHERE cod_categoria = @cod_categoria
              AND cod_producto > @cod_producto;
        END;

        IF EXISTS (SELECT 1 FROM PRODUCTO WHERE cod_categoria = @cod_categoria AND precio_actual > @precio_tope)
            THROW 50003, 'Supera el precio tope (RN.13).', 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
