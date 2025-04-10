
-- Section 2: SQL – Cuvette TA Assignment
-- Database: Chinook

-- 1️⃣ Top 5 customers by total purchase amount
SELECT 
    c.CustomerId,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    SUM(i.Total) AS TotalPurchase
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
GROUP BY 
    c.CustomerId
ORDER BY 
    TotalPurchase DESC
LIMIT 5;

-- 2️⃣ Most popular genre in terms of total tracks sold
SELECT 
    g.Name AS Genre,
    SUM(ii.Quantity) AS TotalTracksSold
FROM 
    InvoiceLine ii
JOIN 
    Track t ON ii.TrackId = t.TrackId
JOIN 
    Genre g ON t.GenreId = g.GenreId
GROUP BY 
    g.Name
ORDER BY 
    TotalTracksSold DESC
LIMIT 1;

-- 3️⃣ Retrieve all employees who are managers along with their subordinates
SELECT 
    m.EmployeeId AS ManagerId,
    m.FirstName || ' ' || m.LastName AS ManagerName,
    e.EmployeeId AS SubordinateId,
    e.FirstName || ' ' || e.LastName AS SubordinateName
FROM 
    Employee e
JOIN 
    Employee m ON e.ReportsTo = m.EmployeeId
ORDER BY 
    ManagerId;

-- 4️⃣ For each artist, find their most sold album
WITH AlbumSales AS (
  SELECT 
    ar.Name AS ArtistName,
    al.AlbumId,
    al.Title AS AlbumTitle,
    SUM(il.Quantity) AS TotalTracksSold
  FROM Artist ar
  JOIN Album al ON ar.ArtistId = al.ArtistId
  JOIN Track t ON al.AlbumId = t.AlbumId
  JOIN InvoiceLine il ON t.TrackId = il.TrackId
  GROUP BY ar.Name, al.AlbumId, al.Title
),
RankedAlbums AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ArtistName ORDER BY TotalTracksSold DESC) AS Rank
  FROM AlbumSales
)
SELECT * FROM RankedAlbums
WHERE Rank = 1;

-- 5️⃣ Monthly sales trends in the year 2013
SELECT 
    strftime('%Y-%m', InvoiceDate) AS Month,
    SUM(Total) AS MonthlySales
FROM 
    Invoice
WHERE 
    strftime('%Y', InvoiceDate) = '2013'
GROUP BY 
    Month
ORDER BY 
    Month;
