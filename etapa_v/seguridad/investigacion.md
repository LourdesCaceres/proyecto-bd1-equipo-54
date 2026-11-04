# Seguridad: Manejo de permisos a nivel de usuarios y roles en SQL Server

## 1. ¿En qué consisten?

La seguridad de una base de datos controla **quién puede conectarse** (autenticación) y **qué puede hacer cada uno una vez conectado** (autorización). En SQL Server esto se resuelve con tres piezas: principales (quién), objetos protegibles (sobre qué) y permisos (qué operación).

### 1.1 Autenticación: modos y niveles de identidad
- **Modo Windows:** solo se aceptan cuentas de Windows. Es el modo predeterminado y el que recomienda Microsoft cuando es posible.
- **Modo mixto:** además de Windows, acepta _logins_ propios de SQL Server (usuario y contraseña gestionados por el motor). Es el modo que requiere este tema.
- **Login (nivel servidor):** identidad que permite conectarse a la instancia.
- **User (nivel base de datos):** identidad dentro de una base, asociada a un login. Un login sin user no puede operar dentro de la base.

```sql
CREATE LOGIN lg_ejemplo WITH PASSWORD = 'Ejemplo#2026';   -- nivel servidor
USE SistemaSportMax;
CREATE USER usr_ejemplo FOR LOGIN lg_ejemplo;             -- nivel base de datos
```

### 1.2 Autorización: GRANT, DENY y REVOKE
- `GRANT`: concede un permiso (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `EXECUTE`, etc.) sobre un objeto protegible: base de datos, esquema, tabla, vista o procedimiento.
- `DENY`: prohíbe un permiso de forma explícita y **prevalece sobre cualquier `GRANT`**, incluso el heredado por un rol.
- `REVOKE`: retira un `GRANT` o un `DENY` previo; no concede ni prohíbe.
- Sin ningún permiso, el acceso queda **denegado de forma implícita**: en SQL Server los permisos son cerrados por defecto.

```sql
GRANT  SELECT  ON dbo.PRODUCTO TO usr_ejemplo;   -- puede leer
DENY   DELETE  ON dbo.PRODUCTO TO usr_ejemplo;   -- no puede borrar, aunque algún rol se lo conceda
REVOKE SELECT  ON dbo.PRODUCTO FROM usr_ejemplo; -- retira el permiso otorgado
```

### 1.3 Roles
Un rol es un conjunto de permisos que se asigna a varios usuarios: se otorgan los permisos al rol y luego se agregan los usuarios como miembros.
- **Roles fijos de base de datos:** vienen con el motor (`db_owner`, `db_datareader`, `db_datawriter`, `db_denydatawriter`, etc.).
- **Roles definidos por el usuario:** se crean a medida, con exactamente los permisos necesarios.

```sql
CREATE ROLE rol_consulta_proveedores;
GRANT SELECT ON dbo.PROVEEDOR TO rol_consulta_proveedores;
ALTER ROLE rol_consulta_proveedores ADD MEMBER usr_ejemplo;
```

### 1.4 Permisos directos al usuario frente a permisos por rol
- **Al usuario:** simple para pocos casos, pero cada cambio debe repetirse usuario por usuario.
- **Por rol:** se modifica una sola vez y alcanza a todos los miembros; es la práctica recomendada cuando varios usuarios comparten el mismo perfil.

### 1.5 Principio de mínimo privilegio
Cada usuario recibe únicamente los permisos que necesita para su tarea y nada más. Es el criterio de diseño de todo el tema.

### 1.6 Procedimientos almacenados como interfaz controlada y cadena de propiedad
Un usuario puede tener permiso de `EXECUTE` sobre un procedimiento sin tener permiso de escritura sobre las tablas que ese procedimiento modifica. Esto funciona por la **cadena de propiedad** (_ownership chaining_): si el procedimiento y los objetos que referencia pertenecen al mismo propietario, SQL Server verifica solo el permiso sobre el procedimiento y no los de los objetos internos. La cadena se corta si el procedimiento usa SQL dinámico.

```sql
GRANT EXECUTE ON dbo.sp_InsertarProducto TO usr_ejemplo;
-- usr_ejemplo puede ejecutar el procedimiento pero un INSERT directo sobre PRODUCTO sigue denegado
```

## 2. Ventajas y desventajas

### Ventajas
- Protegen la información sensible y evitan modificaciones accidentales o no autorizadas.
- Aplican el mínimo privilegio: cada perfil accede solo a lo que necesita.
- Los roles centralizan la administración: un cambio de permisos se hace una vez y alcanza a todos los miembros.
- Los procedimientos almacenados exponen operaciones autorizadas sin abrir las tablas, y mantienen la lógica de negocio bajo control.
- La configuración es verificable: el catálogo (`sys.database_permissions`, `sys.database_role_members`) permite auditar quién puede qué.

### Desventajas
- El modo mixto amplía la superficie de ataque: las contraseñas de los logins las gestiona el motor y deben protegerse (no versionarlas, aplicar política de contraseñas).
- Con muchos usuarios y roles, rastrear el permiso efectivo se complica: se combinan permisos directos, permisos de roles y `DENY` (que prevalece).
- La cadena de propiedad es un comportamiento implícito y puede sorprender; se corta con SQL dinámico o con objetos de distinto propietario.
- Requiere mantenimiento: hay que revocar permisos cuando cambian las responsabilidades de un usuario.
- Un exceso de permisos «por comodidad» (por ejemplo, `db_owner` para todos) anula el beneficio del modelo.

## 3. Aplicaciones prácticas

En SportMax se aplican dos casos prácticos sobre `SistemaSportMax`:
- **Nivel usuario:** un usuario administrador (`db_owner`) y un usuario de solo lectura con permiso de `EXECUTE` sobre `sp_InsertarProducto` (Tema 1). El usuario de solo lectura no puede insertar productos con `INSERT` directo, pero sí a través del procedimiento.
- **Nivel rol:** el rol `rol_consulta_proveedores` concede lectura sobre `PROVEEDOR`, `PRODUCTO` y `PROVEEDOR_PRODUCTO`. Dos usuarios intentan consultar los proveedores y sus productos asociados: solo el miembro del rol puede hacerlo.

Aplicaciones análogas en el dominio de la tienda:
- Un vendedor registra ventas ejecutando `sp_RegistroVenta`, sin permisos de escritura directa sobre `PRODUCTO` ni `DETALLE_VENTA`.
- Un perfil de consulta (por ejemplo, para reportes) accede únicamente a vistas o tablas de lectura, sin modificar precios ni stock (RN.09 y RN.10).

## 4. Bibliografía
- https://www.datasunrise.com/es/centro-de-conocimiento/gestion-de-usuarios-en-sql-server/
- Cátedra Bases de Datos I (FaCENA, UNNE). Guía de lectura Unidad 5, Tema 12 «Autorización (Control)», y guía de la Etapa V del proyecto.
- https://learn.microsoft.com/es-es/sql/relational-databases/security/authentication-access/create-a-database-user?view=sql-server-ver17 
