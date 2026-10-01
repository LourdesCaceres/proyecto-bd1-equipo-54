# Etapa III: Poblado Inicial y Validación de Datos (DML)


## 1. Estrategia y Secuencia de Poblado DML

Para evitar errores de compilación por violaciones de claves foráneas o inexistencia de registros padres, la inserción de datos respetó de forma estricta la jerarquía de dependencias funcionales definida durante la etapa DDL:

1. **Nivel 0 (Tablas Independientes / Parámetros):** Carga de datos maestros en `PERSONA`, `CATEGORIA`, `PROVEEDOR` y `MED_DE_PAGO`.


2. **Nivel 1 (Subtipos y Entidades Dependientes):** Carga de los roles `CLIENTE` y `VENDEDOR` (vinculados a `PERSONA`), e inserción del inventario de `PRODUCTO` (vinculado a `CATEGORIA`).


3. **Nivel 2 (Cabeceras Transaccionales y Tablas Asociativas):** Carga de la matriz de suministro `PROVEEDOR_PRODUCTO`, comprobantes en `VENTAS` y sus correspondientes renglones en `DETALLE_VENTA`.



---

## 2. Detalle de Registros Insertados por Tabla

### 2.1. Nivel 0: Tablas Independientes y Catálogos

* **`PERSONA` (10 Registros):** Poblado con 10 personas físicas representativas de clientes y vendedores. Se registraron los atributos obligatorios (`DNI`, `nombre`, `apellido`, `direccion`, `telefono`, `email`), garantizando casillas de correo únicas y valores de DNI naturales (ej. DNI `40543222` a `41643554`).


* **`CATEGORIA` (3 Registros):** Inicialización del catálogo con las descripciones habilitadas por la restricción de dominio: `'Indumentaria'`, `'Accesorios'` y `'Equipo'`. Las claves primarias (`cod_categoria`) fueron generadas automáticamente de forma secuencial ($1, 2, 3$) mediante `IDENTITY(1,1)`.


* **`PROVEEDOR` (8 Registros):** Carga de 8 firmas comerciales con CUITs y razones sociales únicas (ej. *'Hermanos Ramirez S.A'*, *'Sporty Enterprises SRL.'*, *'Unión Deportiva'*), asegurando datos válidos para la asignación posterior de proveedores de mercadería.


* **`MED_DE_PAGO` (4 Registros):** Carga de los cuatro canales de cobro permitidos por el modelo: `'Efectivo'`, `'Transferencia'`, `'Débito'` y `'Crédito'`. Los identificadores (`cod_pago`) fueron asignados autoincrementalmente ($1$ al $4$).



---

### 2.2. Nivel 1: Subtipos y Entidades Dependientes

* **`CLIENTE` (5 Registros):** Especialización de 5 personas del listado maestro asignándoles fecha de alta comercial (`2026-09-01` a `2026-09-04`). Se verificó la consistencia 1:1 referenciando claves primarias existentes en `PERSONA` (DNIs: `40543222`, `43778234`, `43335655`, `47616254`, `41643554`).


* **`VENDEDOR` (5 Registros):** Especialización de las 5 personas restantes en el rol de empleados vendedores. Se asignaron legajos únicos (`cod_vendedor` del $1$ al $5$), fechas de ingreso laboral y sus correspondientes vinculaciones a `PERSONA` (DNIs: `39738523`, `41733222`, `38557890`, `40333757`, `40993044`).


* **`PRODUCTO` (10 Registros):** Alta de 10 artículos deportivos asociándolos a sus respectivas categorías mediante clave foránea (`cod_categoria` $1$, $2$ o $3$). Se especificaron precios de lista mayores a cero (ej. *'Camiseta Titular Selección Argentina'* a $\$45000.00$) y niveles de stock iniciales positivos (ej. 50 unidades). Los identificadores `cod_producto` fueron generados secuencialmente ($1$ al $10$) vía `IDENTITY`.



---

### 2.3. Nivel 2: Transacciones y Relaciones Muchos a Muchos (M:N)

* **`PROVEEDOR_PRODUCTO` (10 Registros):** Carga de la tabla asociativa M:N para vincular los CUITs de los proveedores con los productos del inventario (IDs $1$ al $10$), estableciendo la trazabilidad del suministro comercial.


* **`VENTAS` (10 Registros):** Registración de 10 comprobantes comerciales identificados del número `1001` al `1010`. Cada venta asoció un cliente, un vendedor y un medio de pago válidos, cumpliendo con los planes de cuotas permitidos ($1$, $2$ o $3$ cuotas). La fecha de emisión fue capturada automáticamente por el motor SGBD mediante `DEFAULT GETDATE()`.


* **`DETALLE_VENTA` (11 Registros):** Carga de las líneas de detalle asociadas a los comprobantes emitidos. Para validar la capacidad de registrar ventas multi-ítem, el comprobante `1001` incorporó 2 artículos distintos en su detalle. Se registraron los precios unitarios de venta y cantidades vendidas estrictamente mayores a cero.
