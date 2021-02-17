---  .Scripts\AdminV (2).sql
-- VendorAdmin login és user létrehozás, bekötés
USE [master]
GO
CREATE LOGIN [VendorAdmin] WITH PASSWORD=N'Pa55w.rd' , DEFAULT_DATABASE=[Vendors], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [Vendors]
GO
CREATE USER [VendorAdmin] FOR LOGIN [VendorAdmin]
GO
USE [Vendors]
GO
ALTER ROLE [db_owner] ADD MEMBER [VendorAdmin]
GO

-- VendorRO login és user létrehozás, bekötés
USE [master]
GO
CREATE LOGIN [VendorRO] WITH PASSWORD=N'Pa55w.rd' , DEFAULT_DATABASE=[Vendors], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [Vendors]
GO
CREATE USER [VendorRO] FOR LOGIN [VendorRO]
GO
USE [Vendors]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VendorRO]
GO
