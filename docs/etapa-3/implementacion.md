# Etapa III: Implementación Física del Sistema SportMax

## 1. Selección del SGBD y Entorno de Ejecución

El pasaje del modelo relacional normalizado al nivel de implementación física se llevó a cabo utilizando el Sistema de Gestión de Bases de Datos Relacionales (SGBD) **Microsoft SQL Server**, mediante el lenguaje de definición de datos (DDL).

## 2. Estrategia y Secuencia de Compilación DDL

Para garantizar la ejecución correcta del script sin fallos por referencias cruzadas o violaciones de claves foráneas inexistentes, las sentencias `CREATE TABLE` se estructuraron respetando un orden estrictamente topológico basado en el nivel de dependencia de cada entidad:

```
[Nivel 0: Entidades Fuertes / Parámetros] 
   ├── PERSONA
   ├── MED_DE_PAGO
   ├── CATEGORIA
   └── PROVEEDOR
          │
[Nivel 1: Subtipos y Entidades Dependientes]
   ├── CLIENTE           (Depende de PERSONA)
   ├── VENDEDOR          (Depende de PERSONA)
   └── PRODUCTO          (Depende de CATEGORIA)
          │
[Nivel 2: Cabeceras y Tablas Asociativas M:N]
   ├── VENTAS            (Depende de MED_DE_PAGO, CLIENTE, VENDEDOR)
   ├── DETALLE_VENTA     (Depende de VENTAS, PRODUCTO)
   └── PROVEEDOR_PRODUCTO (Depende de PROVEEDOR, PRODUCTO)

```

## 3. Proceso de Implementación Paso a Paso (Mapeo Relacional a DDL)

### 3.1. Fase 1: Tablas Fuertes y Catálogos Independientes (Nivel 0 de FK)

Son relaciones que no contienen claves foráneas y sirven como base maestra o parámetro para el resto del modelo.

#### A. Tabla `PERSONA`

Almacena los datos comunes de la jerarquía de especialización.

* **`DNI` (`INT`, `NOT NULL`):** Clave primaria natural identificadora de la persona.


* **`nombre` (`VARCHAR(50)`, `NOT NULL`) / `apellido` (`VARCHAR(50)`, `NOT NULL`):** Atributos atómicos nominatorios.


* **`direccion` (`VARCHAR(50)`, `NOT NULL`) / `telefono` (`INT`, `NOT NULL`):** Datos de contacto y ubicación.


* **`email` (`VARCHAR(100)`, `NOT NULL UNIQUE`):** Dirección de correo electrónico obligatoria con restricción de unicidad para evitar duplicación de identidades.



#### B. Tabla `MED_DE_PAGO`

Catálogo paramétrico de medios de pago autorizados.

* **`cod_pago` (`INT IDENTITY(1,1)`, `NOT NULL`):** Clave primaria subrogada autoincremental.


* **`detalle` (`VARCHAR(20)`, `NOT NULL`):** Descripción del medio de pago restringida mediante la cláusula `CHECK (detalle IN ('Efectivo', 'Transferencia', 'Débito', 'Crédito'))`.



#### C. Tabla `CATEGORIA`

Clasificación jerárquica de los productos del inventario.

* **`cod_categoria` (`INT IDENTITY(1,1)`, `NOT NULL`):** Clave primaria subrogada autoincremental.


* **`descripcion` (`VARCHAR(100)`, `NOT NULL`):** Denominación de la categoría validada mediante `CHECK (descripcion IN ('Indumentaria', 'Accesorio', 'Equipo'))`.



#### D. Tabla `PROVEEDOR`

Entidad maestra con la información de las empresas de suministro.

* **`CUIT` (`INT`, `NOT NULL`):** Identificador fiscal que actúa como clave primaria natural.


* **`razon_social` (`VARCHAR(50)`, `NOT NULL UNIQUE`):** Denominación legal de la entidad proveedora con restricción de unicidad.


* **`Direccion` (`VARCHAR(50)`, `NOT NULL`) / `telefono` (`INT`, `NOT NULL`):** Atributos de localización y contacto comercial.



---

### 3.2. Fase 2: Subtipos y Entidades Dependientes (Nivel 1 de FK)

Relaciones que dependen directamente de las tablas independientes del Nivel 0.

#### A. Tabla `CLIENTE`

Representa el rol de cliente en la especialización de `PERSONA` (Mapeo de Jerarquías 1:1).

* **`DNI_cliente` (`INT`, `NOT NULL`):** Clave primaria que actúa simultáneamente como clave foránea (`FK`) referenciando a `PERSONA(DNI)`.


* **`fecha_alta` (`DATE`, `NOT NULL`):** Atributo específico del subtipo que registra la fecha de incorporación.



#### B. Tabla `VENDEDOR`

Representa el rol de empleado comercial en la especialización de `PERSONA`.

* **`DNI_vendedor` (`INT`, `NOT NULL`):** Clave primaria y clave foránea (`FK`) vinculada a `PERSONA(DNI)`.


* **`cod_vendedor` (`INT`, `NOT NULL UNIQUE`):** Identificador o legajo corporativo alternativo del empleado con restricción de unicidad.


* **`fecha_ingreso` (`DATE`, `NOT NULL`):** Atributo de control de antigüedad laboral.



#### C. Tabla `PRODUCTO`

Catálogo de artículos comercializables.

* **`cod_producto` (`INT IDENTITY(1,1)`, `NOT NULL`):** Clave primaria subrogada.


* **`nombre` (`VARCHAR(100)`, `NOT NULL UNIQUE`):** Nombre comercial único del artículo.


* **`precio_actual` (`DECIMAL(10,2)`, `NOT NULL`):** Precio de lista de precisión decimal validado con `CHECK (precio_actual > 0)`.


* **`cant_disponible` (`INT`, `NOT NULL`):** Stock físico disponible con control de no-negatividad `CHECK (cant_disponible >= 0)`.


* **`cod_categoria` (`INT`, `NOT NULL`):** Clave foránea (`FK`) dirigida a `CATEGORIA(cod_categoria)`.



---

### 3.3. Fase 3: Cabeceras Transaccionales y Tablas Asociativas M:N (Nivel 2 de FK)

Estructuras transaccionales complejas que relacionan múltiples entidades previas.

#### A. Tabla `VENTAS`

Transacción comercial.

* **`numero_com` (`INT`, `NOT NULL`):** Clave primaria natural que identifica el comprobante.


* **`fecha` (`DATETIME`, `NOT NULL DEFAULT GETDATE()`):** Marca de tiempo automática de la operación.


* **`cant_cuotas` (`INT`, `NOT NULL`):** Plan de financiación validado mediante `CHECK (cant_cuotas IN (1, 2, 3))`.


* **`cod_pago` (`INT`, `NOT NULL`):** Clave foránea (`FK`) referenciada a `MED_DE_PAGO(cod_pago)`.


* **`DNI_cliente` (`INT`, `NOT NULL`):** Clave foránea (`FK`) referenciada a `CLIENTE(DNI_cliente)`.


* **`DNI_vendedor` (`INT`, `NOT NULL`):** Clave foránea (`FK`) referenciada a `VENDEDOR(DNI_vendedor)`.



#### B. Tabla `DETALLE_VENTA`

Tabla asociativa que resuelve la relación M:N entre `VENTAS` y `PRODUCTO`.

* **`{cod_producto, numero_com}` (`INT`, `INT`, `NOT NULL`):** Clave primaria compuesta (`PK`). Cada atributo constituye individualmente una clave foránea (`FK`): `cod_producto` apunta a `PRODUCTO(cod_producto)` y `numero_com` apunta a `VENTAS(numero_com)`.


* **`precio_unit` (`DECIMAL(10,2)`, `NOT NULL`):** Precio histórico de venta congelado al momento del comprobante con `CHECK (precio_unit > 0)`.


* **`cantidad` (`INT`, `NOT NULL`):** Unidades vendidas con `CHECK (cantidad > 0)`.



#### C. Tabla `PROVEEDOR_PRODUCTO`

Tabla asociativa que resuelve la relación M:N de suministro entre `PROVEEDOR` y `PRODUCTO`.

* **`{CUIT, cod_producto}` (`INT`, `INT`, `NOT NULL`):** Clave primaria compuesta (`PK`). `CUIT` actúa como clave foránea hacia `PROVEEDOR(CUIT)` y `cod_producto` hacia `PRODUCTO(cod_producto)`.



---

## 4. Evolución y Refactorización: Borrador DDL vs. Script Final

Durante la transición entre el borrador inicial (`DDL_SportMax_2.sql`) y la versión final depurada (`scriptFINAL_SportMax_2.sql`), se corrigieron inconsistencias de sintaxis T-SQL, tipos de datos e integridad referencial:

### A. Corrección de Sintaxis de Dominio y Secuencias Autoincrementales

* **Dominios de Listas Fijas:** En el borrador inicial, las columnas `detalle` en `MED_DE_PAGO` y `cant_cuotas` en `VENTAS` se declararon mediante sintaxis inválida en T-SQL: `detalle ('Efectivo', ...)`. En el script final se refactorizaron asignando el tipo base adecuado (`VARCHAR` / `INT`) acompañado de cláusulas explícitas `CHECK (... IN (...))`.


* **Claves Autoincrementales:** En el borrador las claves primarias numéricas requerían la inserción explícita de identificadores. Se incorporó la propiedad nativa `IDENTITY(1,1)` en `MED_DE_PAGO(cod_pago)`, `CATEGORIA(cod_categoria)` y `PRODUCTO(cod_producto)` para delegar el control de secuencias al SGBD.



### B. Precisión Financiera y Sellado Temporal

* **Atributos Monetarios:** En la versión borrador, los valores monetarios (`precio_actual` en `PRODUCTO` y `precio_unit` en `DETALLE_VENTA`) se definieron como `INT`. Se ajustaron a `DECIMAL(10,2)` para dar soporte a montos con centavos y evitar pérdidas por redondeo.


* **Sellado Temporal de Operaciones:** En `VENTAS`, el tipo de dato se actualizó de `DATE` a `DATETIME NOT NULL DEFAULT GETDATE()`, permitiendo almacenar fecha y hora exacta de emisión sin requerir el paso del parámetro desde el código de aplicación.



### C. Completitud de Claves Foráneas y Estructuras Compuestas

* **Incompletitud en Referencias:** En el borrador inicial, las claves foráneas en `VENTAS` poseían cláusulas `REFERENCES CLIENTE()` y `REFERENCES VENDEDOR()` sin especificar la columna de destino. Se explicitaron las columnas primarias correspondientes: `REFERENCES CLIENTE(DNI_cliente)` y `REFERENCES VENDEDOR(DNI_vendedor)`.


* **Definición de PK Compuesta en M:N:** La tabla `PROVEEDOR_PRODUCTO` carecía de la declaración formal de clave primaria en el borrador. Se definió explícitamente la clave primaria compuesta mediante `CONSTRAINT PK_ProveedorProducto PRIMARY KEY (CUIT, cod_producto)`.