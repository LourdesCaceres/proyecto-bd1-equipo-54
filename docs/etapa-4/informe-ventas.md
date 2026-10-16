## **Documentación sobre la consulta "informe-ventas"**


Esta consulta obtiene genera un **reporte de ventas por vendedor**, durante un periodo de tiempo. 
Detalla la cantidad de ventas realizadas y el monto total recaudado por cada vendedor durante el mes de septiembre de 2026.

* Utiliza agrupamientos (`GROUP BY`) junto con funciones agregadas (`SUM` y `COUNT`) para calcular las métricas, además de `COALESCE` para manejar posibles valores nulos en caso de que un vendedor no registre ventas en ese período.
* Mediante `LEFT JOIN` e `INNER JOIN` unimos las tablas VENDEDOR, PERSONA, VENTAS y DETALLE_VENTA, asegurando que se evalúe a toda la plantilla de empleados y cruzando sus datos con las ventas correspondientes.
* La tabla resultante es muestra los datos: **cod_vendedor**, **nombre**, **apellido**, **ventas_realizadas** y **total_vendido**, ordenado de mayor a menor volumen de ventas.

## **RESULTADOS EN TABLA**
|  | cod_vendedor | nombre  | apellido  | ventas_realizadas | total_vendido |
|--| ------------ | ------- | --------- | ----------------- | -------------- |
| 1| 5            | Pablo   | Espinoza  | 2                 | 226000.00      |
| 2| 2            | Pedro   | Sanchez   | 2                 | 150550.00      |
| 3| 3            | Mirta   | Leguiza   | 2                 | 150070.00      |
| 4| 4            | Lucas   | Perez     | 2                 | 136400.00      |
| 5| 1            | Sofia   | Vergara   | 1                 | 81000.00       |
