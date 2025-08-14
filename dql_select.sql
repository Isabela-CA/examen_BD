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
