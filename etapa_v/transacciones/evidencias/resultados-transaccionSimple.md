# Resultados de los distintos casos de prueba

## Verificar el stock y las ventas antes de la transacción
<img width="614" height="515" alt="Captura de pantalla 2026-11-03 144314" src="https://github.com/user-attachments/assets/72332db0-d0e8-441e-8d2b-08a0659135b3" />

Total de ventas realizadas 22 

## Caso 1 - Exitoso
<img width="704" height="387" alt="Captura de pantalla 2026-11-03 144713" src="https://github.com/user-attachments/assets/0f768c24-a721-4541-a461-b0e31e3c4e14" />
<img width="798" height="497" alt="Captura de pantalla 2026-11-03 144835" src="https://github.com/user-attachments/assets/f29833e7-84b2-4bd0-b6d6-b350d931e58e" />

## Caso 2 - ROLLBACK
<img width="810" height="515" alt="Captura de pantalla 2026-11-03 144912" src="https://github.com/user-attachments/assets/575c0245-d8f0-47c3-8d35-acb83c98f435" />
<img width="793" height="405" alt="Captura de pantalla 2026-11-03 144925" src="https://github.com/user-attachments/assets/363c3cfe-9e1d-48f4-8a8b-9b76d3e3ac95" />

## Caso 3 
<img width="1002" height="522" alt="Captura de pantalla 2026-11-03 145037" src="https://github.com/user-attachments/assets/bb4960a8-fe05-4f0c-a1c6-7e816fb2eacb" />
<img width="812" height="365" alt="Captura de pantalla 2026-11-03 145057" src="https://github.com/user-attachments/assets/e0afcd73-239d-4fc3-9d85-640981e6074e" />

*Observación: no se efectúo la venta, por mas que hubiera stock suficiente, ya que ya existe una venta registrada con el mismo `num_comprobante` violando la regla de integridad.
En la salida, se muestra la venta `2001` pero la del caso 1 y la cantidad del producto 5 no se modificó.

## Caso 4
<img width="809" height="491" alt="Captura de pantalla 2026-11-03 145153" src="https://github.com/user-attachments/assets/1b0fe5e8-8c46-484b-b8e5-aadabb25a9f7" />
<img width="768" height="395" alt="Captura de pantalla 2026-11-03 145209" src="https://github.com/user-attachments/assets/7e38d8cb-5ee3-4dd8-923c-83c446f20173" />

*Observación: no se efectúo la venta en este caso, ya que por regla de negocio no se puede vender un producto que no existe en lista

## Estado del stock y total ventas despues de las transacciones
<img width="715" height="566" alt="Captura de pantalla 2026-11-03 145416" src="https://github.com/user-attachments/assets/72279922-d110-443e-b0e3-930008b3b71a" />

*Observaciones: solo se registro una venta nueva, **total de ventas 23** y se actualizó el stock del producto 3 (cant_disponible 15).
# CONCLUSIONES
Los cuatro casos dieron el resultado esperado. La transacción cumple lo que se le pidió: una venta se confirma completa o no deja ningún rastro. Las pruebas confirman que `sp_RegistroVenta` (donde se encuentra la transacción simple) ejecuta la venta como una unidad atómica: ante stock suficiente confirma venta, detalle y descuento de stock; ante stock insuficiente revierte la transacción y el estado de la base queda como si no hubiera ejecutado nada. También queda demostrado las restricciones `CHECK` del diseño (etapa 2) manteniendo la integridad del sistema en casos como producto inexistente o clave duplicada.
