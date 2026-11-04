# Resultados de los distintos casos de prueba

## Pruebas para los permisos "Nivel usuario"

#### Caso 1: INSERT directo con usuario_admin - RESULTADO ESPERADO: ÉXITO (Fila afectada)
<img width="917" height="351" alt="Captura de pantalla 2026-11-03 211205" src="https://github.com/user-attachments/assets/e64be5dd-be8e-429c-bfd2-7d98782a0864" />

#### Caso 2: INSERT directo con usuario_repositor - RESULTADO ESPERADO: ERROR (Permiso denegado)
<img width="1040" height="390" alt="Captura de pantalla 2026-11-03 211234" src="https://github.com/user-attachments/assets/90092cf6-ebae-4e36-b386-60fed233bf5c" />

#### Caso 3: INSERT mediante Procedimiento con usuario_repositor - RESULTADO ESPERADO: ÉXITO. 
<img width="1006" height="415" alt="Captura de pantalla 2026-11-03 211539" src="https://github.com/user-attachments/assets/4687e90e-8fac-40a1-a75c-595fdba62d80" />

## Pruebas para los permisos "Nivel roles"

#### Caso 2.2: SELECT con usuario_sin_rol - RESULTADO ESPERADO: ERROR (Permiso denegado). No pertenece a ningún rol 
<img width="744" height="523" alt="Captura de pantalla 2026-11-03 211817" src="https://github.com/user-attachments/assets/66448adb-b6f4-4185-abdd-4df05b94d803" />


#### Caso 2.2: SELECT con usuario_sin_rol - RESULTADO ESPERADO: ERROR (Permiso denegado). No pertenece a ningún rol 
<img width="1058" height="330" alt="Captura de pantalla 2026-11-03 211834" src="https://github.com/user-attachments/assets/7daf8003-7594-4b00-b0e2-6cd465125698" />

## CONCLUSIONES
Las pruebas realizadas sobre `SistemaSportMax` confirman el comportamiento esperado del modelo de permisos de SQL Server. Un usuario sin ningún permiso otorgado, como `usuario_sin_rol`, es rechazado. En el nivel de usuario, 
`usuario_repositor` no puede insertar productos con una sentencia `INSERT` directa, pero sí a través de `sp_InsertarProducto`, porque el procedimiento y la tabla pertenecen al mismo propietario y SQL Server no verifica los permisos de los objetos internos. 

En el nivel de rol, `usuario_con_rol` consulta `PRODUCTO` únicamente por su pertenencia a `rol_consulta_productos`, lo que muestra que administrar accesos mediante roles evita otorgar permisos usuario por usuario.
