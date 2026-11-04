# proyecto-bd1-equipo-54

Este repositorio contiene el desarrollo completo y progresivo del proyecto de estudio para la asignatura *Base de Datos I*. El objetivo principal es diseñar, normalizar e implementar una base de datos relacional desde cero, documentando cada fase del ciclo de vida del desarrollo.
El desarrollo fue realizado utilizando herramientas como ERDPlus y SQL Server. La modalidad fue a través de división de tareas e incorporación de *issues* y tareas dentro del entorno del repositorio. Conforme avanzan las clases vamos incorporando y actualizando nuevos conceptos así como arreglando reglas de negocio o restricciones, con esta constante evolución el proyecto pasa a ser uno vivo y en constante modificación.

## Descripción de la Base de Datos

<img width="1672" height="941" alt="Tienda deportiva SportMax moderna" src="https://github.com/user-attachments/assets/96799c89-eca5-4057-8157-5a3d97c40842" />


Para la elaboración de este proyecto, como grupo definimos la situación de una supuesta tienda de ropa y accesorios deportivos llamada *SportMax*. La base se centra en el flujo de compra-venta de productos deportivos como ropa, accesorios y equipo, en el cuál participan personas registradas y con roles como clientes y vendedores.
Mediante la implementación de tablas, relaciones y cardinalidades definidas en las primeras etapas del proyecto, incorporamos conceptos de la cátedra como el modelado de datos, supertipos y subtipos, claves primarias y secundarias. Con estos conceptos abstraemos y definimos los datos reales en la forma de una base de datos que puede gestionar y modificar datos como stock de productos, precios y su aumento/decrecimiento, alta y baja de personas, registro de ventas e impresión de mensajes.

## Estructura del Repositorio
``` text
proyecto-bd1-equipo-54/
├── docs/
│   ├── etapa-1/
│   │   ├── alcance.md
│   │   ├── decisiones-diseno.md
│   │   ├── descripcion-caso.md
│   │   └── reglas-negocio.md
│   ├── etapa-2/
│   │   ├── Modelo_relacional.md
│   │   ├── decisiones-diseno.md
│   │   ├── der-SportMax.md
│   │   └── normalizacion.md
│   ├── etapa-3/
│   │   ├── implementacion.md
│   │   ├── pruebas-validacion.md
│   │   └── restricciones-integridad.md
│   └── etapa-4/
│       ├── casos-uso.md
│       ├── comprobante-venta.md
│       ├── consulta-avanzada.md
│       └── informe-ventas.md
├── etapa_v/
│   ├── Procedimientos_y_funciones/
│   │   ├── implementacion/
│   │   │   ├── Pruebas.sql
│   │   │   └── insertarDatos.sql
│   │   ├── funciones.sql
│   │   ├── implementacion.sql
│   │   └── procedimientos.sql
│   ├── seguridad/
│   │   ├── evidencias/
│   │   |   └── casos-prueba-seguridad.sql
│   │   ├── investigacion.md
│   │   └── script-seguridad.sql
│   ├── transacciones/
│   │   ├── evidencias/
│   │   │   ├── casos-de-prueba.sql
│   │   │   ├── casosDePrueba_TransaccionAnidada.sql
│   │   │   ├── resultados-transaccionSimple.md
│   │   │   └── resultados_TransaccionesAnidadas.md
│   │   ├── Investigacion.md
│   │   ├── ajustarPreciosCategoria.sql
│   │   ├── implementacion.md
│   │   └── registrarVentas.sql
│   ├── optimizacion/
│   └── trigger_auditoria/
│       ├── evidencias/
│       │   ├── casos_prueba.md
│       │   └── casos_prueba_trigger.sql
│       ├── implementacion.md
│       ├── investigacion.md
│       └── trigger_auditoria.sql
├── sql/
│   ├── consultas/
│   │   ├── comprobante_venta.sql
│   │   ├── consulta_avanzadaPROMEDIO_GASTOS.sql
│   │   └── informe_ventas.sql
│   ├── ddl/
│   │   └── script_SportMax.sql
│   └── dml/
│       ├── poblado_datos_etapa4_DML.sql
│       └── script_SportMax_DML.sql
└── README.md
```
