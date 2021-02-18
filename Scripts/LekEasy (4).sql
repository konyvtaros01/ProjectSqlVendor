-- Lekérdezés 4. (easy)
SELECT SM.Name Száll_Mód, YEAR(POH.ShipDate) év, MONTH(POH.ShipDate) hónap, SUM(POH.SubTotal) Termék_Költség,
SUM(POH.Freight) Szállítási_Költség, SUM(POH.Freight)/SUM(POH.SubTotal)*100 [Szállítási Költséghányad %]
FROM PurchaseOrderHeader POH INNER JOIN
ShipMethod SM ON POH.ShipMethodID = SM.ShipMethodID
GROUP BY SM.Name, POH.ShipMethodID, YEAR(POH.ShipDate), MONTH(POH.ShipDate)
ORDER BY 2, 3