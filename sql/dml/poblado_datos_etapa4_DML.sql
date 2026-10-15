USE SistemaSportMax;
GO

-- Insertamos nuevas personas --
INSERT INTO PERSONA (direccion, nombre, DNI, email, apellido, telefono)
VALUES
('Av. 3 de Abril 1245', 'Gonzalo', 42115678, 'gonza.corrientes@gmail.com', 'Acosta', 37941234),
('Córdoba 840', 'Camila', 41882345, 'cami_valdez99@hotmail.com', 'Valdez', 37948890),
('Av. Ferré 2150', 'Matías', 40123987, 'matias.rodriguez@yahoo.com', 'Rodriguez', 37943321),
('Mendoza 620', 'Valentina', 44230112, 'valen.romero01@gmail.com', 'Romero', 37951122),
('Av. Pujol 1890', 'Joaquín', 39887123, 'joaco_ramirez@hotmail.com', 'Ramirez', 37947766),
('Pellegrini 1032', 'Lucía', 43554901, 'lulu.benitez22@gmail.com', 'Benítez', 37949988),
('Av. Centenario 3410', 'Agustín', 42998341, 'agustingomez_ctes@gmail.com', 'Gómez', 37946655),
('Carlos Pellegrini 1450', 'Florencia', 41320554, 'flor_ferreyra@yahoo.com', 'Ferreyra', 37953344),
('Av. Armenia 2800', 'Nicolas', 40776123, 'nico.alvarez00@gmail.com', 'Álvarez', 37942211),
('Catamarca 915', 'Mariana', 38991204, 'marianita_cano@hotmail.com', 'Cano', 37958877),
('Av. Chacabuco 1520', 'Diego', 42443098, 'diego.sosa.ctes@gmail.com', 'Sosa', 37945511),
('Belgrano 1780', 'Rocío', 43112987, 'roci_mendez98@gmail.com', 'Méndez', 37940033),
('9 de Julio 1120', 'Esteban', 39554123, 'esteban_barrios@yahoo.com', 'Barrios', 37956622),
('Av. Independencia 4200', 'Micaela', 41223876, 'mica.duarte02@gmail.com', 'Duarte', 37944499),
('Salta 530', 'Facundo', 40889234, 'facu_ojeda_ctes@hotmail.com', 'Ojeda', 37952288);
GO

-- Modificación de fecha de alta para un cliente --
UPDATE CLIENTE
SET fecha_alta = '2026-08-30'
WHERE DNI_cliente = 40543222;
GO

-- Alta de los nuevos clientes --
INSERT INTO CLIENTE (fecha_alta, DNI_cliente)
VALUES
('2026-09-05', 42115678),
('2026-09-05', 41882345),
('2026-09-06', 40123987),
('2026-09-06', 44230112),
('2026-09-07', 39887123),
('2026-09-08', 43554901),
('2026-09-08', 42998341),
('2026-09-09', 41320554),
('2026-09-09', 40776123),
('2026-09-10', 38991204),
('2026-09-10', 42443098),
('2026-09-11', 43112987),
('2026-09-11', 39554123),
('2026-09-12', 41223876),
('2026-09-12', 40889234);
GO

-- Actualización de los registros del 1001 al 1010 con sus fechas correspondientes --
UPDATE VENTAS SET fecha = '2026-08-31 10:15:00' WHERE numero_com = 1001;
UPDATE VENTAS SET fecha = '2026-09-02 11:30:00' WHERE numero_com = 1002;
UPDATE VENTAS SET fecha = '2026-09-03 16:45:00' WHERE numero_com = 1003;
UPDATE VENTAS SET fecha = '2026-09-05 09:20:00' WHERE numero_com = 1004;
UPDATE VENTAS SET fecha = '2026-09-08 14:10:00' WHERE numero_com = 1005;
UPDATE VENTAS SET fecha = '2026-09-12 18:05:00' WHERE numero_com = 1006;
UPDATE VENTAS SET fecha = '2026-09-15 10:00:00' WHERE numero_com = 1007;
UPDATE VENTAS SET fecha = '2026-09-20 17:30:00' WHERE numero_com = 1008;
UPDATE VENTAS SET fecha = '2026-09-25 12:15:00' WHERE numero_com = 1009;
UPDATE VENTAS SET fecha = '2026-09-29 19:40:00' WHERE numero_com = 1010;
GO

-- Agregado de los nuevos registros --
INSERT INTO VENTAS (numero_com, fecha, cant_cuotas, cod_pago, DNI_cliente, DNI_vendedor)
VALUES
(1011, '2026-10-02 10:50:00', 1, 1, 42115678, 39738523),
(1012, '2026-10-05 15:20:00', 3, 4, 41882345, 41733222),
(1013, '2026-10-08 11:05:00', 1, 2, 40123987, 38557890),
(1014, '2026-10-12 14:45:00', 1, 3, 44230112, 40333757),
(1015, '2026-10-15 18:30:00', 3, 4, 39887123, 40993044),
(1016, '2026-10-18 09:15:00', 1, 1, 43554901, 39738523),
(1017, '2026-10-21 16:10:00', 1, 2, 42998341, 41733222),
(1018, '2026-10-24 13:55:00', 2, 4, 41320554, 38557890),
(1019, '2026-10-27 10:25:00', 1, 3, 40776123, 40333757),
(1020, '2026-10-29 17:40:00', 3, 4, 38991204, 40993044),
(1021, '2026-10-30 12:00:00', 1, 1, 42443098, 39738523),
(1022, '2026-10-31 19:15:00', 1, 2, 43112987, 41733222);
GO

-- Vaciar la tabla para recargarla con variaciones de precios y una combinación de 2 a 3 detalles por venta
TRUNCATE TABLE DETALLE_VENTA;
GO

-- Precios progresivos entre agosto y octubre de 2026
-- Agosto: Sin cambios
-- Septiembre: aumento del 2% desde el día 16
-- Octubre: aumento del 4% hasta el día 15 y del 6% desde el día 16
INSERT INTO DETALLE_VENTA
(cod_producto, numero_com, precio_unit, cantidad)
VALUES
-- AGOSTO 2026
-- Venta 1001
(1, 1001, 45000.00, 1),
(2, 1001, 25000.00, 2),
(3, 1001, 85000.00, 1),

-- SEPTIEMBRE 2026
-- Venta 1002 
(3, 1002, 85000.00, 1),
(4, 1002, 12000.00, 1),
-- Venta 1003 
(4, 1003, 12000.00, 2),
(5, 1003, 15000.00, 1),
(6, 1003, 5500.00, 1),
-- Venta 1004
(5, 1004, 15000.00, 2),
(7, 1004, 35000.00, 1),
-- Venta 1005
(6, 1005, 5500.00, 1),
(10, 1005, 8500.00, 3),
(1, 1005, 45000.00, 1),
-- Venta 1006
(7, 1006, 35000.00, 1),
(8, 1006, 42000.00, 1),
-- Venta 1007 
(8, 1007, 42000.00, 1),
(9, 1007, 22000.00, 1),
(10, 1007, 8500.00, 2),
-- Venta 1008
-- (Aumento del 2%)
(9, 1008, 22440.00, 2),
(10, 1008, 8670.00, 1),
-- Venta 1009
(10, 1009, 8670.00, 1),
(1, 1009, 45900.00, 1),
(2, 1009, 25500.00, 2),
-- Venta 1010 
(1, 1010, 45900.00, 1),
(2, 1010, 25500.00, 1),

-- OCTUBRE 2026
-- Venta 1011
-- (Aumento del 4%)
(1, 1011, 46800.00, 1),
(5, 1011, 15600.00, 1),
(3, 1011, 88400.00, 1),
-- Venta 1012 
(2, 1012, 26000.00, 1),
(3, 1012, 88400.00, 1),
-- Venta 1013
(6, 1013, 5720.00, 3),
(10, 1013, 8840.00, 1),
(4, 1013, 12480.00, 1),
-- Venta 1014 
(1, 1014, 46800.00, 1),
(7, 1014, 36400.00, 1),
-- Venta 1015
(3, 1015, 88400.00, 1),
(8, 1015, 43680.00, 1),
(9, 1015, 22880.00, 1),
-- Venta 1016
-- (Aumento del 6%)
(1, 1016, 47700.00, 1),
(4, 1016, 12720.00, 1),
-- Venta 1017
(2, 1017, 26500.00, 2),
(6, 1017, 5830.00, 1),
(5, 1017, 15900.00, 1),
-- Venta 1018 
(7, 1018, 37100.00, 1),
(8, 1018, 44520.00, 1),
-- Venta 1019 
(9, 1019, 23320.00, 1),
(10, 1019, 9010.00, 4),
(1, 1019, 47700.00, 1),
-- Venta 1020
(1, 1020, 47700.00, 1),
(2, 1020, 26500.00, 1),
-- Venta 1021
(5, 1021, 15900.00, 1),
(6, 1021, 5830.00, 2),
(3, 1021, 90100.00, 1),
-- Venta 1022
(4, 1022, 12720.00, 2),
(9, 1022, 23320.00, 1);
GO
