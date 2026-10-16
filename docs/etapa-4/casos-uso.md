# Etapa IV: Casos de uso

Este documento explica la finalidad de cada consulta y qué sentencias sql utiilza para ello. El desarrollo de cada script se encuentra en el archivo `sql/consultas/`

| Caso de uso | Script | Sentencias principales |
| :---- | :---- | :---- |
| Comprobante de venta | `comprobante_venta.sql` | `CREATE VIEW`, `INNER JOIN`, `SUM() OVER (PARTITION BY ...)` |
| Informe de ventas por vendedor en un rango de fechas | `informe-ventas.sql` | `LEFT JOIN`, `COUNT`, `SUM`, `COALESCE`, `GROUP BY` |
| Clientes con gasto superior al promedio | `consulta_avanzadaPROMEDIO_GASTOS.sql` | `INNER JOIN`, `GROUP BY`, `HAVING`, subconsultas |

&nbsp;

---

## 1\. Comprobante de venta

**Script:** `sql/consultas/comprobante_venta.sql`

### Necesidad de información

Al concretarse una venta, el local debe poder emitir un comprobante que reúna en un solo resultado el encabezado (número, fecha, cliente, vendedor y medio de pago) y el detalle de los productos vendidos, con el subtotal de cada renglón y el total acumulado de la operación.

### Sentencias SQL

- **Combinación de tablas.** Se vinculan con `INNER JOIN` las tablas `VENTAS`, `CLIENTE`, `VENDEDOR`, `MED_DE_PAGO`, `DETALLE_VENTA` y `PRODUCTO`. La tabla `PERSONA` se une dos veces, con alias distintos, porque la misma entidad aporta los datos del cliente y los del vendedor.  
- **Precio histórico.** El valor unitario se toma de `DETALLE_VENTA.precio_unit`, no de `PRODUCTO.precio_actual`, de modo que el comprobante conserva el precio vigente al momento de la venta (RN.09).  
- **Subtotal por renglón.** Se calcula con un operador aritmético: `cantidad * precio_unit`.  
- **Total acumulado.** Se obtiene con `SUM(cantidad * precio_unit) OVER (PARTITION BY numero_com)`. Esta función de ventana suma los renglones de cada comprobante y repite el total en cada fila, sin colapsar el detalle. Con `GROUP BY` se obtendría el total, pero se perderían los renglones. Las funciones de ventana no forman parte de las diapositivas de la cátedra; se las adopta por esta razón (Microsoft Learn, *SELECT – OVER Clause (Transact-SQL)*).  
- **Reutilización.** La consulta se encapsula en la vista `VISTA_COMPROBANTE_VENTA` (Microsoft Learn, *CREATE VIEW*), que se consulta luego con un `WHERE` sobre el número de comprobante. Como `CREATE VIEW` debe ser la primera sentencia de su lote, el script la separa con `GO`.

---

## 2\. Informe de ventas por vendedor

**Script:** `sql/consultas/informe-ventas.sql`

### Necesidad de información

La gerencia necesita conocer, para un mes determinado, cuántas ventas realizó cada vendedor y cuánto dinero recaudó. El informe debe listar **a todos los vendedores**, incluso a quienes no registraron ventas en el período, que aparecen con cantidad 0 y monto 0\. Los períodos de análisis son meses completos: agosto, septiembre y octubre de 2026\.

### Sentencia SQL

- **Punto de partida.** La consulta parte de `VENDEDOR`, la tabla que debe conservarse completa, y la une con `PERSONA` mediante `INNER JOIN` para obtener nombre y apellido.  
- **Conservar vendedores sin ventas.** `VENTAS` y `DETALLE_VENTA` se unen con `LEFT JOIN`. Cuando un vendedor no tiene coincidencias, las columnas de esas tablas quedan en `NULL`.  
- **Filtro de fechas en el `ON`.** El rango se aplica en la condición de combinación de `VENTAS` y no en el `WHERE`. Si se colocara en el `WHERE`, se descartarían las filas con `NULL` y la consulta dejaría de mostrar a los vendedores sin ventas.  
- **Conteo de ventas.** Se usa `COUNT(DISTINCT numero_com)`. Al unir `VENTAS` con `DETALLE_VENTA`, una venta con varios renglones aparece repetida, y `COUNT(*)` contaría renglones en lugar de ventas. Como las funciones agregadas ignoran los `NULL`, un vendedor sin ventas obtiene 0\.  
- **Monto total.** `SUM(precio_unit * cantidad)` acumula el importe de los renglones y `COALESCE(..., 0)` reemplaza por 0 el resultado nulo de los vendedores sin ventas.  
- **Agrupamiento y orden.** `GROUP BY` por código, nombre y apellido del vendedor genera una fila por vendedor, y `ORDER BY total_vendido DESC` ordena de mayor a menor recaudación.

El script desarrolla el mes de **septiembre**. Los informes de agosto y octubre se obtienen con la misma consulta, reemplazando únicamente el rango de fechas.

### Consideración sobre el rango

`BETWEEN` incluye ambos extremos, pero `VENTAS.fecha` es de tipo `DATETIME`, por lo que `'2026-09-30'` equivale a las 00:00:00 de ese día y excluiría las ventas posteriores a esa hora. Con los datos actuales no hay ventas el 30/09 y el resultado no se ve afectado. Para un rango mensual robusto es preferible `fecha >= '2026-09-01' AND fecha < '2026-10-01'`.

---

## 3\. Clientes con gasto superior al promedio

**Script:** `sql/consultas/consulta_avanzadaPROMEDIO_GASTOS.sql`

### Necesidad de información

El negocio quiere identificar a sus clientes de mayor valor: aquellos cuyo gasto total acumulado supera el gasto promedio por cliente. El gasto de un cliente es la suma de `precio_unit * cantidad` de todos sus renglones de compra.

### Estrategia SQL

- **Consulta externa.** Combina cuatro tablas con `INNER JOIN` (`CLIENTE`, `PERSONA`, `VENTAS` y `DETALLE_VENTA`), agrupa con `GROUP BY` por cliente y calcula `SUM(precio_unit * cantidad)` como gasto total.  
- **Filtro sobre grupos.** `HAVING` compara el gasto de cada cliente con el promedio. Se usa `HAVING` y no `WHERE` porque la condición se aplica sobre el resultado de una función agregada.  
- **Subconsulta escalar.** El promedio se calcula en una subconsulta que devuelve un único valor.  
- **Tabla derivada.** Dentro de la subconsulta, una consulta en la cláusula `FROM` calcula el gasto de cada cliente y sobre ella se aplica `AVG`. Para ese cálculo se usa `LEFT JOIN` e `ISNULL(SUM(...), 0)`, de manera que los clientes sin compras cuenten con gasto 0\.  
- **Criterio del promedio.** Al incluir a los clientes sin compras, el promedio se calcula sobre todos los clientes registrados, no solo sobre quienes compraron. Es una decisión de negocio documentada en los comentarios del script. `ISNULL` es una función de T-SQL equivalente a `COALESCE` con dos argumentos.

---

