## *Decisiones de Diseño (Etapa I)*

Criterios aplicados durante la Etapa I: cómo se diferenciaron las reglas de negocio explícitas de las implícitas y en qué se fundamentó cada una de estas últimas, por qué se establecieron ciertas restricciones de dominio, y qué criterio se usó para definir el alcance funcional del sistema.

### *Cómo separamos RN explícitas de implícitas*
- Explícita = sale directo del texto y describe una relación entre los actores del caso (quién se relaciona con quién, y con qué cardinalidad).
- Implícita = describe un comportamiento del sistema (una acción, una validación, un cálculo).
- Ejemplo: RN.01 ("un vendedor puede realizar muchas ventas") es explícita porque describe la relación Vendedor-Venta. RN.10 ("al confirmarse la venta se descuenta el stock") es implícita porque es una acción que se dispara ante un evento, no una relación entre entidades.

### *De dónde sale cada regla implícita*
- **RN.10** (descuento de stock) → de "al confirmarse la operación, se debe descontar el stock vendido".
- **RN.11** (no vender sin stock disponible) → de "sin permitir ventas que superen las unidades disponibles". La separamos de RN.10 porque son dos comportamientos distintos: una ejecuta el descuento, la otra bloquea una operación inválida antes de que pase.
- **RN.12** (interés calculado) → de "un interés, definido como un atributo calculado en base a la cantidad de cuotas". Está mencionado dentro del párrafo de medio de pago pero no como regla aparte, así que la armamos como implícita porque define un valor derivado, no una relación.

### *Restricciones del dominio*
- Local único, sin sucursales.
- Sin venta online.
- Sin devoluciones ni cambios.
- Por qué: el caso ya habla de "el local" en singular y no menciona otros canales ni políticas de devolución. Cada cosa que sumáramos (sucursales, carrito online, notas de crédito) mete entidades nuevas y más trabajo de implementación sin aportar mucho al caso concreto.


### *Criterio de inclusión/exclusión*

Se incluye todo proceso necesario para el ciclo mínimo de venta (elegir producto → confirmar venta → actualizar stock). Se excluye todo lo que requiere integración con un sistema externo.

Se incluye - Por qué
- Clientes y vendedores — participantes principales de las operaciones.
- Stock por producto con descuento automático — está explícito en el caso.
- Precio histórico en el detalle de venta — también explícito (RN.09).
- Medios de pago con interés calculado — explícito.
- Categorías y proveedores — sin categoría no hay cómo clasificar productos, sin proveedor no hay de dónde sale la mercadería.

Se excluye - Por qué
- Facturación electrónica: (ej. ARCA) Requiere integración con un servicio externo.
- Venta online / e-commerce: Agrega un canal y una sección (carrito) que nos resulta compleja su implementación.
- Múltiples sucursales: El caso describe un local único; sumar sucursales obligaría a rediseñar el modelo de stock y ventas.
- Devoluciones y cambios: No está mencionado en el caso, y agregar esta política implicaría nuevas entidades (nota de crédito, motivo de devolución)
- Administración de empleados: Es un dominio distinto (RRHH), que no forma parte de la gestión de ventas.
