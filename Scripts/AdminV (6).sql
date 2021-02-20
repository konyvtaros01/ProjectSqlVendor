---  .Scripts\AdminV (6).sql
USE [Vendors]
GO
CREATE APPLICATION ROLE [PurchaseApp] WITH PASSWORD = N'Pa55w.rd '
GO
USE [Vendors]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_datareader] TO [PurchaseApp]
GO
use [Vendors]
GO
DENY SELECT ON [dbo].[PurchaseOrderDetail] TO [PurchaseApp]
GO
use [Vendors]
GO
DENY SELECT ON [dbo].[PurchaseOrderHeader] TO [PurchaseApp]
GO
use [Vendors]
GO
DENY SELECT ON [dbo].[SalesOrderDetail] TO [PurchaseApp]
GO
use [Vendors]
GO
DENY SELECT ON [dbo].[SalesOrderHeader] TO [PurchaseApp]
GO
