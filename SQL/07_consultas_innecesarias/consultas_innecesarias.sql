-- consultas innecesarias
USE gimnasio_valle;


-- ejemplo 1
-- version 1
SELECT Nombres, Apellidos
FROM Socios
WHERE Socio_ID IN (
    SELECT Socio_ID FROM (
        SELECT DISTINCT Socio_ID FROM Socio_Plan_Entrenamiento
    ) AS sub
);

-- version 2
SELECT DISTINCT s.Nombres, s.Apellidos
FROM Socios s
INNER JOIN Socio_Plan_Entrenamiento spe ON spe.Socio_ID = s.Socio_ID;


-- ejemplo 2
-- version 1
SELECT DISTINCT s.Socio_ID, COUNT(spe.Inscripcion_ID)
FROM Socios s
LEFT JOIN Socio_Plan_Entrenamiento spe ON spe.Socio_ID = s.Socio_ID
GROUP BY s.Socio_ID;

-- version 2
SELECT s.Socio_ID, COUNT(spe.Inscripcion_ID) AS Cantidad_planes
FROM Socios s
LEFT JOIN Socio_Plan_Entrenamiento spe ON spe.Socio_ID = s.Socio_ID
GROUP BY s.Socio_ID;


-- ejemplo 3
-- version 1
SELECT en.Nombre_entrenador, sd.Gimnasio_Sede
FROM Entrenadores en
INNER JOIN Socio_Plan_Entrenamiento spe ON spe.Entrenador_ID = en.Entrenador_ID
INNER JOIN Sedes sd ON sd.Sede_ID = spe.Sede_ID
INNER JOIN Ciudades c ON c.Ciudad_ID = sd.Ciudad_ID
GROUP BY en.Nombre_entrenador, sd.Gimnasio_Sede;

-- version 2
SELECT en.Nombre_entrenador, sd.Gimnasio_Sede
FROM Entrenadores en
INNER JOIN Socio_Plan_Entrenamiento spe ON spe.Entrenador_ID = en.Entrenador_ID
INNER JOIN Sedes sd ON sd.Sede_ID = spe.Sede_ID
GROUP BY en.Nombre_entrenador, sd.Gimnasio_Sede;
