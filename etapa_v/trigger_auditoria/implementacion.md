# IMPLEMENTACIÓN DEL CONCEPTO DE TRIGGER

En la elaboración de nuestra base de datos SportMax, decidimos implementarlos en un sistema de auditoria, es decir, un sistema en
dónde el usuario será capaz de informarse de cualquier evento ocurrido con los datos de la base. De esa forma se podría tener un registro
mucho más ordenado y útil a poder revisar y conocer cuándo un producto fue modificado, por ejemplo al subir de precio, o eliminado porque
se dejó de producir.

Con esta idea en mente, nos centramos sobre los dos eventos principales que se pueden realizar sobre el SGBD: UPDATE y DELETE. Mediante la creación
de un trigger que engloba ambos eventos y el uso de tablas auxiliares, permitimos un sistema donde al modificar o eliminar un producto este cambio
queda registrado en una tabla auxiliar AUDITORIA. Al revisar esa tabla podremos ver: el id del cambio, sobre qué tabla se modificó y cuál fue el cambio, junto
a datos muy relevantes como la fecha de la modificación y quién la realizó.

## FORMAS DE LOS TRIGGERS

Como pudimos ver en la investigación, hay dos maneras de implementar triggers, antes o después del evento (BEFORE/AFTER) y en lugar del evento
(INSTEAD OF). En nuestro sistema de auditoria utilizamos mayormente el primer tipo, únicamente triggers de estilo AFTER porque era el que más
se ajustaba a la idea de registrar cambios. Esto lo implementamos de forma que cuándo un tabla es modificada o eliminada LUEGO de eso se 
registrará en una tabla de esa manera podemos tener retroactividad constante.

Por otro lado, implementamos un trigger específico para probar el caso en el qué una tabla no puede ser eliminada, siendo importante utilizar
en ese caso el INSTEAD OF. Como CATEGORIA es la tabla con menos elementos y con mayor relación con el resto de tablas, consideramos que era una
parte importante del sistema y que su eliminación era muy grave para el mantenimiento del mismo. Con esto, decidimos que el usuario no pueda
eliminar una categoria y esto lo hicimos con un trigger, el cual mediante INSTEAD OF DELETE, verifica si el usuario intenta hacer un DELETE
en CATEGORIA y, si lo hace, reemplaza esa acción por la impresión de un mensaje en pantalla informando que la acción no está permitida.
