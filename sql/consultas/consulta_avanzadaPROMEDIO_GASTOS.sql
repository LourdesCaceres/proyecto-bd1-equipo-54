------Consulta avanzada-----
---Queremos obtener el gasto total de cada cliente, definimos gasto total como el---
---precio de cada producto por su cantidad. Se saca un promedio de los gastos por---
---cliente y selecciona aquellos con gastos superiores.---

SELECT
    c.DNI_cliente,
    p.nombre,
    p.apellido,
    SUM(dv.precio_unit * dv.cantidad) AS gasto_total
FROM CLIENTE c

---Mediante INNER JOIN buscamos en las ventas de cada cliente---
INNER JOIN PERSONA p
    ON c.DNI_cliente = p.DNI
INNER JOIN VENTAS v
    ON c.DNI_cliente = v.DNI_cliente
INNER JOIN DETALLE_VENTA dv
    ON v.numero_com = dv.numero_com

---Agrupamos los registros de resultado por cliente (nombre, apellido y DNI)---
GROUP BY
    c.DNI_cliente,
    p.nombre,
    p.apellido

---HAVING hace el filtrado de aquellos clientes que superan el promedio---
HAVING SUM(dv.precio_unit * dv.cantidad) >
(
-----Subconsulta-----
---AVG calcula el promedio de gastos entre todos los clientes---
    SELECT AVG(gastos.gasto_total)
    FROM (
    ---Usamos LEFT JOIN junto a ISNULL() para aquellos clientes sin ventas registradas---
    ---cuyo gasto tenemos en cuenta y sería de 0.---
        SELECT
            c2.DNI_cliente,
            ISNULL(
                SUM(dv2.precio_unit * dv2.cantidad),
                0
            ) AS gasto_total
        FROM CLIENTE c2
        LEFT JOIN VENTAS v2
            ON c2.DNI_cliente = v2.DNI_cliente
        LEFT JOIN DETALLE_VENTA dv2
            ON v2.numero_com = dv2.numero_com
        GROUP BY c2.DNI_cliente
    ) AS gastos
);
