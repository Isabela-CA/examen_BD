-- 1 **ActualizarTotalVentasEmpleado**: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.

CREATE TABLE IF NOT EXISTS VentasEmpleado (
    EmployeeId INT PRIMARY KEY,
    TotalVentas DECIMAL(10,2) DEFAULT 0
);

DELIMITER $$

CREATE TRIGGER ActualizarTotalVentasEmpleado
AFTER INSERT ON Invoice
FOR EACH ROW
BEGIN
    DECLARE empId INT;

    -- Obtener el empleado que atiende al cliente
    SELECT SupportRepId INTO empId
    FROM Customer
    WHERE CustomerId = NEW.CustomerId;

    -- Insertar o actualizar el total de ventas del empleado
    INSERT INTO VentasEmpleado (EmployeeId, TotalVentas)
    VALUES (empId, NEW.Total)
    ON DUPLICATE KEY UPDATE TotalVentas = TotalVentas + NEW.Total;
END $$

DELIMITER ;


-- 2. **AuditarActualizacionCliente**: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.

CREATE TABLE IF NOT EXISTS AuditoriaCliente (
    AuditId INT AUTO_INCREMENT PRIMARY KEY,
    CustomerId INT,
    CampoModificado VARCHAR(50),
    ValorAnterior VARCHAR(255),
    ValorNuevo VARCHAR(255),
    FechaCambio DATETIME
);


DELIMITER $$

CREATE TRIGGER AuditarActualizacionCliente
BEFORE UPDATE ON Customer
FOR EACH ROW
BEGIN
    IF OLD.FirstName <> NEW.FirstName THEN
        INSERT INTO AuditoriaCliente (CustomerId, CampoModificado, ValorAnterior, ValorNuevo, FechaCambio)
        VALUES (OLD.CustomerId, 'FirstName', OLD.FirstName, NEW.FirstName, NOW());
    END IF;

    IF OLD.LastName <> NEW.LastName THEN
        INSERT INTO AuditoriaCliente (CustomerId, CampoModificado, ValorAnterior, ValorNuevo, FechaCambio)
        VALUES (OLD.CustomerId, 'LastName', OLD.LastName, NEW.LastName, NOW());
    END IF;

    IF OLD.Email <> NEW.Email THEN
        INSERT INTO AuditoriaCliente (CustomerId, CampoModificado, ValorAnterior, ValorNuevo, FechaCambio)
        VALUES (OLD.CustomerId, 'Email', OLD.Email, NEW.Email, NOW());
    END IF;
END $$

DELIMITER ;


-- 3. **RegistrarHistorialPrecioCancion**: Guarda el historial de cambios en el precio de las canciones

CREATE TABLE IF NOT EXISTS HistorialPrecioCancion (
    HistorialId INT AUTO_INCREMENT PRIMARY KEY,
    TrackId INT,
    PrecioAnterior DECIMAL(10,2),
    PrecioNuevo DECIMAL(10,2),
    FechaCambio DATETIME
);

DELIMITER $$

CREATE TRIGGER RegistrarHistorialPrecioCancion
BEFORE UPDATE ON Track
FOR EACH ROW
BEGIN
    IF OLD.UnitPrice <> NEW.UnitPrice THEN
        INSERT INTO HistorialPrecioCancion (TrackId, PrecioAnterior, PrecioNuevo, FechaCambio)
        VALUES (OLD.TrackId, OLD.UnitPrice, NEW.UnitPrice, NOW());
    END IF;
END $$

DELIMITER ;

-- 4. **NotificarCancelacionVenta**: Registra una notificación cuando se elimina un registro de venta.
CREATE TABLE IF NOT EXISTS NotificacionesVenta (
    NotificacionId INT AUTO_INCREMENT PRIMARY KEY,
    InvoiceId INT,
    Mensaje VARCHAR(255),
    Fecha DATETIME
);

DELIMITER $$

CREATE TRIGGER NotificarCancelacionVenta
AFTER DELETE ON Invoice
FOR EACH ROW
BEGIN
    INSERT INTO NotificacionesVenta (InvoiceId, Mensaje, Fecha)
    VALUES (OLD.InvoiceId, CONCAT('La venta con ID ', OLD.InvoiceId, ' fue cancelada.'), NOW());
END $$

DELIMITER ;


-- 5. **RestringirCompraConSaldoDeudor**: Evita que un cliente con saldo deudor realice nuevas compras.

DELIMITER $$

CREATE TRIGGER RestringirCompraConSaldoDeudor
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    DECLARE deuda DECIMAL(10,2);

    -- Ejemplo: saldo pendiente = facturas totales en negativo o sin pagar
    -- Aquí asumimos que Total < 0 indica deuda
    SELECT SUM(Total) INTO deuda
    FROM Invoice
    WHERE CustomerId = NEW.CustomerId
      AND Total < 0; -- Ajusta según tu lógica real

    IF deuda IS NOT NULL AND deuda > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente tiene saldo deudor y no puede realizar compras.';
    END IF;
END $$

DELIMITER ;

















