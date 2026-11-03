# INFORME TÉCNICO: ETAPA 5

## 1\. Introducción y Marco General

En las etapas previas del proyecto **SistemaSportMax** (Etapa 4), se construyó la estructura relacional (`script_SportMax.sql`), la carga masiva de datos (`poblado_datos_etapa4_DML.sql`), reportes analíticos con agrupamiento y subconsultas (`informe_ventas.sql`, `consulta_avanzadaPROMEDIO_GASTOS.sql`) y la abstracción de datos para facturación mediante vistas (`comprobante_venta.sql`).

La **Etapa 5** da un paso cualitativo en la arquitectura del sistema al incorporar la **programación del lado del servidor** mediante T-SQL. El objetivo central es trasladar la lógica de negocio, validación y consultas complejas desde scripts o aplicaciones externas directamente al SGBD mediante **Procedimientos Almacenados (SPs)** y **Funciones Definidas por el Usuario (UDFs)**.

## 2\. Desarrollo de Objetos Programables (Etapa 5\)

### 2.1. Procedimientos Almacenados

Se encapsularon las operaciones DML habituales sobre la tabla `PRODUCTO`:

* **`sp_InsertarProducto`**: Registra nuevos artículos parametrizando campos clave como nombre, precio, stock y categoría.

* **`sp_ActualizarProducto`**: Modifica dinámicamente precios y existencias en stock según el identificador del producto (`cod_producto`).

* **`sp_EliminarProducto`**: Garantiza la integridad referencial al eliminar en primera instancia las dependencias en `PROVEEDOR_PRODUCTO` antes de remover el producto principal.

### 2.2. Funciones Definidas por el Usuario

Se desarrollaron funciones escalares para abstraer operaciones de cálculo recurrentes:

* **`fn_ObtenerStockProducto`**: Consulta rápida de la cantidad disponible de un artículo.

* **`fn_TotalComprasCliente`**: Calcula el volumen total invertido por un cliente a través del histórico de ventas.

* **`fn_PrecioAjustado`**: Función auxiliar matemática para aplicar porcentajes de ajuste o margen a un precio base.

## 3\. Comparativa Teórico-Práctica: Etapa 4 vs. Etapa 5

A partir de la evolución del proyecto, se presentan los tres ejes comparativos fundamentales entre el enfoque directo/ad-hoc (Etapa 4\) y el enfoque empaquetado/programable (Etapa 5):

### A. Mantenibilidad y Evolución de la Lógica

* **Etapa 4 (Consultas directas y Vistas):**

  En scripts como `informe_ventas.sql` o `consulta_avanzadaPROMEDIO_GASTOS.sql`, las reglas de negocio (cálculo de subtotal `precio_unit * cantidad`, manejo de nulos con `COALESCE`/`ISNULL` y agrupamientos con `HAVING`) se encuentran acopladas directamente en la consulta. Si la regla de cálculo del total del cliente cambia, hay que modificar múltiples scripts o el código fuente de las aplicaciones.

* **Etapa 5 (Encapsulamiento con UDFs y SPs):**

  Al implementar `fn_TotalComprasCliente` o `sp_ActualizarProducto`, la regla de negocio reside en un único objeto centralizado en la base de datos. Cualquier cambio en la lógica se actualiza en el SGBD sin afectar a las aplicaciones clientes ni requerir la reescritura de múltiples consultas.

### B. Seguridad, Control de Acceso e Inyección SQL

* **Etapa 4 (Sentencias DML directas):**

  Tanto en `script_SportMax_DML.sql` como en `poblado_datos_etapa4_DML.sql`, las inserciones y actualizaciones (`UPDATE CLIENTE SET...`, `UPDATE VENTAS SET...`) requieren que el usuario o aplicación tenga permisos directos de escritura (`INSERT`, `UPDATE`, `DELETE`) sobre las tablas base (`CLIENTE`, `VENTAS`, `PRODUCTO`). Esto expone el esquema a modificaciones accidentales o ataques por inyección SQL.

* **Etapa 5 (Capa de Abstracción mediante SPs):**

  Los procedimientos almacenados actúan como un escudo. Se pueden revocar los permisos de modificación directa sobre la tabla `PRODUCTO` y conceder únicamente permisos de ejecución (`GRANT EXECUTE ON sp_InsertarProducto`) a los usuarios. Los parámetros actúan como una barrera natural contra sentencias maliciosas.

### C. Reutilización, Rendimiento y Tráfico de Red

* **Etapa 4 (Consultas repetitivas e inserciones en lote tradicional):**

  Consultas complejas como `VISTA_COMPROBANTE_VENTA` realizan múltiples `INNER JOIN` y cálculos agregados de ventana (`SUM OVER PARTITION`) cada vez que se ejecutan. Asimismo, las inserciones individuales envían múltiples bloques de texto SQL a través de la red.

* **Etapa 5 (Invocación parametrizada y planes de ejecución):**

  Como se demostró en `insertarDatos.sql`, la ejecución repetida de `EXEC sp_InsertarProducto ...` reduce el tráfico de red enviando solo el nombre del SP y los valores. Además, SQL Server precompila y reutiliza el plan de ejecución de los procedimientos almacenados, optimizando la velocidad de procesamiento.

## 4\. Conclusión

La transición del enfoque declarativo directo (Etapa 4\) al enfoque procedimental y modular (Etapa 5\) convierte a **SistemaSportMax** en una base de datos de clase empresarial. La encapsulación de operaciones clave mediante SPs y la simplificación de cálculos mediante Funciones garantizan un entorno más seguro, mantenible, escalable y optimizado para la integración con sistemas cliente.