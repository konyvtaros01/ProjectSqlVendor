-- Lekérdezés 1. (easy)
select V.BusinessEntityID, V.Name, 
concat(CR.Name, ', ' + SP.StateProvinceCode, ', ' + A.PostalCode, ', ' + A.City, ', ' + A.AddressLine1, ', ' + A.AddressLine2) cím,
case V.CreditRating when 1 then 'Superior'
                    when 2 then 'Excellent'
					when 3 then 'Above average'
					when 4 then 'Average'
					when 5 then 'Below average' 
					else 'N/A' end értékelés
from Vendor V 
inner join BusinessEntityAddress BEA on V.BusinessEntityID = BEA.BusinessEntityID
inner join Address A on BEA.AddressID = A.AddressID
inner join StateProvince SP on A.StateProvinceID = SP.StateProvinceID
inner join CountryRegion CR on SP.CountryRegionCode = CR.CountryRegionCode
where BEA.AddressTypeID = 3
order by V.Name