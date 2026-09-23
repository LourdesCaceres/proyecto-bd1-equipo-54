# *Decisiones del Diseño Conceptual y Lógico*

### *1. Especialización de Persona en Cliente y Vendedor*

**Decisión:** Persona se modela como entidad fuerte, especializada de forma total y excluyente en Cliente y Vendedor.
**Alternativas consideradas:** Modelar Cliente y Vendedor como entidades independientes, sin una entidad Persona que las englobe.
**Justificación:** RN.03 establece explícitamente que toda persona registrada debe ser cliente o vendedor, y que no puede desempeñar ambos roles a la vez. Esto es exactamente la definición de una especialización total (todo miembro de Persona cae en algún subtipo) y excluyente (no puede pertenecer a los dos a la vez). Además, Cliente y Vendedor comparten un conjunto de atributos idénticos (DNI, nombre, apellido, dirección, teléfono, email), por lo que separarlos como entidades sin relación habría duplicado esos atributos y no habría permitido expresar la restricción de RN.03 dentro del propio DER.

### *2. Categoría como entidad fuerte (no atributo ni entidad débil)*

**Decisión:** Categoría es una entidad fuerte, con clave primaria propia, relacionada 1:N con Producto.
**Alternativas consideradas:** (a) modelar categoría como un atributo de Producto con dominio fijo (indumentaria/equipos/accesorios); (b) modelarla como entidad débil dependiente de Producto.
**Justificación:** La opción (a) fue descartada porque RN.05 le da entidad propia al concepto ("cada categoría agrupa uno o varios productos"), y convertirla en tabla independiente evita hardcodear los valores del rubro mediante un CHECK, siguiendo el criterio estándar de extraer a una entidad todo atributo de dominio fijo y compartido. La opción (b) fue descartada porque una entidad débil se identifica a través de su entidad fuerte, lo que en este caso invertiría la relación: cada categoría quedaría asociada a un único producto, contradiciendo directamente RN.05 ("una categoría agrupa varios productos").

### *3. Detalle_venta como entidad débil con relación identificadora*

**Decisión:** El renglón de venta se modela como una entidad débil (Detalle_venta), identificada parcialmente por número de renglón y dependiente de Venta a través de una relación identificadora.
**Alternativas consideradas:** Guardar cantidad y precio unitario como atributos (simples o compuestos) directamente en Venta.
**Justificación:** Una venta puede tener uno o varios renglones (RN.07), cada uno con su propia cantidad y precio unitario. Si esos datos se guardaran como atributos de Venta, se repetirían por cada producto vendido en una misma operación — exactamente el grupo repetitivo que la Primera Forma Normal prohíbe. Al ser Detalle_venta una entidad sin sentido fuera del contexto de una venta puntual (no tiene identidad propia), corresponde modelarla como entidad débil. Esta decisión, además, es la que permite cumplir RN.09 (historial de precio fijo), ya que cada renglón guarda su propio precio_unitario en el momento de la operación, independiente del precio de lista vigente en Producto.

### *4. No se modela una entidad Stock separada*

**Decisión:** La cantidad disponible se guarda como atributo (cantidad_stock) directamente en Producto. No existe una entidad Stock independiente.
**Alternativas consideradas:** Crear una entidad Stock relacionada con Producto y con Venta, para registrar el descuento de unidades.
**Justificación:** El caso de estudio confirma que SportMax opera en un único local (sin sucursales ni depósitos separados), por lo que no hay ninguna dimensión adicional (ubicación, depósito) que justifique separar el stock del producto. Una entidad Stock sin atributos propios, cuya única razón de ser es duplicar la cantidad que ya vive en Producto, generaría redundancia y un riesgo de inconsistencia entre ambos valores. RN.10 y RN.11 se resuelven como una actualización del atributo cantidad_stock de Producto al confirmarse la venta (se implementará como trigger en la Etapa V), no como una entidad.

### *5. Medio de pago: un único atributo de descripción, no un atributo por tipo*

**Decisión:** Medio_pago tiene un atributo descripción cuyo dominio incluye los valores (efectivo, débito, crédito, transferencia), y un atributo interés calculado.
**Alternativas consideradas:** Modelar efectivo, débito, crédito y transferencia como atributos independientes de Medio_pago.
**Justificación:** Efectivo, débito, crédito y transferencia no son características distintas que coexistan en una misma instancia de medio de pago, sino los posibles valores de una única característica (el tipo de medio de pago). Modelarlos como atributos separados no tiene sentido semántico y no permite representar que una venta usa exactamente un medio de pago con una descripción determinada. El interés, por su parte, es un atributo calculado en base a la cantidad de cuotas (RN.12) y se mantiene separado de la descripción porque solo aplica cuando el medio de pago es crédito en más de una cuota.

### 6. Relación Producto–Proveedor como N:M

**Decisión:** Producto y Proveedor se relacionan mediante una relación N:M (Suministra), sin atributos propios.
**Justificación:** RN.02 lo establece explícitamente en ambos sentidos: un producto puede ser provisto por varios proveedores, y un proveedor puede suministrar varios productos. Al no tener la relación atributos propios (no se registra, por ejemplo, un precio de costo por proveedor), no se requiere convertirla en entidad asociativa a nivel conceptual — se resuelve como tabla intermedia recién en el modelo relacional.

### *7. Cardinalidades mínimas asumidas en cero*

**Decisión:** Se asumió cardinalidad mínima 0 (participación opcional) en tres relaciones que el enunciado no fija con total precisión: Categoría respecto de Producto, y Vendedor y Cliente respecto de Venta.
**Justificación:** Operativamente, una categoría puede crearse antes de tener productos cargados, y una persona puede estar dada de alta como cliente o vendedor sin haber concretado aún ninguna venta. Fijar estas cardinalidades en mínimo 1 obligaría a que no pueda existir, por ejemplo, un vendedor recién ingresado sin ventas registradas, lo cual no es realista para el negocio.
Pendiente de confirmación con el asesor: estas tres cardinalidades son un supuesto de diseño, no una regla explícita del caso de estudio. Si el equipo docente prefiere que sean obligatorias (mínimo 1), es un ajuste menor que no cambia la estructura general del modelo.

### *8. Estrategia de transformación relacional de la especialización*

**Decisión pendiente:** al pasar Persona/Cliente/Vendedor al modelo relacional, se evaluaron dos estrategias: (a) mantener las tres como tablas separadas (Persona, Cliente, Vendedor), vinculadas por DNI; o (b) fusionarlas en una única tabla con un atributo discriminador de rol.
