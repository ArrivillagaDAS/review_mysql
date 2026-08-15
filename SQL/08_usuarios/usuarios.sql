-- usuarios

-- usuario 1
DROP USER IF EXISTS 'recepcion_gym'@'localhost';
CREATE USER 'recepcion_gym'@'localhost' IDENTIFIED BY 'Recepcion#2026';


-- usuario 2
GRANT SELECT, INSERT, UPDATE
    ON gimnasio_valle.Socios
    TO 'recepcion_gym'@'localhost';

GRANT SELECT, INSERT
    ON gimnasio_valle.Socio_Plan_Entrenamiento
    TO 'recepcion_gym'@'localhost';

GRANT SELECT
    ON gimnasio_valle.Entrenadores
    TO 'recepcion_gym'@'localhost';

GRANT SELECT
    ON gimnasio_valle.Sedes
    TO 'recepcion_gym'@'localhost';

FLUSH PRIVILEGES;


-- usuario 3
SHOW GRANTS FOR 'recepcion_gym'@'localhost';


-- usuario 4
DROP USER IF EXISTS 'admin_gym'@'localhost';
CREATE USER 'admin_gym'@'localhost' IDENTIFIED BY 'AdminGym#2026';

GRANT ALL PRIVILEGES
    ON gimnasio_valle.*
    TO 'admin_gym'@'localhost'
    WITH GRANT OPTION;

FLUSH PRIVILEGES;


-- usuario 5
DROP USER IF EXISTS 'auditor_gym'@'localhost';
CREATE USER 'auditor_gym'@'localhost' IDENTIFIED BY 'Auditor#2026';

GRANT SELECT
    ON gimnasio_valle.Reporte_Socios_Entrenador
    TO 'auditor_gym'@'localhost';

FLUSH PRIVILEGES;


-- usuario 6
GRANT SELECT (Nombres, Apellidos, Telefono)
    ON gimnasio_valle.Socios
    TO 'auditor_gym'@'localhost';

FLUSH PRIVILEGES;

-- verificacion
SHOW GRANTS FOR 'recepcion_gym'@'localhost';
SHOW GRANTS FOR 'admin_gym'@'localhost';
SHOW GRANTS FOR 'auditor_gym'@'localhost';
