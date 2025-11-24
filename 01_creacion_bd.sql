

-- 1. Crear Base de Datos
-- (Este comando puede variar. Aquí un ejemplo general)
CREATE DATABASE HotelEstrellaDelValle;
GO
-- Usar la base de datos recién creada
USE HotelEstrellaDelValle;
GO

-- 2. Crear Tabla Clientes
CREATE TABLE Clientes (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY, -- a. IdCliente (PK, INT IDENTITY)
    Nombre VARCHAR(100) NOT NULL,            -- b. Nombre
    Apellidos VARCHAR(100) NOT NULL,         -- c. Apellidos
    Telefono VARCHAR(15),                    -- d. Telefono
    Email VARCHAR(100) UNIQUE,               -- e. Email
    Estado VARCHAR(10) DEFAULT 'Activo'      -- Campo adicional para Lógica de Conjuntos
);

-- 3. Crear Tabla Habitaciones
CREATE TABLE Habitaciones (
    IdHabitacion INT PRIMARY KEY,             -- a. IdHabitacion (PK)
    Numero VARCHAR(10) UNIQUE NOT NULL,       -- b. Numero
    Tipo VARCHAR(50) NOT NULL CHECK (Tipo IN ('Sencilla', 'Doble', 'Suite')), -- c. Tipo
    PrecioPorNoche DECIMAL(10, 2) NOT NULL    -- d. PrecioPorNoche
);

-- 4. Crear Tabla Reservaciones
CREATE TABLE Reservaciones (
    IdReserva INT IDENTITY(1,1) PRIMARY KEY,  -- a. IdReserva (PK)
    IdCliente INT NOT NULL,                   -- b. IdCliente (FK)
    IdHabitacion INT NOT NULL,                -- c. IdHabitacion (FK)
    FechaEntrada DATE NOT NULL,               -- d. FechaEntrada
    FechaSalida DATE NOT NULL,                -- e. FechaSalida
    CantidadNoches INT,                       -- f. CantidadNoches
    MontoTotal DECIMAL(10, 2),                -- g. MontoTotal
    FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
    FOREIGN KEY (IdHabitacion) REFERENCES Habitaciones(IdHabitacion),
    CHECK (FechaSalida > FechaEntrada)
);

-- 5. Crear Tabla Pagos
CREATE TABLE Pagos (
    IdPago INT IDENTITY(1,1) PRIMARY KEY,     -- a. IdPago (PK)
    IdReserva INT NOT NULL,                   -- b. IdReserva (FK)
    Monto DECIMAL(10, 2) NOT NULL,            -- c. Monto
    FechaPago DATETIME DEFAULT GETDATE(),     -- d. FechaPago
    MetodoPago VARCHAR(50) NOT NULL,          -- e. MetodoPago
    FOREIGN KEY (IdReserva) REFERENCES Reservaciones(IdReserva)
);


-- ******************************************************
-- 3. Inserción de Datos
-- ******************************************************

-- 1. Insertar 10 Clientes (Con uno Inactivo para el UNION)
INSERT INTO Clientes (Nombre, Apellidos, Telefono, Email, Estado) VALUES
('Juan', 'Perez Garcia', '55510001', 'juan.perez@email.com', 'Activo'), -- 1
('Maria', 'Lopez Martinez', '55510002', 'maria.lopez@email.com', 'Activo'), -- 2
('Carlos', 'Rodriguez Sanchez', '55510003', 'carlos.rod@email.com', 'Activo'), -- 3
('Ana', 'Gomez Diaz', '55510004', 'ana.gomez@email.com', 'Activo'), -- 4
('Luis', 'Hernandez Torres', '55510005', 'luis.h@email.com', 'Activo'), -- 5
('Sofia', 'Ramirez Flores', '55510006', 'sofia.r@email.com', 'Activo'), -- 6
('Pedro', 'Morales Castro', '55510007', 'pedro.m@email.com', 'Activo'), -- 7
('Elena', 'Ruiz Vargas', '55510008', 'elena.r@email.com', 'Inactivo'), -- 8 (Inactivo)
('Ricardo', 'Jimenez Soto', '55510009', 'ricardo.j@email.com', 'Activo'), -- 9
('Valeria', 'Mendez Bravo', '55510010', 'valeria.m@email.com', 'Activo'); -- 10

-- 2. Insertar 10 Habitaciones
INSERT INTO Habitaciones (IdHabitacion, Numero, Tipo, PrecioPorNoche) VALUES
(101, '101', 'Sencilla', 75.00),
(102, '102', 'Doble', 120.00),
(103, '103', 'Suite', 250.00),
(104, '104', 'Sencilla', 80.00),
(201, '201', 'Doble', 130.00),
(202, '202', 'Doble', 135.00),
(301, '301', 'Suite', 300.00),
(302, '302', 'Suite', 290.00),
(401, '401', 'Sencilla', 90.00),
(402, '402', 'Doble', 140.00);

-- 3. Insertar 15 Reservaciones (Se usa 1, 2, 3, 4, 5, 9, 10 de clientes)
-- Nota: La cantidad de noches y el monto total se pueden calcular dinámicamente o insertar manualmente.
-- Para simplicidad en la inserción manual, asumimos los valores.
-- Cliente 1 tiene 2 reservas (para subconsulta)
INSERT INTO Reservaciones (IdCliente, IdHabitacion, FechaEntrada, FechaSalida, CantidadNoches, MontoTotal) VALUES
(1, 101, '2025-11-01', '2025-11-04', 3, 225.00), -- 1 (Cliente 1)
(2, 102, '2025-11-05', '2025-11-07', 2, 240.00), -- 2
(3, 103, '2025-11-10', '2025-11-12', 2, 500.00), -- 3
(4, 201, '2025-10-25', '2025-10-28', 3, 390.00), -- 4
(5, 202, '2025-12-01', '2025-12-06', 5, 675.00), -- 5
(1, 301, '2025-12-15', '2025-12-18', 3, 900.00), -- 6 (Cliente 1, segunda reserva)
(9, 401, '2025-11-20', '2025-11-22', 2, 180.00), -- 7
(10, 402, '2025-11-25', '2025-11-27', 2, 280.00), -- 8
(2, 101, '2025-12-20', '2025-12-21', 1, 75.00), -- 9
(3, 104, '2025-11-03', '2025-11-06', 3, 240.00), -- 10
(4, 201, '2025-12-09', '2025-12-11', 2, 260.00), -- 11
(5, 302, '2025-11-08', '2025-11-10', 2, 580.00), -- 12
(9, 102, '2025-12-03', '2025-12-05', 2, 240.00), -- 13
(10, 202, '2025-11-15', '2025-11-17', 2, 270.00), -- 14
(3, 401, '2025-10-10', '2025-10-15', 5, 450.00); -- 15

-- 4. Insertar 15 Pagos (Pago por reserva, con 2 pagos parciales para Res. 3, y 1 pago de una reserva cancelada para DELETE)
INSERT INTO Pagos (IdReserva, Monto, MetodoPago) VALUES
(1, 225.00, 'Tarjeta Credito'), -- Res 1
(2, 240.00, 'Efectivo'),       -- Res 2
(3, 250.00, 'Tarjeta Debito'),  -- Res 3 (Pago parcial)
(3, 250.00, 'Tarjeta Debito'),  -- Res 3 (Pago final)
(4, 390.00, 'Transferencia'),   -- Res 4
(5, 675.00, 'Tarjeta Credito'), -- Res 5
(6, 900.00, 'Efectivo'),       -- Res 6
(7, 180.00, 'Transferencia'),   -- Res 7
(8, 280.00, 'Tarjeta Credito'), -- Res 8
(9, 75.00, 'Efectivo'),         -- Res 9
(10, 240.00, 'Tarjeta Debito'), -- Res 10
(11, 260.00, 'Transferencia'),  -- Res 11
(12, 580.00, 'Tarjeta Credito'),-- Res 12
(13, 240.00, 'Efectivo'),       -- Res 13
(14, 270.00, 'Transferencia');  -- Res 14


-- ******************************************************
-- 4. Consultas Básicas
-- ******************************************************

-- ✔ Listar todos los clientes ordenados por apellido
SELECT IdCliente, Nombre, Apellidos, Telefono, Email
FROM Clientes
ORDER BY Apellidos ASC;

-- ✔ Listar habitaciones de mayor a menor precio
SELECT IdHabitacion, Numero, Tipo, PrecioPorNoche
FROM Habitaciones
ORDER BY PrecioPorNoche DESC;

-- ✔ Mostrar reservaciones realizadas en un rango de fechas (Noviembre 2025)
SELECT IdReserva, IdCliente, IdHabitacion, FechaEntrada, FechaSalida, MontoTotal
FROM Reservaciones
WHERE FechaEntrada BETWEEN '2025-11-01' AND '2025-11-30';



-- ******************************************************
-- 5. Consultas Avanzadas
-- ******************************************************

-- ✔ JOIN entre Reservaciones, Habitaciones y Clientes
SELECT
    R.IdReserva,
    C.Nombre AS NombreCliente,
    C.Apellidos AS ApellidoCliente,
    H.Numero AS NumeroHabitacion,
    H.Tipo AS TipoHabitacion,
    R.FechaEntrada,
    R.FechaSalida,
    R.MontoTotal
FROM Reservaciones R
JOIN Clientes C ON R.IdCliente = C.IdCliente
JOIN Habitaciones H ON R.IdHabitacion = H.IdHabitacion;

-- ✔ JOIN para pagos por cliente (Clientes -> Reservaciones -> Pagos)
SELECT
    C.Nombre,
    C.Apellidos,
    P.IdPago,
    P.Monto AS MontoPago,
    P.FechaPago,
    R.IdReserva
FROM Clientes C
JOIN Reservaciones R ON C.IdCliente = R.IdCliente
JOIN Pagos P ON R.IdReserva = P.IdReserva
ORDER BY C.Apellidos, P.FechaPago;

-- ✔ Subconsulta que liste clientes que han hecho más de una reserva
SELECT Nombre, Apellidos, Email
FROM Clientes
WHERE IdCliente IN (
    SELECT IdCliente
    FROM Reservaciones
    GROUP BY IdCliente
    HAVING COUNT(IdReserva) > 1
);

-- ✔ Consultas con lógica condicional WHERE (mayor, menor, LIKE, BETWEEN)
-- Clientes cuyo apellido empieza con 'R'
SELECT Nombre, Apellidos FROM Clientes WHERE Apellidos LIKE 'R%';

-- Habitaciones con precio por noche mayor a $150.00
SELECT Numero, Tipo, PrecioPorNoche FROM Habitaciones WHERE PrecioPorNoche > 150.00;

-- Reservaciones con MontoTotal menor a $300.00
SELECT IdReserva, MontoTotal FROM Reservaciones WHERE MontoTotal < 300.00;

-- ******************************************************
-- 6. Lógica de Conjuntos
-- ******************************************************

-- ✔ UNION entre clientes activos e inactivos
SELECT Nombre, Apellidos, Estado FROM Clientes WHERE Estado = 'Activo'
UNION
SELECT Nombre, Apellidos, Estado FROM Clientes WHERE Estado = 'Inactivo'
ORDER BY Estado DESC, Apellidos;

-- ✔ INTERSECT para identificar clientes con reservaciones Y pagos
-- Clientes que tienen al menos una reserva pagada.
SELECT C.Nombre, C.Apellidos, C.IdCliente
FROM Clientes C
JOIN Reservaciones R ON C.IdCliente = R.IdCliente
-- INTERSECT solo funciona en SQL Server/Oracle, para MySQL/PostgreSQL
-- se usa JOIN o EXISTS
INTERSECT -- Si usas SQL Server
SELECT C.Nombre, C.Apellidos, C.IdCliente
FROM Clientes C
JOIN Reservaciones R ON C.IdCliente = R.IdCliente
JOIN Pagos P ON R.IdReserva = P.IdReserva;

-- ✔ EXCEPT para identificar habitaciones que no tienen reservación
-- Habitaciones en la tabla Habitaciones que NO están en la tabla Reservaciones
SELECT IdHabitacion, Numero
FROM Habitaciones
EXCEPT -- Si usas SQL Server
SELECT IdHabitacion, H.Numero
FROM Habitaciones H
JOIN Reservaciones R ON H.IdHabitacion = R.IdHabitacion;


-- ******************************************************
-- 6. Transacciones (Registrar nueva reservación y pago)
-- ******************************************************

BEGIN TRANSACTION;

-- Datos de la nueva reserva: Cliente 10, Habitación 302, 4 noches * 290.00 = 1160.00
DECLARE @NuevoIdReserva INT;
DECLARE @NuevaFechaEntrada DATE = '2026-01-05';
DECLARE @NuevaFechaSalida DATE = '2026-01-09';
DECLARE @CantNoches INT = 4;
DECLARE @MontoReserva DECIMAL(10, 2) = 1160.00;
DECLARE @ClienteId INT = 10;
DECLARE @HabitacionId INT = 302;
DECLARE @MetodoPago VARCHAR(50) = 'Tarjeta Credito';

-- 1. Registrar una nueva reservación
INSERT INTO Reservaciones (IdCliente, IdHabitacion, FechaEntrada, FechaSalida, CantidadNoches, MontoTotal)
VALUES (@ClienteId, @HabitacionId, @NuevaFechaEntrada, @NuevaFechaSalida, @CantNoches, @MontoReserva);

-- Obtener el ID de la reserva insertada
SET @NuevoIdReserva = SCOPE_IDENTITY(); 

-- 2. Insertar un pago correspondiente
INSERT INTO Pagos (IdReserva, Monto, MetodoPago)
VALUES (@NuevoIdReserva, @MontoReserva, @MetodoPago);

-- 3. Si alguna inserción falla → ROLLBACK (Esta lógica se maneja implícitamente por el motor si hay un error)
-- Aquí solo verificamos si las inserciones tuvieron éxito
IF @@ERROR <> 0 -- SQL Server check for error
BEGIN
    -- 3. Si alguna inserción falla → ROLLBACK
    ROLLBACK TRANSACTION;
    SELECT 'Transacción fallida. Se ha ejecutado ROLLBACK.';
END
ELSE
BEGIN
    -- 4. Si todo es correcto → COMMIT
    COMMIT TRANSACTION;
    SELECT 'Transacción exitosa. Reservación y Pago registrados con COMMIT.';
END

-- ******************************************************
-- 7. Manipulación de Datos
-- ******************************************************

-- ✔ Actualizar precio de una habitación según el tipo (Aumentar 10.00 a todas las Dobles)
UPDATE Habitaciones
SET PrecioPorNoche = PrecioPorNoche + 10.00
WHERE Tipo = 'Doble';
-- Verificar:
SELECT * FROM Habitaciones WHERE Tipo = 'Doble';

-- ✔ Eliminar pagos de una reserva cancelada (Eliminar pagos de la Reserva 14, por ejemplo)
DELETE FROM Pagos
WHERE IdReserva = 14;
-- Verificar:
SELECT * FROM Pagos WHERE IdReserva = 14;

-- ✔ Insertar una reserva nueva con un cálculo dinámico del monto total
-- (Usando IdCliente=2, IdHabitacion=301. Precio=300.00. 4 noches.)
INSERT INTO Reservaciones (IdCliente, IdHabitacion, FechaEntrada, FechaSalida, CantidadNoches, MontoTotal)
SELECT
    2, -- IdCliente
    301, -- IdHabitacion
    '2026-02-10', -- FechaEntrada
    '2026-02-14', -- FechaSalida
    DATEDIFF(day, '2026-02-10', '2026-02-14'), -- CantidadNoches (Ejemplo DATEDIFF SQL Server)
    (SELECT PrecioPorNoche FROM Habitaciones WHERE IdHabitacion = 301) * DATEDIFF(day, '2026-02-10', '2026-02-14');


    -- ******************************************************
-- 8.2 Funciones
-- ******************************************************

-- 1. fn_CalcularNoches (Función Escalar)
CREATE FUNCTION fn_CalcularNoches (@FechaEntrada DATE, @FechaSalida DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @FechaEntrada, @FechaSalida);
END
GO
-- Ejemplo de uso:
SELECT dbo.fn_CalcularNoches('2025-10-10', '2025-10-15') AS CantidadNoches;
GO

-- 2. fn_CalcularMonto (Función Escalar)
CREATE FUNCTION fn_CalcularMonto (@PrecioNoche DECIMAL(10, 2), @Noches INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    RETURN @PrecioNoche * @Noches;
END
GO
-- Ejemplo de uso:
SELECT dbo.fn_CalcularMonto(120.00, 5) AS MontoTotal;
GO


-- ******************************************************
-- 8.2 Funciones
-- ******************************************************

-- 1. fn_CalcularNoches (Función Escalar)
CREATE FUNCTION fn_CalcularNoches (@FechaEntrada DATE, @FechaSalida DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @FechaEntrada, @FechaSalida);
END
GO
-- Ejemplo de uso:
SELECT dbo.fn_CalcularNoches('2025-10-10', '2025-10-15') AS CantidadNoches;
GO

-- 2. fn_CalcularMonto (Función Escalar)
CREATE FUNCTION fn_CalcularMonto (@PrecioNoche DECIMAL(10, 2), @Noches INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    RETURN @PrecioNoche * @Noches;
END
GO
-- Ejemplo de uso:
SELECT dbo.fn_CalcularMonto(120.00, 5) AS MontoTotal;
GO



-- ******************************************************
-- 8.3 Vistas
-- ******************************************************

-- 1. vw_ReservasDetalle: Muestra la información completa de las reservas
CREATE VIEW vw_ReservasDetalle
AS
SELECT
    R.IdReserva,
    C.Nombre + ' ' + C.Apellidos AS NombreCliente,
    H.Numero AS HabitacionNumero,
    H.Tipo AS HabitacionTipo,
    R.FechaEntrada,
    R.FechaSalida,
    R.CantidadNoches,
    R.MontoTotal
FROM Reservaciones R
JOIN Clientes C ON R.IdCliente = C.IdCliente
JOIN Habitaciones H ON R.IdHabitacion = H.IdHabitacion;
GO
-- Ejemplo de consulta:
SELECT * FROM vw_ReservasDetalle;
GO

-- 2. vw_PagosPorCliente: Muestra el total pagado por cada cliente
CREATE VIEW vw_PagosPorCliente
AS
SELECT
    C.IdCliente,
    C.Nombre + ' ' + C.Apellidos AS NombreCliente,
    SUM(P.Monto) AS TotalPagado
FROM Clientes C
JOIN Reservaciones R ON C.IdCliente = R.IdCliente
JOIN Pagos P ON R.IdReserva = P.IdReserva
GROUP BY C.IdCliente, C.Nombre, C.Apellidos;
GO
-- Ejemplo de consulta:
SELECT * FROM vw_PagosPorCliente ORDER BY TotalPagado DESC;
GO

-- 3. vw_IngresosHabitaciones: Muestra el ingreso total generado por tipo de habitación
CREATE VIEW vw_IngresosHabitaciones
AS
SELECT
    H.Tipo AS TipoHabitacion,
    SUM(R.MontoTotal) AS IngresoTotal
FROM Reservaciones R
JOIN Habitaciones H ON R.IdHabitacion = H.IdHabitacion
GROUP BY H.Tipo;
GO
-- Ejemplo de consulta:
SELECT * FROM vw_IngresosHabitaciones;
GO

-- ******************************************************
-- 8.4 Procedimiento almacenado
-- ******************************************************

CREATE PROCEDURE sp_RegistrarReserva
    @IdCliente INT,
    @IdHabitacion INT,
    @FechaEntrada DATE,
    @FechaSalida DATE
AS
BEGIN
    DECLARE @Noches INT = DATEDIFF(DAY,@FechaEntrada,@FechaSalida);
    DECLARE @Precio DECIMAL(10,2) = (SELECT PrecioPorNoche FROM Habitaciones WHERE IdHabitacion=@IdHabitacion);
    DECLARE @Total DECIMAL(10,2) = @Noches * @Precio;

    INSERT INTO Reservaciones VALUES (@IdCliente,@IdHabitacion,@FechaEntrada,@FechaSalida,@Noches,@Total);
END;
GO

CREATE PROCEDURE sp_ActualizarDatosCliente
    @IdCliente INT,
    @Nombre VARCHAR(100),
    @Apellidos VARCHAR(100),
    @Telefono VARCHAR(15),
    @Email VARCHAR(100)
AS
BEGIN
    UPDATE Clientes
    SET Nombre=@Nombre,Apellidos=@Apellidos,Telefono=@Telefono,Email=@Email
    WHERE IdCliente=@IdCliente;
END;
GO

CREATE PROCEDURE sp_ReporteIngresosPorMes
    @Ano INT,@Mes INT
AS
BEGIN
    SELECT YEAR(FechaEntrada) Año, MONTH(FechaEntrada) Mes, SUM(MontoTotal) Ingreso
    FROM Reservaciones
    WHERE YEAR(FechaEntrada)=@Ano AND MONTH(FechaEntrada)=@Mes
    GROUP BY YEAR(FechaEntrada), MONTH(FechaEntrada);
END;
GO

-- ******************************************************
-- 8.5 Triggers
-- ******************************************************
CREATE TABLE LogHabitaciones (
    IdLog INT IDENTITY PRIMARY KEY,
    IdHabitacion INT,
    Usuario VARCHAR(100),
    Fecha DATETIME DEFAULT GETDATE(),
    TipoCambio VARCHAR(50)
);


CREATE TRIGGER trg_CalcularMontos
ON Reservaciones
AFTER INSERT
AS
BEGIN
    UPDATE R
    SET CantidadNoches = DATEDIFF(DAY,R.FechaEntrada,R.FechaSalida),
        MontoTotal = DATEDIFF(DAY,R.FechaEntrada,R.FechaSalida) * H.PrecioPorNoche
    FROM Reservaciones R
    JOIN inserted I ON R.IdReserva=I.IdReserva
    JOIN Habitaciones H ON R.IdHabitacion=H.IdHabitacion;
END;


CREATE TRIGGER trg_LogCambiosHabitaciones
ON Habitaciones
AFTER UPDATE
AS
BEGIN
    INSERT INTO LogHabitaciones (IdHabitacion,Usuario,TipoCambio)
    SELECT I.IdHabitacion, SYSTEM_USER, 'Actualización'
    FROM inserted I;
END;

-- ******************************************************
-- 8.6 CTEs
-- ******************************************************
WITH CTE_Ingresos AS (
    SELECT C.IdCliente, C.Nombre + ' ' + C.Apellidos AS Cliente,
           SUM(R.MontoTotal) AS Ingreso
    FROM Clientes C
    JOIN Reservaciones R ON C.IdCliente=R.IdCliente
    GROUP BY C.IdCliente, C.Nombre, C.Apellidos
)
SELECT * FROM CTE_Ingresos ORDER BY Ingreso DESC;

WITH CTE_Ocupacion AS (
    SELECT H.Numero, H.Tipo,
           YEAR(R.FechaEntrada) AS Año,
           MONTH(R.FechaEntrada) AS Mes,
           COUNT(*) AS CantidadReservas
    FROM Reservaciones R
    JOIN Habitaciones H ON R.IdHabitacion=H.IdHabitacion
    GROUP BY H.Numero, H.Tipo, YEAR(R.FechaEntrada), MONTH(R.FechaEntrada)
)
SELECT * FROM CTE_Ocupacion ORDER BY Año, Mes;

-- ******************************************************
-- 8.7 BACKUP
-- ******************************************************
BACKUP DATABASE HotelEstrellaDelValle
TO DISK = 'C:\\Backups\\HotelEstrellaDelValle.bak'
WITH FORMAT, INIT;

RESTORE DATABASE HotelEstrellaDelValle
FROM DISK = 'C:\\Backups\\HotelEstrellaDelValle.bak'
WITH REPLACE;
