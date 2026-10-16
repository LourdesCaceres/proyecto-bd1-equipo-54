-------- Informe Ventas (mes Septiembre)
-- Queremos obtener el total de ventas realizadas y el monto total recaudado por
-- cada vendedor durante el mes de septiembre de 2026. 
-- Se incluyen todos los vendedores, incluso aquellos que no registraron ventas en ese período.

-- Seleccionamos los datos del vendedor y utilizamos funciones agregadas: 
-- COUNT(DISTINCT ...) para contar las ventas únicas
-- COALESCE() con SUM() para calcular el monto total y colocar un 0 en caso de que sea nulo.
USE SistemaSportMax;
GO

SELECT 
    Vend.cod_vendedor,
    P.nombre, 
    P.apellido, 
    COUNT(DISTINCT V.numero_com) AS ventas_realizadas,
    COALESCE(SUM(DV.precio_unit * DV.cantidad), 0) AS total_vendido
FROM VENDEDOR Vend

-- Mediante INNER JOIN vinculamos los datos personales del vendedor
INNER JOIN PERSONA P 
    ON Vend.DNI_vendedor = P.DNI

-- Usamos LEFT JOIN para asegurar que se muestren todos los vendedores.
-- BETWEEN nos permite limitar el rango de fechas
LEFT JOIN VENTAS V 
    ON Vend.DNI_vendedor = V.DNI_vendedor 
    AND V.fecha BETWEEN '2026-09-01' AND '2026-09-30'

-- Unimos el detalle de las ventas correspondientes para poder calcular los montos
LEFT JOIN DETALLE_VENTA DV 
    ON V.numero_com = DV.numero_com

-- Agrupamos los registros de resultado por vendedor (código, nombre y apellido) 
GROUP BY 
    Vend.cod_vendedor,
    P.nombre, 
    P.apellido

-- Ordenamos los resultados de mayor a menor según el monto total vendido
ORDER BY total_vendido DESC;
GO
