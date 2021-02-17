-- Lekérdezés 3. (easy)
SELECT Name, ProductNumber, ListPrice
FROM Product
where SellEndDate is NULL and ListPrice = 0
ORDER BY Name