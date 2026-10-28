# Etapa V - investigación: _triggers de auditoría_

## 1. Definición y objetivo
Un _trigger_ o (disparador) es un proceso en la base de datos que se ejecuta luego de la realización de un evento como ser la inserción de un elemento, su modificación o eliminación.
Su principal objetivo es mejorar la gestión de la base de datos, al ejecutarse sin necesitar de un usuario, además de servir para prevenir errores o documentar información como nosotros lo implementamos en este proyecto.

## 2. Ventajas
- Generar automáticamente algunos valores de columna derivados.
- Aplicar la integridad referencial.
- Registro de eventos y almacenamiento de información sobre el acceso a la tabla.
- Auditoría.
- Replicación sincrónica de tablas.
- Imponer autorizaciones de seguridad.
- Prevenir transacciones inválidas.

## 3. Implementación
Los distintos tipos de triggers varían en base a cuándo se ejecutaría, antes de la sentencia de disparo (BEFORE), luego de la misma (AFTER) o un trigger que se ejecute en lugar de la instrucción (INSTEAD OF).
Los trigger se crean de la siguiente forma:

```CREATE  TRIGGER  [Nombre_Trigger]``` // es el nombre definido por el usuario para el nuevo Trigger.

```ON  [Nombre_tabla]``` // es la tabla a la que se aplica Trigger.

```AFTER {[INSERT],[UPDATE],[DELETE]} ``` //Después de qué evento se dispara.

```[NOT  FOR  REPLICATION]``` // Esta opción indica a SQL Server que no active el disparador cuando la modificación de datos se realiza como parte de un proceso de replicación.

```AS```

```{sql_statements}``` //Lo que se ejecutará.

## 4. Bibliografía
- https://www.aluracursos.com/blog/que-es-y-como-trigger-en-sql
- https://es.wikipedia.org/wiki/Trigger_(base_de_datos)
