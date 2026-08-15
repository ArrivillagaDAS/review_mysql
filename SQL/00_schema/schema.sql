-- schema

DROP DATABASE IF EXISTS gimnasio_valle;
CREATE DATABASE gimnasio_valle;
USE gimnasio_valle;

-- tabla 1
CREATE TABLE Ciudades (
    Ciudad_ID     VARCHAR(5)  PRIMARY KEY,
    Nombre_Ciudad VARCHAR(50) NOT NULL
);

-- tabla 2
CREATE TABLE Sedes (
    Sede_ID       VARCHAR(5)  PRIMARY KEY,
    Gimnasio_Sede VARCHAR(50) NOT NULL,
    Ciudad_ID     VARCHAR(5),
    FOREIGN KEY (Ciudad_ID) REFERENCES Ciudades(Ciudad_ID)
);

-- tabla 3
CREATE TABLE Especialidades (
    Especialidad_ID     VARCHAR(5)  PRIMARY KEY,
    Nombre_especialidad VARCHAR(50) NOT NULL
);

-- tabla 4
CREATE TABLE Entrenadores (
    Entrenador_ID     VARCHAR(5)  PRIMARY KEY,
    Nombre_entrenador VARCHAR(50) NOT NULL,
    Especialidad_ID   VARCHAR(5),
    Cupo_maximo       INT DEFAULT 3 COMMENT 'maximo de socios que puede atender a la vez',
    FOREIGN KEY (Especialidad_ID) REFERENCES Especialidades(Especialidad_ID)
);

-- tabla 5
CREATE TABLE Planes_entrenamiento (
    Plan_Entrenamiento_ID VARCHAR(5)  PRIMARY KEY,
    Nombre_plan           VARCHAR(50) NOT NULL
);

-- tabla 6
CREATE TABLE Socios (
    Socio_ID  INT         PRIMARY KEY,
    Nombres   VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(50) NOT NULL,
    Telefono  VARCHAR(20)
);

-- tabla 7
CREATE TABLE Socio_Plan_Entrenamiento (
    Inscripcion_ID         INT PRIMARY KEY,
    Socio_ID               INT,
    Plan_Entrenamiento_ID  VARCHAR(5),
    Entrenador_ID          VARCHAR(5),
    Sede_ID                VARCHAR(5),
    Fecha_inscripcion      DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (Socio_ID) REFERENCES Socios(Socio_ID),
    FOREIGN KEY (Plan_Entrenamiento_ID) REFERENCES Planes_entrenamiento(Plan_Entrenamiento_ID),
    FOREIGN KEY (Entrenador_ID) REFERENCES Entrenadores(Entrenador_ID),
    FOREIGN KEY (Sede_ID) REFERENCES Sedes(Sede_ID)
);

-- datos

INSERT INTO Ciudades (Ciudad_ID, Nombre_Ciudad) VALUES
('C01', 'Madrid');

INSERT INTO Sedes (Sede_ID, Gimnasio_Sede, Ciudad_ID) VALUES
('S01', 'Sede Norte', 'C01'),
('S02', 'Sede Sur',   'C01');

INSERT INTO Especialidades (Especialidad_ID, Nombre_especialidad) VALUES
('EE01', 'Yoga'),
('EE02', 'Musculacion'),
('EE03', 'Funcional'),
('EE04', 'Boxeo');

INSERT INTO Entrenadores (Entrenador_ID, Nombre_entrenador, Especialidad_ID, Cupo_maximo) VALUES
('E01', 'Carlos', 'EE01', 3),
('E02', 'Marta',  'EE02', 3),
('E03', 'Ivan',   'EE03', 3),
('E04', 'Diego',  'EE04', 3);

INSERT INTO Planes_entrenamiento (Plan_Entrenamiento_ID, Nombre_plan) VALUES
('PE01', 'Yoga'),
('PE02', 'Pesas'),
('PE03', 'CrossFit'),
('PE04', 'Boxeo');

INSERT INTO Socios (Socio_ID, Nombres, Apellidos, Telefono) VALUES
(101, 'Ana',   'Perez', '555-1234'),
(102, 'Luis',  'Gomez', '555-5678'),
(103, 'Carla', 'Ruiz',  '555-9012');

INSERT INTO Socio_Plan_Entrenamiento (Inscripcion_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID) VALUES
(1001, 101, 'PE01', 'E01', 'S01'),
(1002, 101, 'PE02', 'E02', 'S01'),
(1003, 102, 'PE03', 'E03', 'S02'),
(1004, 103, 'PE02', 'E02', 'S01'),
(1005, 103, 'PE04', 'E04', 'S01');
