-- consultas avanzadas
USE gimnasio_valle;


-- bloque 1
SELECT DISTINCT s.Socio_ID, s.Nombres, s.Apellidos
FROM Socios s
INNER JOIN Socio_Plan_Entrenamiento spe ON spe.Socio_ID = s.Socio_ID
INNER JOIN Planes_entrenamiento pe ON pe.Plan_Entrenamiento_ID = spe.Plan_Entrenamiento_ID
WHERE pe.Nombre_plan IN ('Yoga', 'Boxeo');


-- bloque 2
SELECT
    spe.Inscripcion_ID,
    CONCAT(s.Nombres, ' ', s.Apellidos) AS Socio,
    pe.Nombre_plan               AS Plan,
    en.Nombre_entrenador         AS Entrenador,
    sd.Gimnasio_Sede             AS Sede,
    c.Nombre_Ciudad              AS Ciudad
FROM Socio_Plan_Entrenamiento spe
INNER JOIN Socios s               ON s.Socio_ID = spe.Socio_ID
INNER JOIN Planes_entrenamiento pe ON pe.Plan_Entrenamiento_ID = spe.Plan_Entrenamiento_ID
INNER JOIN Entrenadores en        ON en.Entrenador_ID = spe.Entrenador_ID
INNER JOIN Sedes sd               ON sd.Sede_ID = spe.Sede_ID
INNER JOIN Ciudades c             ON c.Ciudad_ID = sd.Ciudad_ID;


-- bloque 3
DROP PROCEDURE IF EXISTS sp_socios_por_entrenador_out;
DELIMITER //
CREATE PROCEDURE sp_socios_por_entrenador_out(
    IN  p_entrenador_id VARCHAR(5),
    OUT p_cantidad_socios INT
)
BEGIN
    SELECT COUNT(DISTINCT Socio_ID) INTO p_cantidad_socios
    FROM Socio_Plan_Entrenamiento
    WHERE Entrenador_ID = p_entrenador_id;
END//
DELIMITER ;

-- CALL sp_socios_por_entrenador_out('E02', cant);
-- SELECT cant AS Socios_de_Marta;


-- bloque 4
DROP PROCEDURE IF EXISTS sp_contar_inscripciones_inout;
DELIMITER //
CREATE PROCEDURE sp_contar_inscripciones_inout(
    IN    p_socio_id INT,
    INOUT p_contador INT
)
BEGIN
    DECLARE v_inscripciones INT;

    SELECT COUNT(*) INTO v_inscripciones
    FROM Socio_Plan_Entrenamiento
    WHERE Socio_ID = p_socio_id;

    SET p_contador = p_contador + v_inscripciones;
END//
DELIMITER ;

-- SET total = 0;
-- CALL sp_contar_inscripciones_inout(101, total);
-- CALL sp_contar_inscripciones_inout(103, total);
-- SELECT total AS Total_acumulado;


-- bloque 5
DROP PROCEDURE IF EXISTS sp_alta_socio_con_plan;
DELIMITER //
CREATE PROCEDURE sp_alta_socio_con_plan(
    IN p_socio_id INT,
    IN p_nombres VARCHAR(50),
    IN p_apellidos VARCHAR(50),
    IN p_telefono VARCHAR(20),
    IN p_inscripcion_id INT,
    IN p_plan_id VARCHAR(5),
    IN p_entrenador_id VARCHAR(5),
    IN p_sede_id VARCHAR(5)
)
BEGIN
    INSERT INTO Socios (Socio_ID, Nombres, Apellidos, Telefono)
    VALUES (p_socio_id, p_nombres, p_apellidos, p_telefono);

    INSERT INTO Socio_Plan_Entrenamiento
        (Inscripcion_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID)
    VALUES
        (p_inscripcion_id, p_socio_id, p_plan_id, p_entrenador_id, p_sede_id);

    SELECT CONCAT('Socio ', p_nombres, ' dado de alta e inscrito en el plan ', p_plan_id) AS Mensaje;
END//
DELIMITER ;

-- CALL sp_alta_socio_con_plan(105, 'Sofia', 'Ramirez', '555-7777', 1008, 'PE03', 'E03', 'S02');


-- bloque 6
DROP PROCEDURE IF EXISTS sp_verificar_cupo_entrenador;
DELIMITER //
CREATE PROCEDURE sp_verificar_cupo_entrenador(IN p_entrenador_id VARCHAR(5))
BEGIN
    DECLARE v_asignados INT;
    DECLARE v_cupo INT;

    SELECT COUNT(*) INTO v_asignados
    FROM Socio_Plan_Entrenamiento
    WHERE Entrenador_ID = p_entrenador_id;

    SELECT Cupo_maximo INTO v_cupo
    FROM Entrenadores
    WHERE Entrenador_ID = p_entrenador_id;

    IF v_asignados >= v_cupo THEN
        SELECT CONCAT('El entrenador ', p_entrenador_id, ' esta lleno (', v_asignados, '/', v_cupo, ')') AS Estado;
    ELSE
        SELECT CONCAT('El entrenador ', p_entrenador_id, ' tiene cupo (', v_asignados, '/', v_cupo, ')') AS Estado;
    END IF;
END//
DELIMITER ;

-- CALL sp_verificar_cupo_entrenador('E02');


-- bloque 7
DROP PROCEDURE IF EXISTS sp_reporte_entrenadores_loop;
DELIMITER //
CREATE PROCEDURE sp_reporte_entrenadores_loop()
BEGIN
    DECLARE v_fin INT DEFAULT 0;
    DECLARE v_entrenador_id VARCHAR(5);
    DECLARE v_nombre VARCHAR(50);
    DECLARE v_cantidad INT;

    DECLARE cur_entrenadores CURSOR FOR
        SELECT Entrenador_ID, Nombre_entrenador FROM Entrenadores;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = 1;

    OPEN cur_entrenadores;

    mi_loop: LOOP
        FETCH cur_entrenadores INTO v_entrenador_id, v_nombre;

        IF v_fin = 1 THEN
            LEAVE mi_loop;
        END IF;

        SELECT COUNT(*) INTO v_cantidad
        FROM Socio_Plan_Entrenamiento
        WHERE Entrenador_ID = v_entrenador_id;

        SELECT v_entrenador_id AS Entrenador_ID, v_nombre AS Nombre, v_cantidad AS Socios_asignados;
    END LOOP;

    CLOSE cur_entrenadores;
END//
DELIMITER ;

-- CALL sp_reporte_entrenadores_loop();
