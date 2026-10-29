# Etapa V - _TRIGGER DE AUDITORIA_ - Casos de Prueba

## Caso 1: modificar un producto.
La tabla PRODUCTO tiene un trigger único que registra los cambios para informar e imprime un mensaje único. Con esto, tomamos el primer producto de nuestra base de datos que es "camiseta de la Seleccion Argentina" con un valor de $45000 y lo modificamos para que valga $48000 y reducir su stock de 50 a 45.

Valores luego de modificar: 
<img width="860" height="143" alt="Captura de pantalla (123)" src="https://github.com/user-attachments/assets/be7f72bf-240a-4d0d-945a-709bc70843f6" />
Registro en la auditoría: 
<img width="897" height="214" alt="Captura de pantalla (124)" src="https://github.com/user-attachments/assets/18e39f18-1828-4210-a709-d9bcac40ac26" />

## Caso 2: eliminar un producto
La tabla PRODUCTO cuenta con una tabla auxiliar que registra los productos eliminados para consultarlos en cualquier momento, probamos esto al eliminar un producto. Para probar esto creamos un producto nuevo y lo eliminamos, lo hacemos así para evitar dejar datos incompletos en la base de dato o modificar datos importantes.

Valores de prueba: 
<img width="691" height="247" alt="Captura de pantalla (125)" src="https://github.com/user-attachments/assets/7bdd35fa-7fea-4195-aa9c-438556df590c" />

## Caso 3: límites y datos erróneos.
- Nuestras reglas de negocio dicen que el stock no puede ser negativo, probamos entonces el límite en el que la cantidad es 0. Probamos esto en el producto 2 de la tabla. Esto debería ser permitido y registrado en la auditoria.
- El precio de un producto debe ser mayor a cero, probamos entonces actualizar un producto y poner su precio a 0. SQL directamente no produce este cambio y en su lugar genera un error, si consultamos la tabla de auditoría no veremos este cambio porque no se efectuó. Lo mismo sucede con un stock o precio negativos.

Stock 0: 
<img width="665" height="243" alt="Captura de pantalla (128)" src="https://github.com/user-attachments/assets/f32f50c7-6099-45eb-9f55-71a43ad23de8" />
Registro de stock 0: 
<img width="844" height="183" alt="Captura de pantalla (129)" src="https://github.com/user-attachments/assets/d7e74502-ccb1-4eb5-a6a4-62cd5b313071" />
Error al intentar tener precio 0: 
<img width="980" height="226" alt="Captura de pantalla (130)" src="https://github.com/user-attachments/assets/5706b1a9-70d9-453a-8fc9-4baa58a57c7f" />

## Caso 4: intentar eliminar una categoría.
En la tabla CATEGORIA definimos un trigger para que no se pueda quitar un elemento de la misma y en su lugar emita un mensaje, probamos esto mismo en el script. Como no se puede efectuar, la categoría sigue igual y la auditoria para CATEGORIA permanece vacía.

Error al intentar eliminar junto a mensaje personalizado: 
<img width="870" height="225" alt="Captura de pantalla (132)" src="https://github.com/user-attachments/assets/e49261c4-b616-42f7-8dde-5b62e80e465a" />
Tabla vacía para la auditoria de CATEGORIA: 
<img width="514" height="222" alt="Captura de pantalla (134)" src="https://github.com/user-attachments/assets/3f9118aa-422f-4671-b7c3-6440aafad17b" />

## Caso 5: trigger en otra tabla.
Como PRODUCTO y CATEGORIA tienen triggers específicos, decidimos probar modificar el teléfono en un proveedor para comprobar que la auditoría general funciona adecuadamente para cualquier tabla de la base de datos.
Proveedor modificado: 
<img width="776" height="173" alt="Captura de pantalla (136)" src="https://github.com/user-attachments/assets/8adec25e-3112-4887-ae53-281bf4c41837" />
Tabla auditoria con el cambio: <img width="919" height="246" alt="Captura de pantalla (137)" src="https://github.com/user-attachments/assets/db8d3504-05bb-4f7f-8bb7-16ee138459c3" />
