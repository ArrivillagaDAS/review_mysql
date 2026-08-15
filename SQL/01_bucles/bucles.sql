-- bucles
USE gimnasio_valle;


-- procedimiento 1
DROP PROCEDURE IF EXISTS sp_contar_entrenadores_while;
DELIMITER //
CREATE PROCEDURE sp_contar_entrenadores_while()
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total FROM Entrenadores;

    WHILE v_contador <= v_total DO
        SELECT CONCAT('Entrenador numero ', v_contador, ' de ', v_total) AS Progreso;
        SET v_contador = v_contador + 1;
    END WHILE;
END//
DELIMITER ;

-- CALL sp_contar_entrenadores_while();


-- procedimiento 2
DROP PROCEDURE IF EXISTS sp_listar_socios_repeat;
DELIMITER //
CREATE PROCEDURE sp_listar_socios_repeat()
BEGIN
    DECLARE v_id INT DEFAULT 101;
    DECLARE v_max INT;
    DECLARE v_nombre_completo VARCHAR(100);

    SELECT MAX(Socio_ID) INTO v_max FROM Socios;

    REPEAT
        IF EXISTS (SELECT 1 FROM Socios WHERE Socio_ID = v_id) THEN
            SELECT CONCAT(Nombres, ' ', Apellidos) INTO v_nombre_completo
            FROM Socios WHERE Socio_ID = v_id;
            SELECT v_id AS Socio_ID, v_nombre_completo AS Nombre_completo;
        END IF;
        SET v_id = v_id + 1;
    UNTIL v_id > v_max
    END REPEAT;
END//
DELIMITER ;

-- CALL sp_listar_socios_repeat();


-- procedimiento 3
DROP PROCEDURE IF EXISTS sp_clasificar_socios_case;
DELIMITER //
CREATE PROCEDURE sp_clasificar_socios_case()
BEGIN
    SELECT
        s.Socio_ID,
        CONCAT(s.Nombres, ' ', s.Apellidos) AS Socio,
        COUNT(spe.Inscripcion_ID) AS Cantidad_planes,
        CASE
            WHEN COUNT(spe.Inscripcion_ID) = 0 THEN 'Sin plan asignado'
            WHEN COUNT(spe.Inscripcion_ID) = 1 THEN 'Socio basico'
            WHEN COUNT(spe.Inscripcion_ID) = 2 THEN 'Socio activo'
            ELSE 'Socio premium'
        END AS Categoria
    FROM Socios s
    LEFT JOIN Socio_Plan_Entrenamiento spe ON spe.Socio_ID = s.Socio_ID
    GROUP BY s.Socio_ID, s.Nombres, s.Apellidos;
END//
DELIMITER ;

-- CALL sp_clasificar_socios_case();


-- procedimiento 4
DROP PROCEDURE IF EXISTS sp_insertar_socio_seguro;
DELIMITER //
CREATE PROCEDURE sp_insertar_socio_seguro(
    IN p_socio_id INT,
    IN p_nombres VARCHAR(50),
    IN p_apellidos VARCHAR(50),
    IN p_telefono VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT CONCAT('Error: ya existe un socio con Socio_ID = ', p_socio_id) AS Mensaje;
    END;

    INSERT INTO Socios (Socio_ID, Nombres, Apellidos, Telefono)
    VALUES (p_socio_id, p_nombres, p_apellidos, p_telefono);

    SELECT CONCAT('Socio ', p_nombres, ' insertado correctamente') AS Mensaje;
END//
DELIMITER ;

-- CALL sp_insertar_socio_seguro(101, 'Ana', 'Perez', '555-1234'); -- deberia fallar controlado
-- CALL sp_insertar_socio_seguro(104, 'Mario', 'Lopez', '555-3333'); -- deberia insertar


-- procedimiento 5
DROP PROCEDURE IF EXISTS sp_inscribir_socio_transaccion;
DELIMITER //
CREATE PROCEDURE sp_inscribir_socio_transaccion(
    IN p_inscripcion_id INT,
    IN p_socio_id INT,
    IN p_plan_id VARCHAR(5),
    IN p_entrenador_id VARCHAR(5),
    IN p_sede_id VARCHAR(5)
)
BEGIN
    DECLARE v_error INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_error = 1;
        ROLLBACK;
        SELECT 'Error: la transaccion se revirtio (ROLLBACK)' AS Mensaje;
    END;

    START TRANSACTION;

        INSERT INTO Socio_Plan_Entrenamiento
            (Inscripcion_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID)
        VALUES
            (p_inscripcion_id, p_socio_id, p_plan_id, p_entrenador_id, p_sede_id);

    IF v_error = 0 THEN
        COMMIT;
        SELECT 'Inscripcion registrada correctamente (COMMIT)' AS Mensaje;
    END IF;
END//
DELIMITER ;

-- CALL sp_inscribir_socio_transaccion(1006, 102, 'PE01', 'E01', 'S01'); -- caso valido
-- CALL sp_inscribir_socio_transaccion(1007, 999, 'PE01', 'E01', 'S01'); -- socio 999 no existe -> ROLLBACK
