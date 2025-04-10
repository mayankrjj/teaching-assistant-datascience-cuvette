
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
        SUM(ii.Quantity) AS TotalSold
    FROM 
        InvoiceLine ii
    JOIN 
        Track t ON ii.TrackId = t.TrackId
    JOIN 
        Album al ON t.AlbumId = al.AlbumId
    JOIN 
        Artist ar ON al.ArtistId = ar.ArtistId
    GROUP BY 
        al.AlbumId
)
SELECT 
    ArtistName,
    AlbumTitle,
    MAX(TotalSold) AS MostSold
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY ArtistName ORDER BY TotalSold DESC) AS rnk
    FROM AlbumSales
) ranked
WHERE rnk = 1;

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
