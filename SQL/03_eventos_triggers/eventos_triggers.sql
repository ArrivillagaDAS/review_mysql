-- eventos y triggers
USE gimnasio_valle;

SET GLOBAL event_scheduler = ON;

-- tabla 1
DROP TABLE IF EXISTS Reporte_Socios_Entrenador;
CREATE TABLE Reporte_Socios_Entrenador (
    Reporte_ID       INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_reporte     DATE,
    Entrenador_ID     VARCHAR(5),
    Nombre_entrenador VARCHAR(50),
    Cantidad_socios   INT
);

-- bloque 1
DROP EVENT IF EXISTS ev_reporte_diario_socios_entrenador;
DELIMITER //
CREATE EVENT ev_reporte_diario_socios_entrenador
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO Reporte_Socios_Entrenador (Fecha_reporte, Entrenador_ID, Nombre_entrenador, Cantidad_socios)
    SELECT
        CURDATE(),
        en.Entrenador_ID,
        en.Nombre_entrenador,
        COUNT(spe.Inscripcion_ID)
    FROM Entrenadores en
    LEFT JOIN Socio_Plan_Entrenamiento spe ON spe.Entrenador_ID = en.Entrenador_ID
    GROUP BY en.Entrenador_ID, en.Nombre_entrenador;
END//
DELIMITER ;

-- bloque 2
DROP PROCEDURE IF EXISTS sp_generar_reporte_diario;
DELIMITER //
CREATE PROCEDURE sp_generar_reporte_diario()
BEGIN
    INSERT INTO Reporte_Socios_Entrenador (Fecha_reporte, Entrenador_ID, Nombre_entrenador, Cantidad_socios)
    SELECT
        CURDATE(),
        en.Entrenador_ID,
        en.Nombre_entrenador,
        COUNT(spe.Inscripcion_ID)
    FROM Entrenadores en
    LEFT JOIN Socio_Plan_Entrenamiento spe ON spe.Entrenador_ID = en.Entrenador_ID
    GROUP BY en.Entrenador_ID, en.Nombre_entrenador;
END//
DELIMITER ;

-- CALL sp_generar_reporte_diario();
-- SELECT * FROM Reporte_Socios_Entrenador;


-- bloque 3
DROP TRIGGER IF EXISTS trg_verificar_disponibilidad_entrenador;
DELIMITER //
CREATE TRIGGER trg_verificar_disponibilidad_entrenador
BEFORE INSERT ON Socio_Plan_Entrenamiento
FOR EACH ROW
BEGIN
    DECLARE v_asignados INT;
    DECLARE v_cupo INT;

    SELECT COUNT(*) INTO v_asignados
    FROM Socio_Plan_Entrenamiento
    WHERE Entrenador_ID = NEW.Entrenador_ID;

    SELECT Cupo_maximo INTO v_cupo
    FROM Entrenadores
    WHERE Entrenador_ID = NEW.Entrenador_ID;

    IF v_asignados >= v_cupo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El entrenador ya alcanzo su cupo maximo de socios';
    END IF;
END//
DELIMITER ;

-- prueba 1
-- INSERT INTO Socio_Plan_Entrenamiento (Inscripcion_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID)
-- VALUES (1009, 102, 'PE02', 'E02', 'S01');

-- prueba 2
-- INSERT INTO Socio_Plan_Entrenamiento (Inscripcion_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID)
-- VALUES (1010, 103, 'PE02', 'E02', 'S01');
