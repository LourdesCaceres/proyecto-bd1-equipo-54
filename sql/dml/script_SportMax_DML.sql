---RELLENAMOS LAS TABLAS CON LOS REGISTROS---

---Utilización de la Base de Datos utilizada---
USE SistemaSportMax;
GO

---Rellenamos las tablas sin FK primero--
INSERT INTO PERSONA (direccion, nombre, DNI, email, apellido, telefono)
VALUES
('Junin 1567', 'Ezequiel', 40543222, 'ezePe222@gmail.com', 'Perez', 37942267),
('Av. Libertad 507', 'Pablo', 43778234, 'pabloblo007@gmail.com', 'Lopez', 37722267),
('Av. Maipú 525', 'Sofia', 39738523, 'sofiM0r0ch1@hotmail.com', 'Vergara', 37952555),
('Los Gladiolos 112', 'Marta', 47616254, 'mamurta4646@gmail.com', 'Espindola', 37725228),
('Bolivar 1477', 'Pedro', 41733222, 'pepeClavo@gmail.com', 'Sanchez', 37945567),
('Los Crisantemos 732', 'Mirta', 38557890, 'mirta.leguiza@yahoo.com', 'Leguiza', 37726678),
('Av.Libertad 1224', 'Sandra', 43335655, 'sandrita2008bb@gmail.com', 'Martinez', 37962215),
('Los Tulipanes', 'Lucas', 40333757, 'lukitasbokapapa@gmail.com', 'Perez', 36733456),
('Av. Libertad 612', 'Pablo', 40993044, 'pavlov2005kpo@gmail.com', 'Espinoza', 38824522),
('San Martin', 'Gaston', 41643554, 'gatovegetta07@hotmail.com', 'Escalante', 37729002);

INSERT INTO CATEGORIA (descripcion)
VALUES
('Indumentaria'),
('Accesorio'),
('Equipo');

INSERT INTO PROVEEDOR (CUIT, razon_social, Direccion, telefono)
VALUES
(55634675, 'Hermanos Ramirez S.A', 'Av. Las Heras 533', 34556756),
(59645223, 'Sporty Enterprises SRL.', 'Los Gladiolos 223', 34886756),
(60934675, 'Unión Deportiva', 'Av. Libertad 877', 34556455),
(66638875, 'Hernandez y asociados S.A', 'Av. Las Heras 223', 34111756),
(81643675, 'UltraSport SRL.', 'Las Violetas 1543', 66553756),
(55634888, 'Laboratorios Sinemal S.A', 'Av. Las Heras 1886', 49976756),
(55611275, 'Martinez y Martinez S.A', 'San Juan 233', 22356756),
(59864675, 'Laboratorios RunnerX SRL', 'Av. Maipú 1335', 34116789),


INSERT INTO CLIENTE (fecha_alta, DNI_cliente)
VALUES
('2026-09-01', 40543222),
('2026-09-02', 43778234),
('2026-09-02', 43335655),
('2026-09-03', 47616254),
('2026-09-04', 41643554);

INSERT INTO VENDEDOR (cod_vendedor, fecha_ingreso, DNI_vendedor)
VALUES
(001, '2026-08-30', 39738523),
(002, '2026-08-30', 41733222),
(003, '2026-09-01', 38557890),
(004, '2026-09-01', 40333757),
(005, '2026-09-02', 40993044);

INSERT INTO MED_DE_PAGO (detalle)
VALUES
('Efectivo'),
('Transferencia'),
('Débito'),
('Crédito');

INSERT INTO PROVEEDOR_PRODUCTO (CUIT, cod_producto)
VALUES
(55634675, 1),
(59645223, 2),
(60934675, 3),
(66638875, 4),
(81643675, 5),
(55634888, 6),
(55611275, 7),
(59864675, 8),
(55634675, 9),
(60934675, 10);
GO

INSERT INTO VENTAS (numero_com, cant_cuotas, cod_pago, DNI_cliente, DNI_vendedor)
VALUES
(1001, 1, 1, 40543222, 39738523),
(1002, 3, 4, 43778234, 41733222),
(1003, 1, 3, 43335655, 38557890),
(1004, 2, 4, 47616254, 40333757),
(1005, 1, 2, 41643554, 40993044),
(1006, 1, 1, 40543222, 40993044),
(1007, 3, 4, 43778234, 39738523),
(1008, 1, 3, 47616254, 41733222),
(1009, 2, 4, 41643554, 38557890),
(1010, 1, 2, 43335655, 40333757);
GO
