-- Lekérdezés 3. (easy)
SELECT Name, ProductNumber, ListPrice
FROM Product
WHERE ProductID NOT IN (
SELECT DISTINCT ProductID FROM ProductVendor) AND SellEndDate IS NULL
ORDER BY Name