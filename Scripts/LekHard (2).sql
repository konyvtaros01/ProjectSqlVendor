-- Lekérdezés Hard (2)
declare @D datetime = '2014.01.01'

select P.ProductID, P.Name, P.ProductNumber, V.BusinessEntityID SzállítóID, V.Name SzállítóNév, PO.termékDB, PV.StandardPrice,
		PO.átlagár, (PO.átlagár-PV.StandardPrice)*PO.termékDB Profit,
		format(dateadd(d, PV.SzállIdõNap, @D), 'yyyy-MM-dd', 'hu-hu') VárhatóSzállítás,
		case when PO.termékDB < MinOrderQty then 'Túl kevés mennyiség'
			when PO.termékDB > MaxOrderQty then 'Túl sok mennyiség'
			else 'OK' end WarningMsg
from Product P
inner join (select POD.ProductID, sum(POD.OrderQty) termékDB, POH.OrderDate, avg(POD.UnitPrice) átlagár 
				from PurchaseOrderDetail POD
				inner join PurchaseOrderHeader POH on POD.PurchaseOrderID = POH.PurchaseOrderID
				where POH.OrderDate = @D
				group by POH.OrderDate, POD.ProductID
			) PO on P.ProductID = PO.ProductID
left join (select ProductID, min(StandardPrice) StandardPrice, min(BusinessEntityID) BusinessEntityID, avg(AverageLeadTime) SzállIdõNap,
				MinOrderQty, MaxOrderQty from ProductVendor group by ProductID, MinOrderQty, MaxOrderQty
			) PV on P.ProductID = PV.ProductID
inner join Vendor V on PV.BusinessEntityID = V.BusinessEntityID
order by P.Name

