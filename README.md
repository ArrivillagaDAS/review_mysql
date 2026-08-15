# Gimnasio Valle — Proyecto de Base de Datos MySQL

Proyecto de práctica en MySQL que modela la gestión de un gimnasio con múltiples sedes, entrenadores, especialidades, planes de entrenamiento y socios. Cubre desde el diseño del esquema relacional hasta procedimientos almacenados, funciones, triggers, eventos, particionamiento, SQL dinámico y administración de usuarios.

## Proceso de normalización

A continuación se muestra el proceso de normalización de los datos originales (hoja de Excel/Google Sheets) hasta llegar al modelo relacional final en 4FN.

### Datos originales (sin normalizar)

![alt text](image.png)

### Primera forma normal (1FN)

Eliminación de grupos repetidos y valores no atómicos.

![alt text](image-1.png)

### Segunda forma normal (2FN)

Eliminación de dependencias parciales respecto a la llave primaria.

![alt text](image-2.png)

### Tercera forma normal (3FN)

Eliminación de dependencias transitivas.

![alt text](image-3.png)

### Cuarta forma normal (4FN)

Eliminación de dependencias multivaluadas independientes. Este es el modelo final que se implementó en `00_schema.sql`.

![alt text](image-4.png)


## Contenido

| Archivo | Descripción |
|---|---|
| `00_schema.sql` | Creación de la base de datos, tablas base y carga de datos iniciales. |
| `01_bucles.sql` | Estructuras de control iterativo (`WHILE`, `REPEAT`), uso de `CASE` y manejo de errores. |
| `02_consultas_avanzadas.sql` | Consultas con `IN`, `INNER JOIN`, procedimientos con parámetros `OUT`/`INOUT`, inserciones combinadas, `IF...THEN...ELSE` y `LOOP` con cursores. |
| `03_eventos_triggers.sql` | Evento programado para generar reportes diarios y trigger de validación antes de insertar inscripciones. |
| `04_funciones.sql` | Funciones definidas por el usuario: deterministas, no deterministas, con condiciones, bucles y manejo de errores. |
| `05_particion.sql` | Particionamiento de tablas por lista (`PARTITION BY LIST COLUMNS`). |
| `06_prepare_execute.sql` | SQL dinámico con `PREPARE`, `EXECUTE` y `DEALLOCATE`. |
| `07_consultas_innecesarias.sql` | Comparación entre consultas con pasos redundantes y sus versiones optimizadas. |
| `08_usuarios.sql` | Creación de usuarios y asignación de privilegios a nivel de base de datos, tabla y columna. |

## Requisitos

- MySQL 8.0+
- Cliente de línea de comandos (`mysql`) o una herramienta como MySQL Workbench, DBeaver o similar
- Privilegios de administrador para ejecutar `08_usuarios.sql` (creación de usuarios y `GRANT`)


## Modelo de datos

El esquema sigue el siguiente diseño relacional (normalizado en 4FN):

```
Ciudades ──< Sedes
Especialidades ──< Entrenadores
Planes_entrenamiento
Socios

Socio_Plan_Entrenamiento (tabla puente)
  → Socios
  → Planes_entrenamiento
  → Entrenadores
  → Sedes
```

La tabla `Socio_Plan_Entrenamiento` centraliza la relación entre un socio, el plan al que se inscribe, el entrenador asignado y la sede donde entrena.

## Orden de ejecución

Los archivos están numerados y deben ejecutarse en ese orden, ya que cada uno depende de la estructura y los datos creados por el anterior:

```bash
mysql -u root -p < 00_schema.sql
mysql -u root -p < 01_bucles.sql
mysql -u root -p < 02_consultas_avanzadas.sql
mysql -u root -p < 03_eventos_triggers.sql
mysql -u root -p < 04_funciones.sql
mysql -u root -p < 05_particion.sql
mysql -u root -p < 06_prepare_execute.sql
mysql -u root -p < 07_consultas_innecesarias.sql
mysql -u root -p < 08_usuarios.sql
```

También pueden ejecutarse de forma interactiva copiando el contenido de cada archivo dentro de un cliente SQL, respetando el mismo orden.

## Notas técnicas

- **Particionamiento** (`05_particion.sql`): MySQL/MariaDB no permite particionar tablas que tengan llaves foráneas. Por ello, este archivo crea una copia de `Socio_Plan_Entrenamiento` sin `FOREIGN KEY`, exclusivamente para ilustrar el particionamiento por lista según la sede.
- **Eventos** (`03_eventos_triggers.sql`): requiere que el `event_scheduler` de MySQL esté activo (`SET GLOBAL event_scheduler = ON;`), lo cual se incluye al inicio del script.
- **Usuarios** (`08_usuarios.sql`): debe ejecutarse con una cuenta que tenga privilegios administrativos (por ejemplo, `root`).

## Convenciones del código

- Los procedimientos y funciones se eliminan con `DROP ... IF EXISTS` antes de crearse, para permitir la re-ejecución de los scripts sin errores.
- Las llamadas de prueba (`CALL`, `SELECT`, `INSERT`) quedan comentadas al final de cada bloque, listas para descomentar y probar.
- Los comentarios del código son deliberadamente breves y sirven como separadores entre bloques lógicos, no como documentación extensa.
