-- Lek�rdez�s Hard (1)
select P.ProductID Term�kID, P.Name Term�kN�v, P.ProductNumber Term�kSz�ma, PV.StandardPrice Lista�r, V.BusinessEntityID Sz�ll�t�ID, V.Name Sz�ll�t�N�v
from Product P
left join (select ProductID, min(StandardPrice) StandardPrice, min(BusinessEntityID) BusinessEntityID from ProductVendor group by ProductID) PV on P.ProductID = PV.ProductID
left join (select * from Vendor where ActiveFlag = 1) V on PV.BusinessEntityID = V.BusinessEntityID
order by P.Name
