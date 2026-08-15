-- particion
USE gimnasio_valle;

DROP TABLE IF EXISTS Socio_Plan_Entrenamiento_Particionada;

CREATE TABLE Socio_Plan_Entrenamiento_Particionada (
    Inscripcion_ID         INT NOT NULL,
    Socio_ID               INT,
    Plan_Entrenamiento_ID  VARCHAR(5),
    Entrenador_ID          VARCHAR(5),
    Sede_ID                VARCHAR(5) NOT NULL,
    Fecha_inscripcion      DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (Inscripcion_ID, Sede_ID)
)
PARTITION BY LIST COLUMNS (Sede_ID) (
    PARTITION p_sede_norte VALUES IN ('S01'),
    PARTITION p_sede_sur   VALUES IN ('S02')
);

-- bloque 1
INSERT INTO Socio_Plan_Entrenamiento_Particionada
    (Inscripcion_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID, Fecha_inscripcion)
SELECT Inscripcion_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID, Fecha_inscripcion
FROM Socio_Plan_Entrenamiento;

-- bloque 2
SELECT * FROM Socio_Plan_Entrenamiento_Particionada PARTITION (p_sede_norte);

-- bloque 3
SELECT
    PARTITION_NAME,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'gimnasio_valle'
  AND TABLE_NAME = 'Socio_Plan_Entrenamiento_Particionada';
