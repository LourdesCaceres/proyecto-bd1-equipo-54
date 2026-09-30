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
  email VARCHAR(100) NOT NULL UNIQUE,
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
  cod_pago INT IDENTITY(1,1) NOT NULL,
  detalle VARCHAR(20) CHECK (detalle IN ('Efectivo',' Transferencia', 'Débito', 'Crédito')) NOT NULL,
  CONSTRAINT PK_medPago PRIMARY KEY (cod_pago)
);

CREATE TABLE VENTAS (
  numero_com INT NOT NULL,
  fecha DATETIME NOT NULL DEFAULT GETDATE(),
  cant_cuotas INT CHECK (cant_cuotas IN (1,2,3)) NOT NULL,
  cod_pago INT NOT NULL,
  DNI_cliente INT NOT NULL,
  DNI_vendedor INT NOT NULL,
  CONSTRAINT PK_Ventas PRIMARY KEY (numero_com),
  CONSTRAINT FK_Ventas_MedDePago FOREIGN KEY (cod_pago) REFERENCES MED_DE_PAGO(cod_pago),
  CONSTRAINT FK_Ventas_Cliente FOREIGN KEY (DNI_cliente) REFERENCES CLIENTE(),
  CONSTRAINT FK_Ventas_Vendedor FOREIGN KEY (DNI_vendedor) REFERENCES VENDEDOR()
);

CREATE TABLE CATEGORIA (
  cod_categoria INT IDENTIFY(1,1) NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  CONSTRAINT PK_Categoria PRIMARY KEY (cod_categoria)
);

CREATE TABLE PRODUCTO (
  cod_producto INT IDENTIFY(1,1) NOT NULL,
  precio_actual DECIMAL(10,2) NOT NULL,
  cant_disponible INT NOT NULL,
  cod_categoria INT NOT NULL,
  CONSTRAINT PK_Producto PRIMARY KEY (cod_producto),
  CONSTRAINT FK_Producto_Categoria FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA(cod_categoria)
);

CREATE TABLE PROVEEDOR (
  CUIT INT NOT NULL,
  razon_social VARCHAR(50) NOT NULL UNIQUE,
  Direccion VARCHAR(50) NOT NULL,
  telefono INT NOT NULL,
  CONSTRAINT PK_Proveedor PRIMARY KEY (CUIT)
);

CREATE TABLE DETALLE_VENTA (
  precio_unit DECIMAL(10,2) NOT NULL,
  cantidad INT NOT NULL,
  cod_producto INT NOT NULL,
  numero_com INT NOT NULL,
  CONSTRAINT PK_DetalleVenta PRIMARY KEY (cod_producto, numero_com),
  CONSTRAINT FK_DetalleVenta_Ventas FOREIGN KEY (cod_producto) REFERENCES PRODUCTO(cod_producto),
  FOREIGN KEY (numero_com) REFERENCES VENTAS(numero_com)
);

CREATE TABLE PROVEEDOR_PRODUCTO (
  CUIT INT NOT NULL,
  cod_producto INT NOT NULL,
  CONSTRAINT PK_ProveedorProducto PRIMARY KEY (CUIT, cod_producto),
  CONSTRAINT FK_ProveedorProducto_Proveedor FOREIGN KEY (CUIT) REFERENCES PROVEEDOR(CUIT),
  CONSTRAINT FK_ProveedorProducto_Producto FOREIGN KEY (cod_producto) REFERENCES PRODUCTO(cod_producto)
);
