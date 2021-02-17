-- Lek�rdez�s 4. (easy)
SELECT SM.Name Sz�ll_M�d, YEAR(POH.ShipDate) �v, MONTH(POH.ShipDate) h�nap, SUM(POH.SubTotal) Term�k_K�lts�g,
SUM(POH.Freight) Sz�ll�t�si_K�lts�g, SUM(POH.Freight)/SUM(POH.SubTotal)*100 Sz�ll�t�si_K�lts�gh�nyad
FROM PurchaseOrderHeader POH INNER JOIN
ShipMethod SM ON POH.ShipMethodID = SM.ShipMethodID
GROUP BY SM.Name, POH.ShipMethodID, YEAR(POH.ShipDate), MONTH(POH.ShipDate)
ORDER BY 2, 3