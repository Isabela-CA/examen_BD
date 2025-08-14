--  Encuentra el **empleado que ha generado la mayor cantidad de ventas** en el último trimestre.

select e.LastName, count(e.ReportsTo) as count_reports
from Employee e 
group by e.ReportsTo 
where count_reports DESC ;


-- Lista los **cinco artistas con más canciones vendidas** en el último año.
SELECT a.name, count(al.ArtistId)
from  Album al  
join Artist a on al.ArtistId = a.ArtistId;

-- Obtén el **total de ventas y la cantidad de canciones vendidas por país**.
SELECT SUM(i.total) as total_ventas, SUM()  
from Invoice i ;

-- Calcula el **número total de clientes que realizaron compras por cada género** en un mes específico.
SELECT COUNT(t.AlbumId), COUNT(t.MediaTypeId), g.Name, i.inovoiceDate as date
from Track t 
join Genre g ON t.GenreId = g.GenreId
join InvoiceLine il on t.TrackId  = il.TrackId 
GROUP by g.Name, date ; 

-- . Tres países con mayores ventas en el último semestre
SELECT BillingCountry, SUM(Total) AS VentasTotales
FROM Invoice
WHERE InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY BillingCountry
ORDER BY VentasTotales DESC
LIMIT 3;

--  Cinco géneros menos vendidos en el último año
SELECT g.Name AS Genero, SUM(il.Quantity) AS TotalVendidas
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY g.GenreId
ORDER BY TotalVendidas ASC
LIMIT 5;

--  Promedio de edad de clientes al momento de su primera compra
SELECT AVG(TIMESTAMPDIFF(YEAR, e.BirthDate, primera.FechaPrimeraCompra)) AS EdadPromedio
FROM (
    SELECT CustomerId, MIN(InvoiceDate) AS FechaPrimeraCompra
    FROM Invoice
    GROUP BY CustomerId
) primera
JOIN Customer c ON primera.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId;

-- Cinco empleados con más ventas de Rock
SELECT e.FirstName, e.LastName, COUNT(*) AS VentasRock
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
WHERE g.Name = 'Rock'
GROUP BY e.EmployeeId
ORDER BY VentasRock DESC
LIMIT 5;

--  Clientes con más compras recurrentes
SELECT c.FirstName, c.LastName, COUNT(i.InvoiceId) AS NumCompras
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
HAVING NumCompras > 1
ORDER BY NumCompras DESC;

-- Precio promedio de venta por género
SELECT g.Name AS Genero, AVG(il.UnitPrice) AS PrecioPromedio
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.GenreId;

-- Cinco canciones más largas vendidas en el último año
SELECT t.Name, t.Milliseconds/60000 AS Minutos, i.InvoiceDate
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY t.Milliseconds DESC
LIMIT 5;

-. Clientes que compraron más canciones de Jazz
SELECT c.FirstName, c.LastName, COUNT(*) AS CancionesJazz
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Jazz'
GROUP BY c.CustomerId
ORDER BY CancionesJazz DESC;

-- Total de minutos comprados por cada cliente en el último mes
SELECT c.FirstName, c.LastName, SUM(t.Milliseconds)/60000 AS MinutosComprados
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY c.CustomerId
ORDER BY MinutosComprados DESC;

--  Número de ventas diarias en cada mes del último trimestre
SELECT DATE(i.InvoiceDate) AS Dia, COUNT(*) AS Ventas
FROM Invoice i
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY Dia
ORDER BY Dia;

--  Total de ventas por vendedor en el último semestre
SELECT e.FirstName, e.LastName, SUM(i.Total) AS TotalVentas
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY e.EmployeeId
ORDER BY TotalVentas DESC;

--  Cliente con la compra más cara en el último año
SELECT c.FirstName, c.LastName, i.Total, i.InvoiceDate
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY i.Total DESC
LIMIT 1;

--  Cinco álbumes con más canciones vendidas en los últimos tres meses
SELECT a.Title, COUNT(il.InvoiceLineId) AS CancionesVendidas
FROM Album a
JOIN Track t ON a.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY a.AlbumId
ORDER BY CancionesVendidas DESC
LIMIT 5;

--  Cantidad de canciones vendidas por género en el último mes
SELECT g.Name AS Genero, COUNT(il.InvoiceLineId) AS CancionesVendidas
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY g.GenreId
ORDER BY CancionesVendidas DESC;

--  Clientes que no han comprado nada en el último año
SELECT c.FirstName, c.LastName
FROM Customer c
WHERE c.CustomerId NOT IN (
    SELECT CustomerId
    FROM Invoice
    WHERE InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);
