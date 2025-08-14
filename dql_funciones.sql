-- fuction
-- - **TotalGastoCliente(ClienteID, Anio)**: Calcula el gasto total de un cliente en un año específico.

CREATE TABLE IF NOT EXISTS TotalGastoCliente (
    CustomerId INT PRIMARY KEY AUTO_INCREMENT,
    anio INT NOT NULL,
   );

DELIMITER //

CREATE EVENT IF NOT EXISTS TotalGastoCliente
ON SCHEDULE EVERY 1 YEAR 
STARTS TIMESTAMP(CURRENT_DATE + INTERVAL 1 DAY - INTERVAL DAY(CURRENT_DATE)-1 DAY) + INTERVAL 5 MINUTE
DO
BEGIN
    SELECT * from Invoice i;
    INSERT INTO TotalGastoCliente (anio, total)
    SELECT
        YEAR(v.fecha_venta) AS anio,
        SUM(Total) AS total_ventas,
        NOW()
    FROM Invoice i
    WHERE v.fecha_venta >= DATE_FORMAT(CURRENT_DATE - INTERVAL 1 YEAR , '%Y-%m-01')
    GROUP BY anio;
END;
//

DELIMITER ;

SELECT * FROM TotalGastoCliente ORDER BY date DESC;
SELECT * FROM reporte_ventas_mensual
ORDER BY fecha_generacion DESC;

-- Calcula la duración total de todas las canciones vendidas de un género específico.

DELIMITER //
CREATE FUNCTION total_canciones (p_genreId)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	
SELECT SUM(t.Bytes), g.Name
from Track t
join Genre g ON t.GenreId  = g.GenreId 
where g.name = 'Pop';

 RETURN;
END //
DELIMITER ;

-- 3. **PromedioPrecioPorAlbum(AlbumID)**: Retorna el precio promedio de las canciones de un álbum, -

DELIMITER $$

CREATE FUNCTION PromedioPrecioPorAlbum(p_AlbumID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);

    SELECT AVG(UnitPrice)
    INTO promedio
    FROM Track
    WHERE AlbumId = p_AlbumID;

    RETURN promedio;
END $$

DELIMITER ;

-- 4. **DescuentoPorFrecuencia(ClienteID)**: Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
DELIMITER $$

CREATE FUNCTION DescuentoPorFrecuencia(p_ClienteID INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE totalCompras INT;
    DECLARE descuento DECIMAL(5,2);

    -- Contamos las compras del último año
    SELECT COUNT(*) 
    INTO totalCompras
    FROM Invoice
    WHERE CustomerId = p_ClienteID
      AND InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

    -- Asignamos descuento según frecuencia
    IF totalCompras >= 20 THEN
        SET descuento = 0.20; -- 20%
    ELSEIF totalCompras >= 10 THEN
        SET descuento = 0.10; -- 10%
    ELSEIF totalCompras >= 5 THEN
        SET descuento = 0.05; -- 5%
    ELSE
        SET descuento = 0.00; -- Sin descuento
    END IF;

    RETURN descuento;
END $$

DELIMITER ;



-- 5. **VerificarClienteVIP(ClienteID)**: Verifica si un cliente es "VIP" basándose en sus gastos anuales.

DELIMITER $$

CREATE FUNCTION VerificarClienteVIP(p_ClienteID INT)
RETURNS TINYINT
DETERMINISTIC
BEGIN
    DECLARE gastoAnual DECIMAL(10,2);
    DECLARE esVIP TINYINT;

    -- Sumamos el total gastado por el cliente en el último año
    SELECT SUM(Total)
    INTO gastoAnual
    FROM Invoice
    WHERE CustomerId = p_ClienteID
      AND InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

    -- Verificamos si supera el umbral
    IF gastoAnual >= 100 THEN -- puedes ajustar el monto
        SET esVIP = 1;
    ELSE
        SET esVIP = 0;
    END IF;

    RETURN esVIP;
END $$

DELIMITER ;


