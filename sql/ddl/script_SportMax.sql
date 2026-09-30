--- Creación e Implementación Física de la Base de Datos "SistemaSportMax"

--- Creación e inicialización de la Base de Datos
CREATE DATABASE SistemaSportMax;
GO

USE SistemaSportMax;
GO

--- Creación de tablas
CREATE TABLE PERSONA (
  direccion VARCHAR(50) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  DNI INT NOT NULL,
  email VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  telefono INT NOT NULL,
  CONSTRAINT PK_Persona PRIMARY KEY (DNI)
);

CREATE TABLE CLIENTE (
  fecha_alta DATE NOT NULL,
  DNI_cliente INT NOT NULL,
  CONSTRAINT PK_Cliente PRIMARY KEY (DNI_cliente),
  CONSTRAINT FK_Cliente_Persona FOREIGN KEY (DNI_cliente) REFERENCES PERSONA(DNI)
);

CREATE TABLE VENDEDOR (
  cod_vendedor INT NOT NULL UNIQUE,
  fecha_ingreso DATE NOT NULL,
  DNI_vendedor INT NOT NULL,
  CONSTRAINT PK_Vendedor PRIMARY KEY (DNI_vendedor),
  CONSTRAINT FK_Vendedor_Persona FOREIGN KEY (DNI_vendedor) REFERENCES PERSONA(DNI),
);

CREATE TABLE MED_DE_PAGO (
  cod_pago INT NOT NULL,
  detalle ('Efectivo',' Transferencia', 'Débito', 'Crédito') NOT NULL,
  CONSTRAINT PK_medPago PRIMARY KEY (cod_pago)
);

CREATE TABLE VENTAS (
  numero_com INT NOT NULL,
  fecha DATE NOT NULL,
  cant_cuotas ('1', '2', '3') NOT NULL,
  cod_pago INT NOT NULL,
  DNI_cliente INT NOT NULL,
  DNI_vendedor INT NOT NULL,
  PRIMARY KEY (numero_com),
  FOREIGN KEY (cod_pago) REFERENCES MED_DE_PAGO(cod_pago),
  FOREIGN KEY (DNI_cliente) REFERENCES CLIENTE(),
  FOREIGN KEY (DNI_vendedor) REFERENCES VENDEDOR()
);

CREATE TABLE CATEGORIA (
  descripcion VARCHAR(100) NOT NULL,
  cod_categoria INT NOT NULL,
  PRIMARY KEY (cod_categoria)
);

CREATE TABLE PRODUCTO (
  precio_actual INT NOT NULL,
  cod_producto INT NOT NULL,
  cant_disponible INT NOT NULL,
  cod_categoria INT NOT NULL,
  PRIMARY KEY (cod_producto),
  FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA(cod_categoria)
);

CREATE TABLE PROVEEDOR (
  CUIT INT NOT NULL,
  razon_social VARCHAR(50) NOT NULL,
  Direccion VARCHAR(50) NOT NULL,
  telefono INT NOT NULL,
  PRIMARY KEY (CUIT)
);

CREATE TABLE DETALLE_VENTA (
  precio_unit INT NOT NULL,
  cantidad INT NOT NULL,
  cod_producto INT NOT NULL,
  numero_com INT NOT NULL,
  PRIMARY KEY (cod_producto, numero_com),
  FOREIGN KEY (cod_producto) REFERENCES PRODUCTO(cod_producto),
  FOREIGN KEY (numero_com) REFERENCES VENTAS(numero_com)
);

CREATE TABLE PROVEEDOR_PRODUCTO (
  CUIT INT NOT NULL,
  cod_producto INT NOT NULL,
  CONSTRAINT PK_ProveedorProducto PRIMARY KEY (CUIT, cod_producto),
  CONSTRAINT FK_ProveedorProducto_Proveedor FOREIGN KEY (CUIT) REFERENCES PROVEEDOR(CUIT),
  CONSTRAINT FK_ProveedorProducto_Producto FOREIGN KEY (cod_producto) REFERENCES PRODUCTO(cod_producto)
);
