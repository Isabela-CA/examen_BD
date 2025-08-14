SET GLOBAL event_scheduler = ON;

-- ReporteVentasMensual**: Genera un informe mensual de ventas y lo almacena automáticamente.

CREATE TABLE IF NOT EXISTS ReporteVentasMensual (
    IdReporte INT AUTO_INCREMENT PRIMARY KEY,
    MesAnio VARCHAR(7),
    TotalVentas DECIMAL(10,2),
    FechaGeneracion DATETIME
);

DELIMITER $$

CREATE EVENT ReporteVentasMensual
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
BEGIN
    INSERT INTO ReporteVentasMensual (MesAnio, TotalVentas, FechaGeneracion)
    SELECT DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m') AS MesAnio,
           SUM(Total) AS TotalVentas,
           NOW()
    FROM Invoice
    WHERE YEAR(InvoiceDate) = YEAR(NOW() - INTERVAL 1 MONTH)
      AND MONTH(InvoiceDate) = MONTH(NOW() - INTERVAL 1 MONTH);
END $$

DELIMITER ;

-- **ActualizarSaldosCliente**: Actualiza los saldos de cuenta de clientes al final de cada mes.
CREATE TABLE IF NOT EXISTS SaldosClientes (
    CustomerId INT PRIMARY KEY,
    Saldo DECIMAL(10,2)
);

DELIMITER $$

CREATE EVENT ActualizarSaldosCliente
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 23:59:00'
DO
BEGIN
    REPLACE INTO SaldosClientes (CustomerId, Saldo)
    SELECT CustomerId, SUM(Total) AS Saldo
    FROM Invoice
    GROUP BY CustomerId;
END $$

DELIMITER ;



-- **AlertaAlbumNoVendidoAnual**: Envía una alerta cuando un álbum no ha registrado ventas en el último año.
CREATE TABLE IF NOT EXISTS AlertaAlbumNoVendido (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    AlbumId INT,
    FechaAlerta DATETIME
);

DELIMITER $$

CREATE EVENT AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR
STARTS '2025-12-31 23:59:00'
DO
BEGIN
    INSERT INTO AlertaAlbumNoVendido (AlbumId, FechaAlerta)
    SELECT a.AlbumId, NOW()
    FROM Album a
    WHERE a.AlbumId NOT IN (
        SELECT t.AlbumId
        FROM Track t
        JOIN InvoiceLine il ON t.TrackId = il.TrackId
        JOIN Invoice i ON il.InvoiceId = i.InvoiceId
        WHERE i.InvoiceDate >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
    );
END $$

DELIMITER ;


-- **LimpiarAuditoriaCada6Meses**: Borra los registros antiguos de auditoría cada seis meses.

DELIMITER $$

CREATE EVENT LimpiarAuditoriaCada6Meses
ON SCHEDULE EVERY 6 MONTH
STARTS '2025-12-31 23:59:00'
DO
BEGIN
    DELETE FROM AuditoriaCliente
    WHERE FechaCambio < DATE_SUB(NOW(), INTERVAL 1 YEAR);
END $$

DELIMITER ;

-- **ActualizarListaDeGenerosPopulares**: Actualiza la lista de géneros más vendidos al final de cada mes.
CREATE TABLE IF NOT EXISTS GenerosPopulares (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    MesAnio VARCHAR(7),
    Genero VARCHAR(100),
    CancionesVendidas INT
);

DELIMITER $$

CREATE EVENT ActualizarListaDeGenerosPopulares
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 23:59:00'
DO
BEGIN
    INSERT INTO GenerosPopulares (MesAnio, Genero, CancionesVendidas)
    SELECT DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m') AS MesAnio,
           g.Name,
           COUNT(il.InvoiceLineId) AS CancionesVendidas
    FROM Genre g
    JOIN Track t ON g.GenreId = t.GenreId
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE YEAR(i.InvoiceDate) = YEAR(NOW() - INTERVAL 1 MONTH)
      AND MONTH(i.InvoiceDate) = MONTH(NOW() - INTERVAL 1 MONTH)
    GROUP BY g.GenreId
    ORDER BY CancionesVendidas DESC;
END $$

DELIMITER ;


