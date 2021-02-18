-- Lekérdezés Hard (1)
select P.ProductID TermékID, P.Name TermékNév, P.ProductNumber TermékSzáma, PV.StandardPrice ListaÁr, V.BusinessEntityID SzállítóID, V.Name SzállítóNév
from Product P
left join (select ProductID, min(StandardPrice) StandardPrice, min(BusinessEntityID) BusinessEntityID from ProductVendor group by ProductID) PV on P.ProductID = PV.ProductID
left join (select * from Vendor where ActiveFlag = 1) V on PV.BusinessEntityID = V.BusinessEntityID
order by P.Name
