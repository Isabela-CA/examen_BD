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
