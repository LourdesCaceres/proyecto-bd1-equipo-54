# IMPLEMENTACIÓN DE TRANSACCIONES Y TRANSACCIONES ANIDADAS

Para aplicar los conceptos del tema 2 en nuestra base de datos SportMax, decidimos implementar las dos formas principales de transacciones: simples y anidadas, cada una con un propósito específico dentro de la base de datos.

Para el caso de la **transacción simple**, nos enfocamos en el registro de ventas. Registrar una venta toca tres tablas fundamentales: `VENTAS` (cabecera), `DETALLE_VENTA` (renglón con el precio histórico) y `PRODUCTO` (descuento de stock). Esta implementación hace cumplir dos reglas reglas negocios: la **RN.10** (descuento automático de stock) y la **RN.11** (bloqueo de venta si la cantidad supera el stock). Por ejemplo, si un cliente compra 5 unidades de un producto y hay stock, se registra todo y se descuenta; si no hay stock, no se registra absolutamente nada.

Por otro lado, implementamos una **transacción anidada** para gestionar el aumento masivo de precios de los productos de una categoría. Este proceso implica actualizar varios productos, y el aumento debe aplicarse a todos o a ninguno. Cada producto se actualiza en una unidad de trabajo propia (un procedimiento interno con su propia transacción), agrupadas bajo una transacción externa. Aquí entra en juego la función `fn_PrecioAjustado` (del tema 1), y nos aseguramos de que los precios de ventas ya realizadas no cambien, conservando el precio histórico en `DETALLE_VENTA` (RN.09).

Para complementar esta transacción, consideramos necesario definir una nueva regla de negocio:

> **RN.13 – Límite de ajuste de precios:** Un aumento porcentual masivo sobre una categoría solo se confirma si ningún producto supera el precio tope (el precio del producto más caro del catálogo antes del aumento). Si un solo producto lo supera, el aumento se cancela por completo.

## ENCAPSULAMIENTO Y LÓGICA TRANSACCIONAL
Consideramos importante empaquetar toda la lógica transaccional dentro de Procedimientos Almacenados, como es el caso del procedimiento `sp_RegistroVenta`. Esta decisión de diseño se fundamenta en la necesidad de permitir la reutilización y parametrización, logrando ejecutar transacciones pasando parámetros dinámicos (como `@IdProducto`, `@Cantidad`, `@PrecioUnitario`) sin necesidad de modificar el código fuente. Además, esta encapsulación aísla la lógica de negocio en la capa de persistencia, facilitando futuras integraciones con aplicaciones cliente. Cabe destacar que la única dependencia de este tema es la función `fn_PrecioAjustado`, definida previamente en el Tema 1.

## ESTRUCTURAS DE CONTROL Y MANEJO DE ERRORES

Inicialmente, habíamos evaluado usar un modelo de control basado únicamente en `IF/ELSE`, pero detectamos una limitación grave: con `IF/ELSE` solo controlábamos la condición de stock, y si fallaba otro paso (como una clave duplicada), SQL Server podía seguir ejecutando el resto del lote, dejando la base inconsistente.
Por eso decidimos implementar un bloque `TRY...CATCH` en cada transacción para evaluar las condiciones y la integridad del sistema. La lógica de evaluación para el `COMMIT` o `ROLLBACK` funciona de la siguiente manera:

* **En el registro de venta:** Las condiciones de negocio se evalúan dentro del `TRY` antes de escribir. Verificamos si el producto existe (`IF @stock_actual IS NULL`) y si hay stock suficiente (`IF @cantidad > @stock_actual`). Si fallan, hacemos un `ROLLBACK` explícito, emitimos un mensaje (como `RAISERROR` o un `PRINT`) y cortamos con `RETURN`. Si todo es correcto, ejecutamos las sentencias y el `COMMIT`. Cualquier error de ejecución (como un `cantidad > stock_actual`) lleva directamente al `CATCH`, que hace `ROLLBACK` dejando la base intacta.

* **En el aumento masivo:** Verificamos el cumplimiento de la RN.13 comprobando si algún producto actualizado superó el `@precio_tope` calculado al inicio. Como esto se evalúa después de los cambios internos, el `ROLLBACK` deshace trabajo real. Si la regla se rompe, lanzamos un `THROW 50003` para que el `CATCH` atrape el error y revierta todo. También incluimos validaciones previas (porcentajes negativos o categorías inexistentes) que lanzan sus propios `THROW`.

