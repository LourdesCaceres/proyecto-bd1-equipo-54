# ***DOCUMENTACIÓN SOBRE LOS RESULTADOS DE LA CONSULTA AVANZADA***
* Nuestra consulta avanzada consiste en hallar los clientes cuyo gasto total supera el gasto promedio por cliente.
* Esta consulta utiliza una subconsulta para calcular el promedio de gastos y para filtrar los clientes que superan ese promedio.
* Mediante JOIN unimos las tablas VENTAS, DETALLE_VENTA, CLIENTE y PERSONA para hallar los resultados requeridos.
* La tabla de clientes resultantes es mostrada con los datos: DNI, nombre, apellido y el gasto total.

## ***RESULTADOS EN  TABLA***
|  | DNI_cliente |  nombre  |  apellido  | gasto_total |
|--| ----------- | -------- | ---------- | ----------- |
| 1|  39887123	 |  Joaquín	|  Ramirez	 |  154960.00  |
| 2|  40543222	 |  Ezequiel|	 Perez	   |  257000.00  |
| 3|  40776123	 |  Nicolas	|  Álvarez	 |  107060.00  |
| 4|  41643554	 |  Gaston	|  Escalante |	181570.00  |
| 5|  41882345	 |  Camila	|  Valdez	   |  114400.00  |
| 6|  42115678	 |  Gonzalo	|  Acosta	   |  150800.00  |
| 7|  42443098	 |  Diego	  |  Sosa	     |  117660.00  |
| 8|  43335655	 |  Sandra	|  Martinez  |  115900.00  |
| 9|  43778234   | 	Pablo	  |  Lopez	   |  178000.00  |
|10|  47616254	 |  Marta	  |  Espindola |	118550.00  |
