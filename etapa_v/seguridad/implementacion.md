# IMPLEMENTACIÓN DE SEGURIDAD: PERMISOS A NIVEL DE USUARIOS Y ROLES

Para aplicar el tema 4 en SportMax implementamos dos casos prácticos sobre la base `SistemaSportMax`: permisos asignados a nivel de **usuario** y permisos asignados a nivel de **rol** del DBMS. En total se crean 4 usuarios, dos por caso. 
El objetivo es estructurar la autenticación (logins) y la autorización (usuarios y roles) para que cada perfil acceda solo a las operaciones asignadas.

#### **Antes de ejecutar los script verificamos el modo de autenticación de la instancia:**

- La instancia `SQLEXPRESS` estaba configurada solo con autenticación de Windows.
- Se cambió a **modo mixto** desde _Propiedades del servidor > Seguridad > Autenticación de servidor_ y se reinició el servicio.

## USUARIOS CREADOS

Cada login tiene un usuario de base de datos del mismo nombre. Las contraseñas se definen en el script (no se documentan aquí)

| Caso | Login y usuario | Permisos |
|---|---|---|
| Nivel usuario | `usuario_admin` | administrador de la base |
| Nivel usuario | `usuario_repositor` | solo lectura y `GRANT EXECUTE` sobre `dbo.sp_InsertarProducto` |
| Nivel rol | `usuario_con_rol` | rol_consulta_productos |
| Nivel rol | `usuario_sin_rol` | Ninguno |

## CASO 1: PERMISOS A NIVEL DE USUARIO

- **Administrador:** `usuario_admin` se agrega a `db_owner`. Tiene control total sobre `SistemaSportMax`.
- **Solo lectura:** `usuario_repositor` se agrega a `db_datareader`, por lo que puede consultar las tablas pero no modificarlas.
- **Ejecución del procedimiento:** a `usuario_repositor` se le concede `EXECUTE` sobre `sp_InsertarProducto` (procedimiento del Tema 1, que recibe `@nombre`, `@precio_actual`, `@cant_disponible` y `@cod_categoria`).

El caso muestra la diferencia entre ejecutar una sentencia directa y usar el procedimiento: `usuario_repositor` no puede hacer `INSERT` sobre `PRODUCTO`, pero sí registrar un producto a través de `sp_InsertarProducto`. Esto funciona porque el procedimiento y la tabla pertenecen a `dbo` (cadena de propiedad) y el procedimiento no usa SQL dinámico.

## CASO 2: PERMISOS A NIVEL DE ROL

- Se crea el rol personalizado `rol_consulta_productos` con `GRANT SELECT` sobre `dbo.PRODUCTO`.
- Solo `usuario_con_rol` se agrega como miembro del rol.
- `usuario_sin_rol` no recibe ningún permiso explícito, por lo que queda denegado de forma implícita.
- Ambos usuarios intentan consultar el contenido de la tabla y solo el miembro del rol puede hacerlo.

#### **Implementamos validaciones a cada uno de los script para evitar errores durante la ejecución**

Todas las sentencias de creación (logins, usuarios y rol) están envueltas en bloques `IF NOT EXISTS`, de modo que el script puede ejecutarse varias veces sin errores 
de objeto existente (errores 15025 y 15023). Se usan dos catálogos distintos según el nivel del objeto:

- `sys.server_principals`: para los logins (nivel servidor).
- `sys.database_principals`: para los usuarios y el rol (nivel base de datos).

```sql
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_con_rol')
    CREATE LOGIN usuario_con_rol WITH PASSWORD = '...';

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_con_rol' AND type = 'S')
    CREATE USER usuario_con_rol FOR LOGIN usuario_con_rol;
```

## CASOS DE PRUEBA

Cada caso se ejecuta con `EXECUTE AS USER` y se vuelve al contexto original con `REVERT`

| Caso | Usuario | Operación | Resultado esperado | Resultado obtenido |
|---|---|---|---|---|
| 1 | `usuario_admin` | `INSERT` directo sobre `PRODUCTO` | Éxito | Éxito: 1 fila afectada |
| 2 | `usuario_repositor` | `INSERT` directo sobre `PRODUCTO` | Permiso denegado | Error 229 (nivel 14, estado 5): permiso `INSERT` denegado sobre `PRODUCTO` |
| 3 | `usuario_repositor` | `EXEC sp_InsertarProducto` | Éxito | Éxito: 1 fila afectada |
| 2.1 | `usuario_con_rol` | `SELECT` sobre `PRODUCTO` | Éxito | Éxito: devuelve el contenido de la tabla (13 filas) |
| 2.2 | `usuario_sin_rol` | `SELECT` sobre `PRODUCTO` | Permiso denegado | Error 229 (nivel 14, estado 5): permiso `SELECT` denegado sobre `PRODUCTO` |
