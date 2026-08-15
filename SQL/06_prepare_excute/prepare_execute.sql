-- prepare execute
USE gimnasio_valle;


-- bloque 1
SET sede_buscada = 'S01';

PREPARE consulta_socios_por_sede FROM
    'SELECT DISTINCT s.Socio_ID, s.Nombres, s.Apellidos
     FROM Socios s
     INNER JOIN Socio_Plan_Entrenamiento spe ON spe.Socio_ID = s.Socio_ID
     WHERE spe.Sede_ID = ?';

EXECUTE consulta_socios_por_sede USING sede_buscada;

DEALLOCATE PREPARE consulta_socios_por_sede;


-- bloque 2
DROP PROCEDURE IF EXISTS sp_ver_tabla_dinamico;
DELIMITER //
CREATE PROCEDURE sp_ver_tabla_dinamico(IN p_nombre_tabla VARCHAR(64))
BEGIN
    SET sql_texto = CONCAT('SELECT * FROM ', p_nombre_tabla, ' LIMIT 10');

    PREPARE stmt_dinamico FROM sql_texto;
    EXECUTE stmt_dinamico;
    DEALLOCATE PREPARE stmt_dinamico;
END//
DELIMITER ;

-- CALL sp_ver_tabla_dinamico('Entrenadores');
-- CALL sp_ver_tabla_dinamico('Sedes');
