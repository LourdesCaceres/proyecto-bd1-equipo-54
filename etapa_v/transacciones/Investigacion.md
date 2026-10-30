# Transacciones y Transacciones Anidadas

---

## 1. Definición y Objetivo

### Transacción (*Standard Transaction*)

Una **transacción** es una unidad lógica de trabajo que agrupa una o varias operaciones sobre una base de datos (lecturas, inserciones, actualizaciones o borrados) para que se ejecuten como un único bloque indivisible.

* **Objetivo principal:** Garantizar la integridad y consistencia de los datos ante fallos del sistema o accesos concurrentes. Esto se logra cumpliendo las propiedades **ACID**:
  * **Atomicidad:** O se ejecutan todas las operaciones con éxito, o no se aplica ninguna (*todo o nada*).
  * **Consistencia:** La base de datos pasa de un estado válido a otro estado válido.
  * **Aislamiento (*Isolation*):** Las operaciones concurrentes no interfieren entre sí antes de confirmarse.
  * **Durabilidad:** Una vez confirmados los cambios (`COMMIT`), perduran incluso ante un fallo del sistema.

---

### Transacción Anidada (*Nested Transaction*)

Una **transacción anidada** es una transacción que se inicia dentro del ámbito de una transacción padre o superior, formando una estructura jerárquica en árbol.

* **Objetivo principal:** Proveer un control de errores granular y descomponer operaciones complejas en subunidades independientes de procesamiento sin arriesgar el trabajo global de la transacción principal.

#### Mecanismo de funcionamiento:
* La subtransacción (hija) puede realizar `COMMIT` o `ROLLBACK` de forma independiente respecto a sus hermanas.
* El `COMMIT` de una subtransacción es **provisional**: no se hace permanente en la base de datos hasta que la transacción padre ejecute su propio `COMMIT`.
* Si la subtransacción falla (`ROLLBACK`), solo se deshacen sus operaciones, permitiendo que la transacción padre capture el error y tome una ruta alternativa sin abortar todo el proceso.
* Si la transacción padre aborta, todas sus subtransacciones se deshacen, independientemente de que las hijas hayan finalizado con éxito.

---

## 2. Ventajas, Desventajas y Aplicaciones

### Ventajas de las Transacciones Anidadas

* **Aislamiento y control granular de fallos:** Permiten capturar errores en subsistemas o pasos específicos sin tener que abortar o reiniciar la transacción principal por completo.
* **Modularidad y reutilización de código:** Se pueden diseñar componentes de software o procedimientos almacenados que gestionen sus propias transacciones internamente sin preocuparse por el contexto global donde sean invocados.
* **Minimización de reejecuciones:** Al sufrir un fallo puntual, solo se revierte el trabajo de la subtransacción afectada, ahorrando tiempo y cómputo al no repetir el trabajo previo que fue exitoso.
* **Paralelismo interno:** Posibilitan la ejecución de múltiples subtransacciones independientes en paralelo bajo el amparo de la misma transacción padre.

---

### Desventajas de las Transacciones Anidadas

* **Complejidad de implementación:** La gestión de estados, bloqueos y relaciones jerárquicas exige un diseño de software e infraestructura de base de datos mucho más complejo.
* **Overhead y consumo de recursos:** Mantener múltiples niveles de estado, puntos de restauración (*savepoints*) y árboles de transacciones genera un mayor uso de memoria y procesador en el gestor de base de datos.
* **Bloqueo prolongado de recursos:** Debido a que los cambios de las subtransacciones no son definitivos hasta que la transacción padre hace `COMMIT`, los bloqueos sobre los datos pueden mantenerse abiertos durante más tiempo, afectando la concurrencia global.
* **Soporte limitado en DBMS:** No todos los motores de bases de datos relacionales ofrecen soporte nativo completo para transacciones anidadas verdaderas; en muchos casos solo se simulan mediante puntos de restauración (`SAVEPOINT`).

---

### Aplicaciones Prácticas

* **Sistemas de Reservas de Viajes:** Un paquete turístico incluye reserva de vuelo, hotel y alquiler de auto (transacción padre). La reserva del auto se procesa como subtransacción; si falla, se revierte solo esa parte y se busca otra alternativa sin cancelar el vuelo ni el hotel.
* **Procesamiento de Pagos en E-commerce:** Al intentar cobrar con una tarjeta principal (subtransacción 1), si esta es rechazada, se deshace únicamente el intento de pago y se prueba con una tarjeta secundaria (subtransacción 2), manteniendo intacta la orden de compra y el inventario reservado.
* **Procesamiento de Lotes Financieros:** Al procesar un archivo con miles de transferencias bancarias, cada transferencia individual se maneja como una subtransacción. Si una falla por datos erróneos, se registra el fallo, se deshace esa operación específica y el lote principal continúa procesando las demás.
* **Entornos de Pruebas y Testing:** Permite ejecutar pruebas unitarias complejas aislando modificaciones dentro de subbloques con puntos de retorno controlados sin afectar la base de datos de prueba global.

---

## Referencias

* Date, C. J. (2004). *An Introduction to Database Systems* (8th ed.). Pearson Addison-Wesley.
* Gray, J., & Reuter, A. (1992). *Transaction Processing: Concepts and Techniques*. Morgan Kaufmann Publishers.
* Moss, J. E. B. (1981). *Nested Transactions: An Approach to Reliable Distributed Computing*. Technical Report MIT/LCS/TR-260, Massachusetts Institute of Technology.
* Silberschatz, A., Korth, H. F., & Sudarshan, S. (2019). *Fundamentos de Bases de Datos* (*Database System Concepts*, 7a ed.). McGraw-Hill.