CREATE TABLE PERSONA
(
  direccion VARCHAR(50) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  DNI INT NOT NULL,
  email VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  telefono INT NOT NULL,
  PRIMARY KEY (DNI)
);

CREATE TABLE CLIENTE
(
  fecha_alta DATE NOT NULL,
  DNI_cliente INT NOT NULL,
  PRIMARY KEY (DNI_cliente),
  FOREIGN KEY (DNI_cliente) REFERENCES PERSONA(DNI)
);

CREATE TABLE VENDEDOR
(
  cod_vendedor INT NOT NULL,
  fecha_ingreso DATE NOT NULL,
  DNI_vendedor INT NOT NULL,
  PRIMARY KEY (DNI_vendedor),
  FOREIGN KEY (DNI_vendedor) REFERENCES PERSONA(DNI),
  UNIQUE (cod_vendedor)
);

CREATE TABLE MED_DE_PAGO
(
  cod_pago INT NOT NULL,
  detalle VARCHAR(20) CHECK (detalle IN ('Efectivo',' Transferencia', 'Débito', 'Crédito')) NOT NULL,
  PRIMARY KEY (cod_pago)
);

CREATE TABLE VENTAS
(
  numero_com INT NOT NULL,
  fecha DATETIME NOT NULL DEFAULT GETDATE(),
  cant_cuotas INT CHECK (cant_cuotas IN (1,2,3)) NOT NULL,
  cod_pago INT NOT NULL,
  DNI_cliente INT NOT NULL,
  DNI_vendedor INT NOT NULL,
  PRIMARY KEY (numero_com),
  FOREIGN KEY (cod_pago) REFERENCES MED_DE_PAGO(cod_pago),
  FOREIGN KEY (DNI_cliente) REFERENCES CLIENTE(),
  FOREIGN KEY (DNI_vendedor) REFERENCES VENDEDOR()
);

CREATE TABLE CATEGORIA
(
  descripcion VARCHAR(100) NOT NULL,
  cod_categoria INT IDENTIFY(1,1) NOT NULL,
  PRIMARY KEY (cod_categoria)
);

CREATE TABLE PRODUCTO
(
  precio_actual DECIMAL(10,2) NOT NULL,
  cod_producto INT IDENTIFY(1,1) NOT NULL,
  cant_disponible INT NOT NULL,
  cod_categoria INT NOT NULL,
  PRIMARY KEY (cod_producto),
  FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA(cod_categoria)
);

CREATE TABLE PROVEEDOR
(
  CUIT INT NOT NULL,
  razon_social VARCHAR(50) NOT NULL,
  Direccion VARCHAR(50) NOT NULL,
  telefono INT NOT NULL,
  PRIMARY KEY (CUIT)
);

CREATE TABLE DETALLE_VENTA
(
  precio_unit DECIMA(10,2) NOT NULL,
  cantidad INT NOT NULL,
  cod_producto INT NOT NULL,
  numero_com INT NOT NULL,
  PRIMARY KEY (cod_producto, numero_com),
  FOREIGN KEY (cod_producto) REFERENCES PRODUCTO(cod_producto),
  FOREIGN KEY (numero_com) REFERENCES VENTAS(numero_com)
);

CREATE TABLE PROVEEDOR_PRODUCTO
(
  CUIT INT NOT NULL,
  cod_producto INT NOT NULL,
  FOREIGN KEY (CUIT) REFERENCES PROVEEDOR(CUIT),
  FOREIGN KEY (cod_producto) REFERENCES PRODUCTO(cod_producto)
);
