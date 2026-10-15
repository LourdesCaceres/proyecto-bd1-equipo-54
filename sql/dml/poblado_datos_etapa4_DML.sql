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

-- Agregado de la columna fecha a la tabla --
ALTER TABLE VENTAS ADD fecha DATETIME;
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
(1015, '2026-10-15 18:30:00', 6, 4, 39887123, 40993044),
(1016, '2026-10-18 09:15:00', 1, 1, 43554901, 39738523),
(1017, '2026-10-21 16:10:00', 1, 2, 42998341, 41733222),
(1018, '2026-10-24 13:55:00', 12, 4, 41320554, 38557890),
(1019, '2026-10-27 10:25:00', 1, 3, 40776123, 40333757),
(1020, '2026-10-29 17:40:00', 3, 4, 38991204, 40993044),
(1021, '2026-10-30 12:00:00', 1, 1, 42443098, 39738523),
(1022, '2026-10-31 19:15:00', 1, 2, 43112987, 41733222);
GO
