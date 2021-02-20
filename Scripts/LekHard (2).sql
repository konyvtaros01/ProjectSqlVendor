-- Lek�rdez�s Hard (2)
declare @D datetime = '2014.01.01'

select P.ProductID, P.Name, P.ProductNumber, V.BusinessEntityID Sz�ll�t�ID, V.Name Sz�ll�t�N�v, PO.term�kDB, PV.StandardPrice,
		PO.�tlag�r, (PO.�tlag�r-PV.StandardPrice)*PO.term�kDB Profit,
		format(dateadd(d, PV.Sz�llId�Nap, @D), 'yyyy-MM-dd', 'hu-hu') V�rhat�Sz�ll�t�s,
		case when PO.term�kDB < MinOrderQty then 'T�l kev�s mennyis�g'
			when PO.term�kDB > MaxOrderQty then 'T�l sok mennyis�g'
			else 'OK' end WarningMsg
from Product P
inner join (select POD.ProductID, sum(POD.OrderQty) term�kDB, POH.OrderDate, avg(POD.UnitPrice) �tlag�r 
				from PurchaseOrderDetail POD
				inner join PurchaseOrderHeader POH on POD.PurchaseOrderID = POH.PurchaseOrderID
				where POH.OrderDate = @D
				group by POH.OrderDate, POD.ProductID
			) PO on P.ProductID = PO.ProductID
left join (select ProductID, min(StandardPrice) StandardPrice, min(BusinessEntityID) BusinessEntityID, avg(AverageLeadTime) Sz�llId�Nap,
				MinOrderQty, MaxOrderQty from ProductVendor group by ProductID, MinOrderQty, MaxOrderQty
			) PV on P.ProductID = PV.ProductID
inner join Vendor V on PV.BusinessEntityID = V.BusinessEntityID
order by P.Name

