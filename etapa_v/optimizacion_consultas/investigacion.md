# Optimización de consultas a través de índices y procesamiento lógico en SQL Server

## 1. ¿En qué consisten?

La optimización de consultas va más allá de escribir código SQL funcional; requiere comprender la arquitectura semántica y física que utiliza el motor de base de datos (DBMS) para interpretar y ejecutar las peticiones.

### 1.1 De la naturaleza declarativa al Álgebra Relacional y el OLP

* **Naturaleza declarativa vs. procedural:** SQL es un lenguaje declarativo (el usuario especifica *qué* desea obtener, no *cómo* recuperarlo), pero el DBMS traduce la consulta a un lenguaje procedural formal llamado Álgebra Relacional (ÁR).

* **Orden Lógico de Procesamiento (OLP):** Es la secuencia inmutable de pasos lógicos que define cómo el DBMS procesa una sentencia `SELECT` (`FROM` $\rightarrow$ `WHERE` $\rightarrow$ `GROUP BY` $\rightarrow$ `HAVING` $\rightarrow$ `SELECT` $\rightarrow$ `ORDER BY`).

* **Mapeo de cláusulas:** Las cláusulas fundamentales como `WHERE` se mapean conceptualmente a la **Selección** (filtrado de tuplas) y `SELECT` a la **Proyección** (reducción de atributos).

### 1.2 El rol del Optimizador de Consultas y el Plan de Ejecución Físico

* **Optimización basada en costos (Cost-based optimization):** El optimizador evalúa múltiples planes equivalentes y selecciona aquel que consume la menor cantidad de recursos, principalmente operaciones de E/S (*I/O*) en disco.

* **Reglas de equivalencia relacional:** Una de las más importantes es el **Empuje de Selección (*Pushing Selection Down*)**, que establece que las operaciones de filtrado deben realizarse lo más temprano posible (como en el `WHERE`) para reducir el volumen de datos antes de aplicar operaciones costosas como agregaciones o uniones.

* **Planes de ejecución:** Son la representación visual del flujo de datos físico, donde herramientas de diagnóstico como `STATISTICS TIME` y `STATISTICS IO` permiten medir el impacto en CPU y lecturas lógicas.

### 1.3 El impacto de los índices en el acceso a los datos

* **Índice Agrupado (*Clustered Index*):** Organiza el orden físico de almacenamiento de las filas en la tabla basándose en la clave del índice, permitiendo recorridos eficientes de tipo árbol B-Tree (*Index Seek*).

* **Índice No Agrupado con columnas incluidas (`INCLUDE` / *Covering Index*):** Permite añadir columnas proyectadas en las hojas del índice secundario para evitar accesos innecesarios a la tabla base (*Key Lookups*), logrando un rendimiento óptimo de E/S.

### 1.4 Agregación, filtrado y rendimiento

* **Fase de agregación (Split, Apply, Combine):** Los datos se segmentan, se aplica la función de agregado (`SUM`, `COUNT`, etc.) y se combinan los resultados.

* **WHERE vs. HAVING:** El `WHERE` filtra filas individuales de forma temprana (antes de agrupar), mientras que el `HAVING` filtra grupos de forma tardía (después de la agregación). Utilizar `WHERE` optimiza el rendimiento al minimizar la entrada de datos a los operadores de agrupación.

## 2. Ventajas y desventajas

### Ventajas

* **Reducción drástica de E/S:** Los índices transforman recorridos secuenciales pesados (*Table Scans*) en búsquedas indexadas eficientes (*Index Seeks*), disminuyendo las lecturas lógicas de páginas.

* **Optimización temprana:** Respetar el flujo lógico y aplicar filtros en el `WHERE` evita procesar un volumen masivo de datos en operaciones costosas de ordenamiento o agregación.

* **Planes de ejecución predecibles:** El uso de índices cubridores (`INCLUDE`) elimina los costos secundarios de búsqueda en las tablas base (*Key Lookups*).

* **Diagnóstico preciso:** Las estadísticas de rendimiento (`STATISTICS IO` y `STATISTICS TIME`) brindan métricas exactas para auditar la mejora en el rendimiento antes y después de indexar.

### Desventajas

* **Costo de almacenamiento y mantenimiento:** Los índices consumen espacio adicional en disco y ralentizan operaciones de escritura (`INSERT`, `UPDATE`, `DELETE`) ya que el motor debe actualizar las estructuras de los árboles B-Tree.

* **Sobrecarga de compilación:** El optimizador invierte tiempo analizando múltiples planes de ejecución posibles antes de seleccionar el óptimo.

* **Mal diseño de índices:** Un índice mal estructurado o redundante puede provocar que el optimizador elija rutas de acceso subóptimas o ignore las estadísticas.

## 3. Aplicaciones prácticas

El script práctico implementado sobre la tabla `VENTAS_MASIVA` evalúa empíricamente los conceptos teóricos de optimización de consultas:

* **Carga masiva sin índice:** Se insertan 1,000,000 de registros en una tabla sin indexar para simular un escenario transaccional masivo de alto costo computacional.

* **Búsqueda por período sin índice:** Se ejecuta una consulta filtrando por un rango de fechas (`WHERE fecha >= ...`), obligando al motor a realizar un escaneo completo de la tabla (*Table Scan*) con un costo elevado de E/S y tiempo de CPU.

* **Creación de índice agrupado:** Se define un `CLUSTERED INDEX` sobre la columna `fecha`, transformando el plan de ejecución en un recorrido optimizado mediante árbol B-Tree (*Index Seek*).

* **Índice cobertor (`INCLUDE`):** Se implementa un índice no agrupado incluyendo las columnas proyectadas (`total_venta`, `dni_cliente`), eliminando lecturas accesorias y logrando la máxima eficiencia de rendimiento.

## 4. Bibliografía

* Cátedra Bases de Datos I (FaCENA, UNNE). Guía de lectura Unidad 5: *Arquitectura semántica de SQL: del álgebra relacional al plan de ejecución óptimo*.

* Cátedra Bases de Datos I (FaCENA, UNNE). Guía de lectura Unidad 5: *Funciones de agregación y agrupamiento*.
