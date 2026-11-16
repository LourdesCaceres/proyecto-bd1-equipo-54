## Resultados de cada consulta

### BÚSQUEDA POR PERÍODO (SIN ÍNDICE)
<img width="1129" height="540" alt="Captura de pantalla 2026-11-16 154106" src="https://github.com/user-attachments/assets/35e48ca9-706b-4161-8a21-d1a69cc650a3" />

### ÍNDICE AGRUPADO EN FECHA Y REPETIR CONSULTA

<img width="1118" height="450" alt="Captura de pantalla 2026-11-16 154441" src="https://github.com/user-attachments/assets/296dabef-9545-4d3d-b064-f4d22d072a57" />

### ÍNDICE CON COLUMNAS INCLUIDAS (INCLUDE) Y REPETIR CONSULTA
<img width="1094" height="514" alt="image" src="https://github.com/user-attachments/assets/e007b988-b9ae-4a8e-8da1-aa0cbc178ae3" />

### Resultados de rendimiento – Optimización con índices (`VENTAS_MASIVA`)

Consulta ejecutada sobre **1.000.000 de registros** filtrando por rango de fechas (`2025-10-01` a `2025-10-31`), devolviendo **50.841 filas** en los tres escenarios

| Escenario | Lecturas lógicas (`logical reads`) | Tiempo de CPU (`CPU time`) | Tiempo transcurrido (`elapsed time`) | Operación del motor / Observación |
| :--- | :---: | :---: | :---: | :--- |
| **1. Sin índice** (*Heap*) | 4.202 | 1.265 ms | 7.164 ms | **Table Scan**: recorre el 100 % de las páginas de la tabla de punta a punta. |
| **2. Índice Agrupado** (`CLUSTERED`) | 218 | 62 ms | 1.343 ms | **Clustered Index Seek**: ordena físicamente la tabla por `fecha` y lee solo las páginas del período (reducción del 94,8 % en lecturas lógicas). |
| **3. Índice No Agrupado + `INCLUDE`** (`NONCLUSTERED`) | 250 | 16 ms | 2.592 ms | **Index Seek (NonClustered)**: al incluir `id_venta`, `total_venta` y `dni_cliente` en el `INCLUDE`, actúa como índice cubridor y resuelve la consulta sin acceder a la tabla base (reducción del 94,1 % en lecturas lógicas). |

> **Nota sobre costo de creación:** La construcción del índice agrupado demoró **21.653 ms** (`CPU time: 4.078 ms`) y la del índice no agrupado cubridor demoró **207.025 ms** (`CPU time: 1.672 ms`), evidenciando el impacto de los índices en las operaciones de escritura y mantenimiento.
