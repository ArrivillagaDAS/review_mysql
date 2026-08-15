-- funciones
USE gimnasio_valle;


-- funcion 1
DROP FUNCTION IF EXISTS fn_nombre_completo_socio;
DELIMITER //
CREATE FUNCTION fn_nombre_completo_socio(p_socio_id INT)
RETURNS VARCHAR(101)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_nombre_completo VARCHAR(101);

    SELECT CONCAT(Nombres, ' ', Apellidos) INTO v_nombre_completo
    FROM Socios
    WHERE Socio_ID = p_socio_id;

    RETURN v_nombre_completo;
END//
DELIMITER ;

-- SELECT fn_nombre_completo_socio(101);


-- funcion 2
DROP FUNCTION IF EXISTS fn_calcular_comision_entrenador;
DELIMITER //
CREATE FUNCTION fn_calcular_comision_entrenador(p_entrenador_id VARCHAR(5))
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_cantidad_socios INT;
    DECLARE v_comision_por_socio DECIMAL(10,2) DEFAULT 50.00;
    DECLARE v_comision_total DECIMAL(10,2);

    SELECT COUNT(*) INTO v_cantidad_socios
    FROM Socio_Plan_Entrenamiento
    WHERE Entrenador_ID = p_entrenador_id;

    SET v_comision_total = v_cantidad_socios * v_comision_por_socio;

    RETURN v_comision_total;
END//
DELIMITER ;

-- SELECT Entrenador_ID, Nombre_entrenador, fn_calcular_comision_entrenador(Entrenador_ID) AS Comision
-- FROM Entrenadores;


-- funcion 3
DROP FUNCTION IF EXISTS fn_nivel_ocupacion_entrenador;
DELIMITER //
CREATE FUNCTION fn_nivel_ocupacion_entrenador(p_entrenador_id VARCHAR(5))
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_asignados INT;
    DECLARE v_cupo INT;
    DECLARE v_nivel VARCHAR(20);

    SELECT COUNT(*) INTO v_asignados
    FROM Socio_Plan_Entrenamiento
    WHERE Entrenador_ID = p_entrenador_id;

    SELECT Cupo_maximo INTO v_cupo
    FROM Entrenadores
    WHERE Entrenador_ID = p_entrenador_id;

    IF v_asignados = 0 THEN
        SET v_nivel = 'Disponible';
    ELSEIF v_asignados < v_cupo THEN
        SET v_nivel = 'Parcial';
    ELSE
        SET v_nivel = 'Lleno';
    END IF;

    RETURN v_nivel;
END//
DELIMITER ;

-- SELECT Entrenador_ID, fn_nivel_ocupacion_entrenador(Entrenador_ID) FROM Entrenadores;


-- funcion 4
DROP FUNCTION IF EXISTS fn_total_comisiones_gimnasio;
DELIMITER //
CREATE FUNCTION fn_total_comisiones_gimnasio()
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_contador INT DEFAULT 0;
    DECLARE v_cantidad_entrenadores INT;
    DECLARE v_entrenador_id VARCHAR(5);

    SELECT COUNT(*) INTO v_cantidad_entrenadores FROM Entrenadores;

    WHILE v_contador < v_cantidad_entrenadores DO
        SELECT Entrenador_ID INTO v_entrenador_id
        FROM Entrenadores
        LIMIT 1 OFFSET v_contador;

        SET v_total = v_total + fn_calcular_comision_entrenador(v_entrenador_id);
        SET v_contador = v_contador + 1;
    END WHILE;

    RETURN v_total;
END//
DELIMITER ;

-- SELECT fn_total_comisiones_gimnasio() AS Total_comisiones_gimnasio;


-- funcion 5
DROP FUNCTION IF EXISTS fn_sede_principal_socio;
DELIMITER //
CREATE FUNCTION fn_sede_principal_socio(p_socio_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_sede VARCHAR(50);

    SELECT sd.Gimnasio_Sede INTO v_sede
    FROM Socio_Plan_Entrenamiento spe
    INNER JOIN Sedes sd ON sd.Sede_ID = spe.Sede_ID
    WHERE spe.Socio_ID = p_socio_id
    ORDER BY spe.Inscripcion_ID
    LIMIT 1;

    RETURN v_sede;
END//
DELIMITER ;

-- SELECT fn_sede_principal_socio(103);


-- funcion 6
DROP FUNCTION IF EXISTS fn_marca_tiempo_consulta;
DELIMITER //
CREATE FUNCTION fn_marca_tiempo_consulta(p_socio_id INT)
RETURNS VARCHAR(150)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_nombre VARCHAR(101);

    SET v_nombre = fn_nombre_completo_socio(p_socio_id);

    RETURN CONCAT('Consulta de ', v_nombre, ' realizada el ', NOW());
END//
DELIMITER ;

-- SELECT fn_marca_tiempo_consulta(101);


-- funcion 7
DROP FUNCTION IF EXISTS fn_comision_segura;
DELIMITER //
CREATE FUNCTION fn_comision_segura(p_entrenador_id VARCHAR(5))
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_existe = 0;

    SELECT 1 INTO v_existe
    FROM Entrenadores
    WHERE Entrenador_ID = p_entrenador_id
    LIMIT 1;

    IF v_existe = 0 THEN
        RETURN -1;
    ELSE
        RETURN fn_calcular_comision_entrenador(p_entrenador_id);
    END IF;
END//
DELIMITER ;

-- SELECT fn_comision_segura('E02');
-- SELECT fn_comision_segura('E99');
