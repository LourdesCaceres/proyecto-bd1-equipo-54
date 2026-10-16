## ***DOCUMENTACIÓN SOBRE LA CONSULTA COMPROBANTE-VENTA***

La consulta "comprobante-venta" simula la emisión de una factura, mostrando tanto el encabezado (datos generales) como el detalle (productos) de una venta específica.

* Esta consulta crea y utiliza una VISTA (`VISTA_COMPROBANTE_VENTA`), lo que permite guardar la estructura lógica y reutilizarla fácilmente para consultar cualquier ticket en el futuro.
* Mediante múltiples `INNER JOIN` unimos las tablas VENTAS, CLIENTE, PERSONA (dos veces, para cliente y vendedor), VENDEDOR, MED_DE_PAGO, DETALLE_VENTA y PRODUCTO, logrando traducir códigos numéricos en descripciones legibles.
* Para los cálculos, realiza la multiplicación de cantidad por precio para el "Subtotal Producto", e implementa una función de ventana (`SUM(...) OVER(PARTITION BY ...)`) que permite sumar el gran total de la factura sin agrupar ni perder la visualización individual de cada renglón.

### ***Comprobante 1001***
| N° Comprobante | Fecha Venta | Cliente | DNI Cliente | Vendedor | Medio de Pago | Cuotas | Producto | Cantidad | Precio Unitario | Subtotal Producto | TOTAL VENTA |
|--| ----------- | ------- | ----------- | -------- | ------------- | ------ | -------- | -------- | --------------- | ----------------- | ----------- |
| 1001 | 2026-08-31 10:15:00 | Ezequiel Perez | 40543222 | Sofia Vergara | Efectivo | 1 | Camiseta Titular Selección Argentina | 1 | 45000.00 | 45000.00 | 180000.00 |
| 1001 | 2026-08-31 10:15:00 | Ezequiel Perez | 40543222 | Sofia Vergara | Efectivo | 1 | Short de Entrenamiento Deportivo | 2 | 25000.00 | 50000.00 | 180000.00 |
| 1001 | 2026-08-31 10:15:00 | Ezequiel Perez | 40543222 | Sofia Vergara | Efectivo | 1 | Zapatillas Running Ultraboost | 1 | 85000.00 | 85000.00 | 180000.00 |