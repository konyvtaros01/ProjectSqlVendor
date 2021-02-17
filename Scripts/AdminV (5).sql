-- Vendors adatbázis feltöltése az AdventureWorks2019 adatbázisból
-- Az alábbi táblákat kell áthozni:
-- A Purchasing séma Vendor, ProductVendor és ShipMethod táblája (Primary filegroup-ba)
-- A Purchasing séma PurchaseOrderHeader és PurchaseOrderDetail táblái (SalesData filegroup-ba)
-- A Person séma összes táblája – kivéve a Password (Primary filegroup-ba)
-- A Product, ProductSubcategory, ProductCategory, UnitMeasure táblák (Primary filegroup-ba)
-- A SalesOrderHeader és a SalesOrderDetail táblák (SalesData filegroup-ba).

/*-------------------------------
A feladat leggyorsabb kivitelezése az, ha az AdventureWorks2019 adatbázison állva jobb egérrel Tasks, majd Generate Scripts...
Csak a User-defined data types-ból és a táblákból válogatunk.
Az összes saját adattípust (User Defined Data Types) generáljuk ki.
Majd jelöljük ki a szükséges táblákat, majd Save to után elõáll a script (vagy új Query ablakban, vagy a Clipboard-on)
-------------------------------*/

--USE AdventureWorks2019 helyett:
USE Vendors
GO

-- A meglévõ táblák törlése megfelelõ sorrendben
DROP TABLE IF EXISTS dbo.SalesOrderDetail
DROP TABLE IF EXISTS dbo.SalesOrderHeader
DROP TABLE IF EXISTS dbo.PurchaseOrderDetail
DROP TABLE IF EXISTS dbo.PurchaseOrderHeader
DROP TABLE IF EXISTS dbo.ProductVendor
DROP TABLE IF EXISTS dbo.Product
DROP TABLE IF EXISTS dbo.ProductSubcategory
DROP TABLE IF EXISTS dbo.ProductCategory
DROP TABLE IF EXISTS dbo.Vendor
DROP TABLE IF EXISTS dbo.UnitMeasure
DROP TABLE IF EXISTS dbo.ShipMethod
DROP TABLE IF EXISTS dbo.BusinessEntityAddress
DROP TABLE IF EXISTS dbo.BusinessEntityContact
DROP TABLE IF EXISTS dbo.ContactType
DROP TABLE IF EXISTS dbo.EmployeeDepartmentHistory
DROP TABLE IF EXISTS dbo.EmployeePayHistory
DROP TABLE IF EXISTS dbo.PersonPhone
DROP TABLE IF EXISTS dbo.PersonAddress
DROP TABLE IF EXISTS dbo.EmailAddress
DROP TABLE IF EXISTS dbo.Employee
DROP TABLE IF EXISTS dbo.PhoneNumberType
DROP TABLE IF EXISTS dbo.Shift
DROP TABLE IF EXISTS dbo.Address
DROP TABLE IF EXISTS dbo.AddressType
DROP TABLE IF EXISTS dbo.Person
DROP TABLE IF EXISTS dbo.BusinessEntity
DROP TABLE IF EXISTS dbo.Department
DROP TABLE IF EXISTS dbo.StateProvince
DROP TABLE IF EXISTS dbo.CountryRegion

-- saját adattípusok törlése, ha már voltak
DROP TYPE IF EXISTS dbo.AccountNumber
DROP TYPE IF EXISTS dbo.Flag
DROP TYPE IF EXISTS dbo.Name
DROP TYPE IF EXISTS dbo.NameStyle
DROP TYPE IF EXISTS dbo.OrderNumber
DROP TYPE IF EXISTS dbo.Phone

-- Saját adattípusok létrehozása
CREATE TYPE dbo.AccountNumber FROM nvarchar(15) NULL
CREATE TYPE dbo.Flag FROM bit NOT NULL
CREATE TYPE dbo.Name FROM nvarchar(50) NULL
CREATE TYPE dbo.NameStyle FROM bit NOT NULL
CREATE TYPE dbo.OrderNumber FROM nvarchar(25) NULL
CREATE TYPE dbo.Phone FROM nvarchar(25) NULL
GO

-- A sémákat nem kell használni az új adatbázisban, helyette minden a dbo sémába kerül
-- Alternatíva, hogy akkor a szükséges sémákat is létrehozzuk az Employees adatbázisban
-- Az AddExtendedProperty sorokat ki lehet törölni a generált script-bõl.

CREATE TABLE dbo.Person(
	BusinessEntityID int NOT NULL,
	PersonType nchar(2) NOT NULL,
	NameStyle dbo.NameStyle NOT NULL,
	Title nvarchar(8) NULL,
	FirstName dbo.Name NOT NULL,
	MiddleName dbo.Name NULL,
	LastName dbo.Name NOT NULL,
	Suffix nvarchar(10) NULL,
	EmailPromotion int NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL
 CONSTRAINT PK_Person_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID ASC) )
GO

CREATE TABLE dbo.Department(
	DepartmentID smallint IDENTITY(1,1) NOT NULL,
	Name dbo.Name NOT NULL,
	GroupName dbo.Name NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_Department_DepartmentID PRIMARY KEY CLUSTERED (DepartmentID ASC)) 
GO
CREATE TABLE dbo.Employee(
	BusinessEntityID int NOT NULL,
	NationalIDNumber nvarchar(15) NOT NULL,
	LoginID nvarchar(256) NOT NULL,
	OrganizationNode hierarchyid NULL,
	OrganizationLevel  AS (OrganizationNode.GetLevel()),
	JobTitle nvarchar(50) NOT NULL,
	BirthDate date NOT NULL,
	MaritalStatus nchar(1) NOT NULL,
	Gender nchar(1) NOT NULL,
	HireDate date NOT NULL,
	SalariedFlag dbo.Flag NOT NULL,
	VacationHours smallint NOT NULL,
	SickLeaveHours smallint NOT NULL,
	CurrentFlag dbo.Flag NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_Employee_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID ASC))
GO
CREATE TABLE dbo.EmployeeDepartmentHistory(
	BusinessEntityID int NOT NULL,
	DepartmentID smallint NOT NULL,
	ShiftID tinyint NOT NULL,
	StartDate date NOT NULL,
	EndDate date NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID 
	PRIMARY KEY CLUSTERED (BusinessEntityID ASC, StartDate ASC,	DepartmentID ASC, ShiftID ASC)
) 
GO
CREATE TABLE dbo.EmployeePayHistory(
	BusinessEntityID int NOT NULL,
	RateChangeDate datetime NOT NULL,
	Rate money NOT NULL,
	PayFrequency tinyint NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_EmployeePayHistory_BusinessEntityID_RateChangeDate PRIMARY KEY CLUSTERED (BusinessEntityID ASC, RateChangeDate ASC)) 
GO
CREATE TABLE dbo.Shift(
	ShiftID tinyint IDENTITY(1,1) NOT NULL,
	Name dbo.Name NOT NULL,
	StartTime time(7) NOT NULL,
	EndTime time(7) NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_Shift_ShiftID PRIMARY KEY CLUSTERED (ShiftID ASC))
GO
 CREATE TABLE dbo.Address(
	AddressID int IDENTITY(1,1) NOT NULL,
	AddressLine1 nvarchar(60) NOT NULL,
	AddressLine2 nvarchar(60) NULL,
	City nvarchar(30) NOT NULL,
	StateProvinceID int NOT NULL,
	PostalCode nvarchar(15) NOT NULL,
	SpatialLocation geography NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_Address_AddressID PRIMARY KEY CLUSTERED (AddressID ASC)) 
GO
CREATE TABLE dbo.AddressType(
	AddressTypeID int IDENTITY(1,1) NOT NULL,
	Name dbo.Name NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_AddressType_AddressTypeID PRIMARY KEY CLUSTERED (AddressTypeID ASC))
GO
CREATE TABLE dbo.BusinessEntity(
	BusinessEntityID int IDENTITY(1,1) NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_BusinessEntity_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID ASC))
GO
CREATE TABLE dbo.BusinessEntityAddress(
	BusinessEntityID int NOT NULL,
	AddressID int NOT NULL,
	AddressTypeID int NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID 
	PRIMARY KEY CLUSTERED (BusinessEntityID ASC, AddressID ASC,	AddressTypeID ASC))
GO
CREATE TABLE dbo.BusinessEntityContact(
	BusinessEntityID int NOT NULL,
	PersonID int NOT NULL,
	ContactTypeID int NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID 
	PRIMARY KEY CLUSTERED (BusinessEntityID ASC,PersonID ASC,ContactTypeID ASC))
GO
CREATE TABLE dbo.ContactType(
	ContactTypeID int IDENTITY(1,1) NOT NULL,
	Name dbo.Name NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_ContactType_ContactTypeID PRIMARY KEY CLUSTERED (ContactTypeID ASC)
)
GO
CREATE TABLE dbo.CountryRegion(
	CountryRegionCode nvarchar(3) NOT NULL,
	Name dbo.Name NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_CountryRegion_CountryRegionCode PRIMARY KEY CLUSTERED (CountryRegionCode ASC))
GO
CREATE TABLE dbo.EmailAddress(
	BusinessEntityID int NOT NULL,
	EmailAddressID int IDENTITY(1,1) NOT NULL,
	EmailAddress nvarchar(50) NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_EmailAddress_BusinessEntityID_EmailAddressID PRIMARY KEY CLUSTERED (BusinessEntityID ASC, EmailAddressID ASC))
GO
CREATE TABLE dbo.PersonPhone(
	BusinessEntityID int NOT NULL,
	PhoneNumber dbo.Phone NOT NULL,
	PhoneNumberTypeID int NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID 
	PRIMARY KEY CLUSTERED (BusinessEntityID ASC, PhoneNumber ASC, PhoneNumberTypeID ASC))
GO
CREATE TABLE dbo.PhoneNumberType(
	PhoneNumberTypeID int IDENTITY(1,1) NOT NULL,
	Name dbo.Name NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_PhoneNumberType_PhoneNumberTypeID PRIMARY KEY CLUSTERED (PhoneNumberTypeID ASC))
GO
CREATE TABLE dbo.StateProvince(
	StateProvinceID int IDENTITY(1,1) NOT NULL,
	StateProvinceCode nchar(3) NOT NULL,
	CountryRegionCode nvarchar(3) NOT NULL,
	IsOnlyStateProvinceFlag dbo.Flag NOT NULL,
	Name dbo.Name NOT NULL,
	TerritoryID int NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_StateProvince_StateProvinceID PRIMARY KEY CLUSTERED (StateProvinceID ASC))
GO
CREATE TABLE dbo.Product(
	ProductID int IDENTITY(1,1) NOT NULL,
	Name dbo.Name NOT NULL,
	ProductNumber nvarchar(25) NOT NULL,
	MakeFlag dbo.Flag NOT NULL,
	FinishedGoodsFlag dbo.Flag NOT NULL,
	Color nvarchar(15) NULL,
	SafetyStockLevel smallint NOT NULL,
	ReorderPoint smallint NOT NULL,
	StandardCost money NOT NULL,
	ListPrice money NOT NULL,
	Size nvarchar(5) NULL,
	SizeUnitMeasureCode nchar(3) NULL,
	WeightUnitMeasureCode nchar(3) NULL,
	Weight decimal(8, 2) NULL,
	DaysToManufacture int NOT NULL,
	ProductLine nchar(2) NULL,
	Class nchar(2) NULL,
	Style nchar(2) NULL,
	ProductSubcategoryID int NULL,
	ProductModelID int NULL,
	SellStartDate datetime NOT NULL,
	SellEndDate datetime NULL,
	DiscontinuedDate datetime NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_Product_ProductID PRIMARY KEY CLUSTERED (ProductID ASC))
GO
CREATE TABLE dbo.ProductSubcategory(
	ProductSubcategoryID int IDENTITY(1,1) NOT NULL,
	ProductCategoryID int NOT NULL,
	Name dbo.Name NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_ProductSubcategory_ProductSubcategoryID PRIMARY KEY CLUSTERED (ProductSubcategoryID ASC))
GO
CREATE TABLE dbo.ProductCategory(
	ProductCategoryID int IDENTITY(1,1) NOT NULL,
	Name dbo.Name NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_ProductCategory_ProductCategoryID PRIMARY KEY CLUSTERED (ProductCategoryID ASC))
GO
CREATE TABLE dbo.SalesOrderDetail(
	SalesOrderID int NOT NULL,
	SalesOrderDetailID int IDENTITY(1,1) NOT NULL,
	CarrierTrackingNumber nvarchar(25) NULL,
	OrderQty smallint NOT NULL,
	ProductID int NOT NULL,
	SpecialOfferID int NOT NULL,
	UnitPrice money NOT NULL,
	UnitPriceDiscount money NOT NULL,
	LineTotal  AS (isnull((UnitPrice*((1.0)-UnitPriceDiscount))*OrderQty,(0.0))),
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID PRIMARY KEY CLUSTERED (SalesOrderID ASC,SalesOrderDetailID ASC)) ON SalesData
GO
CREATE TABLE dbo.SalesOrderHeader(
	SalesOrderID int IDENTITY(1,1) NOT NULL,
	RevisionNumber tinyint NOT NULL,
	OrderDate datetime NOT NULL,
	DueDate datetime NOT NULL,
	ShipDate datetime NULL,
	Status tinyint NOT NULL,
	OnlineOrderFlag dbo.Flag NOT NULL,
	SalesOrderNumber  AS (isnull(N'SO'+CONVERT(nvarchar(23),SalesOrderID),N'*** ERROR ***')),
	PurchaseOrderNumber dbo.OrderNumber NULL,
	AccountNumber dbo.AccountNumber NULL,
	CustomerID int NOT NULL,
	SalesPersonID int NULL,
	TerritoryID int NULL,
	BillToAddressID int NOT NULL,
	ShipToAddressID int NOT NULL,
	ShipMethodID int NOT NULL,
	CreditCardID int NULL,
	CreditCardApprovalCode varchar(15) NULL,
	CurrencyRateID int NULL,
	SubTotal money NOT NULL,
	TaxAmt money NOT NULL,
	Freight money NOT NULL,
	TotalDue  AS (isnull((SubTotal+TaxAmt)+Freight,(0))),
	Comment nvarchar(128) NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_SalesOrderHeader_SalesOrderID PRIMARY KEY CLUSTERED (SalesOrderID ASC)) ON SalesData
GO
CREATE TABLE dbo.UnitMeasure(
	UnitMeasureCode nchar(3) NOT NULL,
	Name dbo.Name NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_UnitMeasure_UnitMeasureCode PRIMARY KEY CLUSTERED (UnitMeasureCode ASC))
GO
CREATE TABLE dbo.ProductVendor(
	ProductID int NOT NULL,
	BusinessEntityID int NOT NULL,
	AverageLeadTime int NOT NULL,
	StandardPrice money NOT NULL,
	LastReceiptCost money NULL,
	LastReceiptDate datetime NULL,
	MinOrderQty int NOT NULL,
	MaxOrderQty int NOT NULL,
	OnOrderQty int NULL,
	UnitMeasureCode nchar(3) NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_ProductVendor_ProductID_BusinessEntityID PRIMARY KEY CLUSTERED (ProductID ASC,BusinessEntityID ASC))
GO
CREATE TABLE dbo.PurchaseOrderDetail(
	PurchaseOrderID int NOT NULL,
	PurchaseOrderDetailID int IDENTITY(1,1) NOT NULL,
	DueDate datetime NOT NULL,
	OrderQty smallint NOT NULL,
	ProductID int NOT NULL,
	UnitPrice money NOT NULL,
	LineTotal  AS (isnull(OrderQty*UnitPrice,(0.00))),
	ReceivedQty decimal(8, 2) NOT NULL,
	RejectedQty decimal(8, 2) NOT NULL,
	StockedQty  AS (isnull(ReceivedQty-RejectedQty,(0.00))),
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID 
	PRIMARY KEY CLUSTERED (PurchaseOrderID ASC,PurchaseOrderDetailID ASC)) ON SalesData
GO
CREATE TABLE dbo.PurchaseOrderHeader(
	PurchaseOrderID int IDENTITY(1,1) NOT NULL,
	RevisionNumber tinyint NOT NULL,
	Status tinyint NOT NULL,
	EmployeeID int NOT NULL,
	VendorID int NOT NULL,
	ShipMethodID int NOT NULL,
	OrderDate datetime NOT NULL,
	ShipDate datetime NULL,
	SubTotal money NOT NULL,
	TaxAmt money NOT NULL,
	Freight money NOT NULL,
	TotalDue  AS (isnull((SubTotal+TaxAmt)+Freight,(0))) PERSISTED NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_PurchaseOrderHeader_PurchaseOrderID PRIMARY KEY CLUSTERED (PurchaseOrderID ASC)) ON SalesData
GO
CREATE TABLE dbo.ShipMethod(
	ShipMethodID int IDENTITY(1,1) NOT NULL,
	Name dbo.Name NOT NULL,
	ShipBase money NOT NULL,
	ShipRate money NOT NULL,
	rowguid uniqueidentifier ROWGUIDCOL  NOT NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_ShipMethod_ShipMethodID PRIMARY KEY CLUSTERED (ShipMethodID ASC))
GO
CREATE TABLE dbo.Vendor(
	BusinessEntityID int NOT NULL,
	AccountNumber dbo.AccountNumber NOT NULL,
	Name dbo.Name NOT NULL,
	CreditRating tinyint NOT NULL,
	PreferredVendorStatus dbo.Flag NOT NULL,
	ActiveFlag dbo.Flag NOT NULL,
	PurchasingWebServiceURL nvarchar(1024) NULL,
	ModifiedDate datetime NOT NULL,
 CONSTRAINT PK_Vendor_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID ASC))
GO
ALTER TABLE dbo.Department ADD  CONSTRAINT DF_Department_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.Employee ADD  CONSTRAINT DF_Employee_SalariedFlag  DEFAULT ((1)) FOR SalariedFlag
GO
ALTER TABLE dbo.Employee ADD  CONSTRAINT DF_Employee_VacationHours  DEFAULT ((0)) FOR VacationHours
GO
ALTER TABLE dbo.Employee ADD  CONSTRAINT DF_Employee_SickLeaveHours  DEFAULT ((0)) FOR SickLeaveHours
GO
ALTER TABLE dbo.Employee ADD  CONSTRAINT DF_Employee_CurrentFlag  DEFAULT ((1)) FOR CurrentFlag
GO
ALTER TABLE dbo.Employee ADD  CONSTRAINT DF_Employee_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.Employee ADD  CONSTRAINT DF_Employee_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.EmployeeDepartmentHistory ADD  CONSTRAINT DF_EmployeeDepartmentHistory_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.EmployeePayHistory ADD  CONSTRAINT DF_EmployeePayHistory_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.Address ADD  CONSTRAINT DF_Address_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.Address ADD  CONSTRAINT DF_Address_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.AddressType ADD  CONSTRAINT DF_AddressType_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.AddressType ADD  CONSTRAINT DF_AddressType_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.BusinessEntity ADD  CONSTRAINT DF_BusinessEntity_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.BusinessEntity ADD  CONSTRAINT DF_BusinessEntity_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.BusinessEntityAddress ADD  CONSTRAINT DF_BusinessEntityAddress_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.BusinessEntityAddress ADD  CONSTRAINT DF_BusinessEntityAddress_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.BusinessEntityContact ADD  CONSTRAINT DF_BusinessEntityContact_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.BusinessEntityContact ADD  CONSTRAINT DF_BusinessEntityContact_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.ContactType ADD  CONSTRAINT DF_ContactType_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.CountryRegion ADD  CONSTRAINT DF_CountryRegion_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.EmailAddress ADD  CONSTRAINT DF_EmailAddress_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.EmailAddress ADD  CONSTRAINT DF_EmailAddress_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.Person ADD  CONSTRAINT DF_Person_NameStyle  DEFAULT ((0)) FOR NameStyle
GO
ALTER TABLE dbo.Person ADD  CONSTRAINT DF_Person_EmailPromotion  DEFAULT ((0)) FOR EmailPromotion
GO
ALTER TABLE dbo.Person ADD  CONSTRAINT DF_Person_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.Person ADD  CONSTRAINT DF_Person_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.PersonPhone ADD  CONSTRAINT DF_PersonPhone_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.PhoneNumberType ADD  CONSTRAINT DF_PhoneNumberType_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.StateProvince ADD  CONSTRAINT DF_StateProvince_IsOnlyStateProvinceFlag  DEFAULT ((1)) FOR IsOnlyStateProvinceFlag
GO
ALTER TABLE dbo.StateProvince ADD  CONSTRAINT DF_StateProvince_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.StateProvince ADD  CONSTRAINT DF_StateProvince_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.Product ADD  CONSTRAINT DF_Product_MakeFlag  DEFAULT ((1)) FOR MakeFlag
GO
ALTER TABLE dbo.Product ADD  CONSTRAINT DF_Product_FinishedGoodsFlag  DEFAULT ((1)) FOR FinishedGoodsFlag
GO
ALTER TABLE dbo.Product ADD  CONSTRAINT DF_Product_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.Product ADD  CONSTRAINT DF_Product_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.ProductCategory ADD  CONSTRAINT DF_ProductCategory_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.ProductCategory ADD  CONSTRAINT DF_ProductCategory_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.ProductSubcategory ADD  CONSTRAINT DF_ProductSubcategory_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.ProductSubcategory ADD  CONSTRAINT DF_ProductSubcategory_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.SalesOrderDetail ADD  CONSTRAINT DF_SalesOrderDetail_UnitPriceDiscount  DEFAULT ((0.0)) FOR UnitPriceDiscount
GO
ALTER TABLE dbo.SalesOrderDetail ADD  CONSTRAINT DF_SalesOrderDetail_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.SalesOrderDetail ADD  CONSTRAINT DF_SalesOrderDetail_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_RevisionNumber  DEFAULT ((0)) FOR RevisionNumber
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_OrderDate  DEFAULT (getdate()) FOR OrderDate
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_Status  DEFAULT ((1)) FOR Status
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_OnlineOrderFlag  DEFAULT ((1)) FOR OnlineOrderFlag
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_SubTotal  DEFAULT ((0.00)) FOR SubTotal
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_TaxAmt  DEFAULT ((0.00)) FOR TaxAmt
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_Freight  DEFAULT ((0.00)) FOR Freight
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.SalesOrderHeader ADD  CONSTRAINT DF_SalesOrderHeader_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.Employee  WITH CHECK ADD  CONSTRAINT FK_Employee_Person_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.Person (BusinessEntityID)
GO
ALTER TABLE dbo.Employee CHECK CONSTRAINT FK_Employee_Person_BusinessEntityID
GO
ALTER TABLE dbo.EmployeeDepartmentHistory  WITH CHECK ADD  CONSTRAINT FK_EmployeeDepartmentHistory_Department_DepartmentID FOREIGN KEY(DepartmentID)
REFERENCES dbo.Department (DepartmentID)
GO
ALTER TABLE dbo.EmployeeDepartmentHistory CHECK CONSTRAINT FK_EmployeeDepartmentHistory_Department_DepartmentID
GO
ALTER TABLE dbo.EmployeeDepartmentHistory  WITH CHECK ADD  CONSTRAINT FK_EmployeeDepartmentHistory_Employee_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.Employee (BusinessEntityID)
GO
ALTER TABLE dbo.EmployeeDepartmentHistory CHECK CONSTRAINT FK_EmployeeDepartmentHistory_Employee_BusinessEntityID
GO
ALTER TABLE dbo.EmployeeDepartmentHistory  WITH CHECK ADD  CONSTRAINT FK_EmployeeDepartmentHistory_Shift_ShiftID FOREIGN KEY(ShiftID)
REFERENCES dbo.Shift (ShiftID)
GO
ALTER TABLE dbo.EmployeeDepartmentHistory CHECK CONSTRAINT FK_EmployeeDepartmentHistory_Shift_ShiftID
GO
ALTER TABLE dbo.EmployeePayHistory  WITH CHECK ADD  CONSTRAINT FK_EmployeePayHistory_Employee_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.Employee (BusinessEntityID)
GO
ALTER TABLE dbo.EmployeePayHistory CHECK CONSTRAINT FK_EmployeePayHistory_Employee_BusinessEntityID
GO
ALTER TABLE dbo.Address  WITH CHECK ADD  CONSTRAINT FK_Address_StateProvince_StateProvinceID FOREIGN KEY(StateProvinceID)
REFERENCES dbo.StateProvince (StateProvinceID)
GO
ALTER TABLE dbo.Address CHECK CONSTRAINT FK_Address_StateProvince_StateProvinceID
GO
ALTER TABLE dbo.BusinessEntityAddress  WITH CHECK ADD  CONSTRAINT FK_BusinessEntityAddress_Address_AddressID FOREIGN KEY(AddressID)
REFERENCES dbo.Address (AddressID)
GO
ALTER TABLE dbo.BusinessEntityAddress CHECK CONSTRAINT FK_BusinessEntityAddress_Address_AddressID
GO
ALTER TABLE dbo.BusinessEntityAddress  WITH CHECK ADD  CONSTRAINT FK_BusinessEntityAddress_AddressType_AddressTypeID FOREIGN KEY(AddressTypeID)
REFERENCES dbo.AddressType (AddressTypeID)
GO
ALTER TABLE dbo.BusinessEntityAddress CHECK CONSTRAINT FK_BusinessEntityAddress_AddressType_AddressTypeID
GO
ALTER TABLE dbo.BusinessEntityAddress  WITH CHECK ADD  CONSTRAINT FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.BusinessEntity (BusinessEntityID)
GO
ALTER TABLE dbo.BusinessEntityAddress CHECK CONSTRAINT FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID
GO
ALTER TABLE dbo.BusinessEntityContact  WITH CHECK ADD  CONSTRAINT FK_BusinessEntityContact_BusinessEntity_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.BusinessEntity (BusinessEntityID)
GO
ALTER TABLE dbo.BusinessEntityContact CHECK CONSTRAINT FK_BusinessEntityContact_BusinessEntity_BusinessEntityID
GO
ALTER TABLE dbo.BusinessEntityContact  WITH CHECK ADD  CONSTRAINT FK_BusinessEntityContact_ContactType_ContactTypeID FOREIGN KEY(ContactTypeID)
REFERENCES dbo.ContactType (ContactTypeID)
GO
ALTER TABLE dbo.BusinessEntityContact CHECK CONSTRAINT FK_BusinessEntityContact_ContactType_ContactTypeID
GO
ALTER TABLE dbo.BusinessEntityContact  WITH CHECK ADD  CONSTRAINT FK_BusinessEntityContact_Person_PersonID FOREIGN KEY(PersonID)
REFERENCES dbo.Person (BusinessEntityID)
GO
ALTER TABLE dbo.BusinessEntityContact CHECK CONSTRAINT FK_BusinessEntityContact_Person_PersonID
GO
ALTER TABLE dbo.EmailAddress  WITH CHECK ADD  CONSTRAINT FK_EmailAddress_Person_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.Person (BusinessEntityID)
GO
ALTER TABLE dbo.EmailAddress CHECK CONSTRAINT FK_EmailAddress_Person_BusinessEntityID
GO
ALTER TABLE dbo.Person  WITH CHECK ADD  CONSTRAINT FK_Person_BusinessEntity_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.BusinessEntity (BusinessEntityID)
GO
ALTER TABLE dbo.Person CHECK CONSTRAINT FK_Person_BusinessEntity_BusinessEntityID
GO
ALTER TABLE dbo.PersonPhone  WITH CHECK ADD  CONSTRAINT FK_PersonPhone_Person_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.Person (BusinessEntityID)
GO
ALTER TABLE dbo.PersonPhone CHECK CONSTRAINT FK_PersonPhone_Person_BusinessEntityID
GO
ALTER TABLE dbo.PersonPhone  WITH CHECK ADD  CONSTRAINT FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID FOREIGN KEY(PhoneNumberTypeID)
REFERENCES dbo.PhoneNumberType (PhoneNumberTypeID)
GO
ALTER TABLE dbo.PersonPhone CHECK CONSTRAINT FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID
GO
ALTER TABLE dbo.StateProvince  WITH CHECK ADD  CONSTRAINT FK_StateProvince_CountryRegion_CountryRegionCode FOREIGN KEY(CountryRegionCode)
REFERENCES dbo.CountryRegion (CountryRegionCode)
GO
ALTER TABLE dbo.StateProvince CHECK CONSTRAINT FK_StateProvince_CountryRegion_CountryRegionCode
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT FK_Product_ProductSubcategory_ProductSubcategoryID FOREIGN KEY(ProductSubcategoryID)
REFERENCES dbo.ProductSubcategory (ProductSubcategoryID)
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT FK_Product_ProductSubcategory_ProductSubcategoryID
GO
ALTER TABLE dbo.ProductSubcategory  WITH CHECK ADD  CONSTRAINT FK_ProductSubcategory_ProductCategory_ProductCategoryID FOREIGN KEY(ProductCategoryID)
REFERENCES dbo.ProductCategory (ProductCategoryID)
GO
ALTER TABLE dbo.ProductSubcategory CHECK CONSTRAINT FK_ProductSubcategory_ProductCategory_ProductCategoryID
GO
ALTER TABLE dbo.SalesOrderDetail  WITH CHECK ADD  CONSTRAINT FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID FOREIGN KEY(SalesOrderID)
REFERENCES dbo.SalesOrderHeader (SalesOrderID)
ON DELETE CASCADE
GO
ALTER TABLE dbo.SalesOrderDetail CHECK CONSTRAINT FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID
GO
ALTER TABLE dbo.SalesOrderHeader  WITH CHECK ADD  CONSTRAINT FK_SalesOrderHeader_Address_BillToAddressID FOREIGN KEY(BillToAddressID)
REFERENCES dbo.Address (AddressID)
GO
ALTER TABLE dbo.SalesOrderHeader CHECK CONSTRAINT FK_SalesOrderHeader_Address_BillToAddressID
GO
ALTER TABLE dbo.SalesOrderHeader  WITH CHECK ADD  CONSTRAINT FK_SalesOrderHeader_Address_ShipToAddressID FOREIGN KEY(ShipToAddressID)
REFERENCES dbo.Address (AddressID)
GO
ALTER TABLE dbo.SalesOrderHeader CHECK CONSTRAINT FK_SalesOrderHeader_Address_ShipToAddressID
GO
ALTER TABLE dbo.Employee  WITH CHECK ADD  CONSTRAINT CK_Employee_BirthDate CHECK  ((BirthDate>='1930-01-01' AND BirthDate<=dateadd(year,(-18),getdate())))
GO
ALTER TABLE dbo.Employee CHECK CONSTRAINT CK_Employee_BirthDate
GO
ALTER TABLE dbo.Employee  WITH CHECK ADD  CONSTRAINT CK_Employee_Gender CHECK  ((upper(Gender)='F' OR upper(Gender)='M'))
GO
ALTER TABLE dbo.Employee CHECK CONSTRAINT CK_Employee_Gender
GO
ALTER TABLE dbo.Employee  WITH CHECK ADD  CONSTRAINT CK_Employee_HireDate CHECK  ((HireDate>='1996-07-01' AND HireDate<=dateadd(day,(1),getdate())))
GO
ALTER TABLE dbo.Employee CHECK CONSTRAINT CK_Employee_HireDate
GO
ALTER TABLE dbo.Employee  WITH CHECK ADD  CONSTRAINT CK_Employee_MaritalStatus CHECK  ((upper(MaritalStatus)='S' OR upper(MaritalStatus)='M'))
GO
ALTER TABLE dbo.Employee CHECK CONSTRAINT CK_Employee_MaritalStatus
GO
ALTER TABLE dbo.Employee  WITH CHECK ADD  CONSTRAINT CK_Employee_SickLeaveHours CHECK  ((SickLeaveHours>=(0) AND SickLeaveHours<=(120)))
GO
ALTER TABLE dbo.Employee CHECK CONSTRAINT CK_Employee_SickLeaveHours
GO
ALTER TABLE dbo.Employee  WITH CHECK ADD  CONSTRAINT CK_Employee_VacationHours CHECK  ((VacationHours>=(-40) AND VacationHours<=(240)))
GO
ALTER TABLE dbo.Employee CHECK CONSTRAINT CK_Employee_VacationHours
GO
ALTER TABLE dbo.EmployeeDepartmentHistory  WITH CHECK ADD  CONSTRAINT CK_EmployeeDepartmentHistory_EndDate CHECK  ((EndDate>=StartDate OR EndDate IS NULL))
GO
ALTER TABLE dbo.EmployeeDepartmentHistory CHECK CONSTRAINT CK_EmployeeDepartmentHistory_EndDate
GO
ALTER TABLE dbo.EmployeePayHistory  WITH CHECK ADD  CONSTRAINT CK_EmployeePayHistory_PayFrequency CHECK  ((PayFrequency=(2) OR PayFrequency=(1)))
GO
ALTER TABLE dbo.EmployeePayHistory CHECK CONSTRAINT CK_EmployeePayHistory_PayFrequency
GO
ALTER TABLE dbo.EmployeePayHistory  WITH CHECK ADD  CONSTRAINT CK_EmployeePayHistory_Rate CHECK  ((Rate>=(6.50) AND Rate<=(200.00)))
GO
ALTER TABLE dbo.EmployeePayHistory CHECK CONSTRAINT CK_EmployeePayHistory_Rate
GO
ALTER TABLE dbo.Person  WITH CHECK ADD  CONSTRAINT CK_Person_EmailPromotion CHECK  ((EmailPromotion>=(0) AND EmailPromotion<=(2)))
GO
ALTER TABLE dbo.Person CHECK CONSTRAINT CK_Person_EmailPromotion
GO
ALTER TABLE dbo.Person  WITH CHECK ADD  CONSTRAINT CK_Person_PersonType CHECK  ((PersonType IS NULL OR (upper(PersonType)='GC' OR upper(PersonType)='SP' OR upper(PersonType)='EM' OR upper(PersonType)='IN' OR upper(PersonType)='VC' OR upper(PersonType)='SC')))
GO
ALTER TABLE dbo.Person CHECK CONSTRAINT CK_Person_PersonType
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_Class CHECK  ((upper(Class)='H' OR upper(Class)='M' OR upper(Class)='L' OR Class IS NULL))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_Class
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_DaysToManufacture CHECK  ((DaysToManufacture>=(0)))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_DaysToManufacture
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_ListPrice CHECK  ((ListPrice>=(0.00)))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_ListPrice
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_ProductLine CHECK  ((upper(ProductLine)='R' OR upper(ProductLine)='M' OR upper(ProductLine)='T' OR upper(ProductLine)='S' OR ProductLine IS NULL))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_ProductLine
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_ReorderPoint CHECK  ((ReorderPoint>(0)))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_ReorderPoint
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_SafetyStockLevel CHECK  ((SafetyStockLevel>(0)))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_SafetyStockLevel
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_SellEndDate CHECK  ((SellEndDate>=SellStartDate OR SellEndDate IS NULL))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_SellEndDate
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_StandardCost CHECK  ((StandardCost>=(0.00)))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_StandardCost
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_Style CHECK  ((upper(Style)='U' OR upper(Style)='M' OR upper(Style)='W' OR Style IS NULL))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_Style
GO
ALTER TABLE dbo.Product  WITH CHECK ADD  CONSTRAINT CK_Product_Weight CHECK  ((Weight>(0.00)))
GO
ALTER TABLE dbo.Product CHECK CONSTRAINT CK_Product_Weight
GO
ALTER TABLE dbo.SalesOrderDetail  WITH CHECK ADD  CONSTRAINT CK_SalesOrderDetail_OrderQty CHECK  ((OrderQty>(0)))
GO
ALTER TABLE dbo.SalesOrderDetail CHECK CONSTRAINT CK_SalesOrderDetail_OrderQty
GO
ALTER TABLE dbo.SalesOrderDetail  WITH CHECK ADD  CONSTRAINT CK_SalesOrderDetail_UnitPrice CHECK  ((UnitPrice>=(0.00)))
GO
ALTER TABLE dbo.SalesOrderDetail CHECK CONSTRAINT CK_SalesOrderDetail_UnitPrice
GO
ALTER TABLE dbo.SalesOrderDetail  WITH CHECK ADD  CONSTRAINT CK_SalesOrderDetail_UnitPriceDiscount CHECK  ((UnitPriceDiscount>=(0.00)))
GO
ALTER TABLE dbo.SalesOrderDetail CHECK CONSTRAINT CK_SalesOrderDetail_UnitPriceDiscount
GO
ALTER TABLE dbo.SalesOrderHeader  WITH CHECK ADD  CONSTRAINT CK_SalesOrderHeader_DueDate CHECK  ((DueDate>=OrderDate))
GO
ALTER TABLE dbo.SalesOrderHeader CHECK CONSTRAINT CK_SalesOrderHeader_DueDate
GO
ALTER TABLE dbo.SalesOrderHeader  WITH CHECK ADD  CONSTRAINT CK_SalesOrderHeader_Freight CHECK  ((Freight>=(0.00)))
GO
ALTER TABLE dbo.SalesOrderHeader CHECK CONSTRAINT CK_SalesOrderHeader_Freight
GO
ALTER TABLE dbo.SalesOrderHeader  WITH CHECK ADD  CONSTRAINT CK_SalesOrderHeader_ShipDate CHECK  ((ShipDate>=OrderDate OR ShipDate IS NULL))
GO
ALTER TABLE dbo.SalesOrderHeader CHECK CONSTRAINT CK_SalesOrderHeader_ShipDate
GO
ALTER TABLE dbo.SalesOrderHeader  WITH CHECK ADD  CONSTRAINT CK_SalesOrderHeader_Status CHECK  ((Status>=(0) AND Status<=(8)))
GO
ALTER TABLE dbo.SalesOrderHeader CHECK CONSTRAINT CK_SalesOrderHeader_Status
GO
ALTER TABLE dbo.SalesOrderHeader  WITH CHECK ADD  CONSTRAINT CK_SalesOrderHeader_SubTotal CHECK  ((SubTotal>=(0.00)))
GO
ALTER TABLE dbo.SalesOrderHeader CHECK CONSTRAINT CK_SalesOrderHeader_SubTotal
GO
ALTER TABLE dbo.SalesOrderHeader  WITH CHECK ADD  CONSTRAINT CK_SalesOrderHeader_TaxAmt CHECK  ((TaxAmt>=(0.00)))
GO
ALTER TABLE dbo.SalesOrderHeader CHECK CONSTRAINT CK_SalesOrderHeader_TaxAmt
GO
ALTER TABLE dbo.UnitMeasure ADD  CONSTRAINT DF_UnitMeasure_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.ProductVendor ADD  CONSTRAINT DF_ProductVendor_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.PurchaseOrderDetail ADD  CONSTRAINT DF_PurchaseOrderDetail_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.PurchaseOrderHeader ADD  CONSTRAINT DF_PurchaseOrderHeader_RevisionNumber  DEFAULT ((0)) FOR RevisionNumber
GO
ALTER TABLE dbo.PurchaseOrderHeader ADD  CONSTRAINT DF_PurchaseOrderHeader_Status  DEFAULT ((1)) FOR Status
GO
ALTER TABLE dbo.PurchaseOrderHeader ADD  CONSTRAINT DF_PurchaseOrderHeader_OrderDate  DEFAULT (getdate()) FOR OrderDate
GO
ALTER TABLE dbo.PurchaseOrderHeader ADD  CONSTRAINT DF_PurchaseOrderHeader_SubTotal  DEFAULT ((0.00)) FOR SubTotal
GO
ALTER TABLE dbo.PurchaseOrderHeader ADD  CONSTRAINT DF_PurchaseOrderHeader_TaxAmt  DEFAULT ((0.00)) FOR TaxAmt
GO
ALTER TABLE dbo.PurchaseOrderHeader ADD  CONSTRAINT DF_PurchaseOrderHeader_Freight  DEFAULT ((0.00)) FOR Freight
GO
ALTER TABLE dbo.PurchaseOrderHeader ADD  CONSTRAINT DF_PurchaseOrderHeader_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.ShipMethod ADD  CONSTRAINT DF_ShipMethod_ShipBase  DEFAULT ((0.00)) FOR ShipBase
GO
ALTER TABLE dbo.ShipMethod ADD  CONSTRAINT DF_ShipMethod_ShipRate  DEFAULT ((0.00)) FOR ShipRate
GO
ALTER TABLE dbo.ShipMethod ADD  CONSTRAINT DF_ShipMethod_rowguid  DEFAULT (newid()) FOR rowguid
GO
ALTER TABLE dbo.ShipMethod ADD  CONSTRAINT DF_ShipMethod_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.Vendor ADD  CONSTRAINT DF_Vendor_PreferredVendorStatus  DEFAULT ((1)) FOR PreferredVendorStatus
GO
ALTER TABLE dbo.Vendor ADD  CONSTRAINT DF_Vendor_ActiveFlag  DEFAULT ((1)) FOR ActiveFlag
GO
ALTER TABLE dbo.Vendor ADD  CONSTRAINT DF_Vendor_ModifiedDate  DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT FK_ProductVendor_Product_ProductID FOREIGN KEY(ProductID)
REFERENCES dbo.Product (ProductID)
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT FK_ProductVendor_Product_ProductID
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT FK_ProductVendor_UnitMeasure_UnitMeasureCode FOREIGN KEY(UnitMeasureCode)
REFERENCES dbo.UnitMeasure (UnitMeasureCode)
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT FK_ProductVendor_UnitMeasure_UnitMeasureCode
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT FK_ProductVendor_Vendor_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.Vendor (BusinessEntityID)
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT FK_ProductVendor_Vendor_BusinessEntityID
GO
ALTER TABLE dbo.PurchaseOrderDetail  WITH CHECK ADD  CONSTRAINT FK_PurchaseOrderDetail_Product_ProductID FOREIGN KEY(ProductID)
REFERENCES dbo.Product (ProductID)
GO
ALTER TABLE dbo.PurchaseOrderDetail CHECK CONSTRAINT FK_PurchaseOrderDetail_Product_ProductID
GO
ALTER TABLE dbo.PurchaseOrderDetail  WITH CHECK ADD  CONSTRAINT FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID FOREIGN KEY(PurchaseOrderID)
REFERENCES dbo.PurchaseOrderHeader (PurchaseOrderID)
GO
ALTER TABLE dbo.PurchaseOrderDetail CHECK CONSTRAINT FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID
GO
ALTER TABLE dbo.PurchaseOrderHeader  WITH CHECK ADD  CONSTRAINT FK_PurchaseOrderHeader_Employee_EmployeeID FOREIGN KEY(EmployeeID)
REFERENCES dbo.Employee (BusinessEntityID)
GO
ALTER TABLE dbo.PurchaseOrderHeader CHECK CONSTRAINT FK_PurchaseOrderHeader_Employee_EmployeeID
GO
ALTER TABLE dbo.PurchaseOrderHeader  WITH CHECK ADD  CONSTRAINT FK_PurchaseOrderHeader_ShipMethod_ShipMethodID FOREIGN KEY(ShipMethodID)
REFERENCES dbo.ShipMethod (ShipMethodID)
GO
ALTER TABLE dbo.PurchaseOrderHeader CHECK CONSTRAINT FK_PurchaseOrderHeader_ShipMethod_ShipMethodID
GO
ALTER TABLE dbo.PurchaseOrderHeader  WITH CHECK ADD  CONSTRAINT FK_PurchaseOrderHeader_Vendor_VendorID FOREIGN KEY(VendorID)
REFERENCES dbo.Vendor (BusinessEntityID)
GO
ALTER TABLE dbo.PurchaseOrderHeader CHECK CONSTRAINT FK_PurchaseOrderHeader_Vendor_VendorID
GO
ALTER TABLE dbo.Vendor  WITH CHECK ADD  CONSTRAINT FK_Vendor_BusinessEntity_BusinessEntityID FOREIGN KEY(BusinessEntityID)
REFERENCES dbo.BusinessEntity (BusinessEntityID)
GO
ALTER TABLE dbo.Vendor CHECK CONSTRAINT FK_Vendor_BusinessEntity_BusinessEntityID
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT CK_ProductVendor_AverageLeadTime CHECK  ((AverageLeadTime>=(1)))
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT CK_ProductVendor_AverageLeadTime
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT CK_ProductVendor_LastReceiptCost CHECK  ((LastReceiptCost>(0.00)))
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT CK_ProductVendor_LastReceiptCost
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT CK_ProductVendor_MaxOrderQty CHECK  ((MaxOrderQty>=(1)))
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT CK_ProductVendor_MaxOrderQty
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT CK_ProductVendor_MinOrderQty CHECK  ((MinOrderQty>=(1)))
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT CK_ProductVendor_MinOrderQty
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT CK_ProductVendor_OnOrderQty CHECK  ((OnOrderQty>=(0)))
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT CK_ProductVendor_OnOrderQty
GO
ALTER TABLE dbo.ProductVendor  WITH CHECK ADD  CONSTRAINT CK_ProductVendor_StandardPrice CHECK  ((StandardPrice>(0.00)))
GO
ALTER TABLE dbo.ProductVendor CHECK CONSTRAINT CK_ProductVendor_StandardPrice
GO
ALTER TABLE dbo.PurchaseOrderDetail  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderDetail_OrderQty CHECK  ((OrderQty>(0)))
GO
ALTER TABLE dbo.PurchaseOrderDetail CHECK CONSTRAINT CK_PurchaseOrderDetail_OrderQty
GO
ALTER TABLE dbo.PurchaseOrderDetail  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderDetail_ReceivedQty CHECK  ((ReceivedQty>=(0.00)))
GO
ALTER TABLE dbo.PurchaseOrderDetail CHECK CONSTRAINT CK_PurchaseOrderDetail_ReceivedQty
GO
ALTER TABLE dbo.PurchaseOrderDetail  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderDetail_RejectedQty CHECK  ((RejectedQty>=(0.00)))
GO
ALTER TABLE dbo.PurchaseOrderDetail CHECK CONSTRAINT CK_PurchaseOrderDetail_RejectedQty
GO
ALTER TABLE dbo.PurchaseOrderDetail  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderDetail_UnitPrice CHECK  ((UnitPrice>=(0.00)))
GO
ALTER TABLE dbo.PurchaseOrderDetail CHECK CONSTRAINT CK_PurchaseOrderDetail_UnitPrice
GO
ALTER TABLE dbo.PurchaseOrderHeader  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderHeader_Freight CHECK  ((Freight>=(0.00)))
GO
ALTER TABLE dbo.PurchaseOrderHeader CHECK CONSTRAINT CK_PurchaseOrderHeader_Freight
GO
ALTER TABLE dbo.PurchaseOrderHeader  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderHeader_ShipDate CHECK  ((ShipDate>=OrderDate OR ShipDate IS NULL))
GO
ALTER TABLE dbo.PurchaseOrderHeader CHECK CONSTRAINT CK_PurchaseOrderHeader_ShipDate
GO
ALTER TABLE dbo.PurchaseOrderHeader  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderHeader_Status CHECK  ((Status>=(1) AND Status<=(4)))
GO
ALTER TABLE dbo.PurchaseOrderHeader CHECK CONSTRAINT CK_PurchaseOrderHeader_Status
GO
ALTER TABLE dbo.PurchaseOrderHeader  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderHeader_SubTotal CHECK  ((SubTotal>=(0.00)))
GO
ALTER TABLE dbo.PurchaseOrderHeader CHECK CONSTRAINT CK_PurchaseOrderHeader_SubTotal
GO
ALTER TABLE dbo.PurchaseOrderHeader  WITH CHECK ADD  CONSTRAINT CK_PurchaseOrderHeader_TaxAmt CHECK  ((TaxAmt>=(0.00)))
GO
ALTER TABLE dbo.PurchaseOrderHeader CHECK CONSTRAINT CK_PurchaseOrderHeader_TaxAmt
GO
ALTER TABLE dbo.ShipMethod  WITH CHECK ADD  CONSTRAINT CK_ShipMethod_ShipBase CHECK  ((ShipBase>(0.00)))
GO
ALTER TABLE dbo.ShipMethod CHECK CONSTRAINT CK_ShipMethod_ShipBase
GO
ALTER TABLE dbo.ShipMethod  WITH CHECK ADD  CONSTRAINT CK_ShipMethod_ShipRate CHECK  ((ShipRate>(0.00)))
GO
ALTER TABLE dbo.ShipMethod CHECK CONSTRAINT CK_ShipMethod_ShipRate
GO
ALTER TABLE dbo.Vendor  WITH CHECK ADD  CONSTRAINT CK_Vendor_CreditRating CHECK  ((CreditRating>=(1) AND CreditRating<=(5)))
GO
ALTER TABLE dbo.Vendor CHECK CONSTRAINT CK_Vendor_CreditRating
GO

-- Táblák feltöltése
SET IDENTITY_INSERT dbo.ProductCategory ON
INSERT dbo.ProductCategory (ProductCategoryID, Name, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Production.ProductCategory
SET IDENTITY_INSERT dbo.ProductCategory OFF

SET IDENTITY_INSERT dbo.ProductSubCategory ON
INSERT dbo.ProductSubCategory (ProductSubcategoryID, ProductCategoryID, Name, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Production.ProductSubCategory
SET IDENTITY_INSERT dbo.ProductSubCategory OFF

SET IDENTITY_INSERT dbo.Product ON
INSERT dbo.Product (ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, 
	ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, 
	DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, 
	SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Production.Product
SET IDENTITY_INSERT dbo.Product OFF

SET IDENTITY_INSERT dbo.BusinessEntity ON
INSERT dbo.BusinessEntity (BusinessEntityID, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.BusinessEntity
SET IDENTITY_INSERT dbo.BusinessEntity OFF

INSERT dbo.CountryRegion (CountryRegionCode, Name, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.CountryRegion

SET IDENTITY_INSERT dbo.StateProvince ON
INSERT dbo.StateProvince (StateProvinceID, StateProvinceCode, CountryRegionCode, IsOnlyStateProvinceFlag, Name, 
	TerritoryID, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.StateProvince
SET IDENTITY_INSERT dbo.StateProvince OFF

SET IDENTITY_INSERT dbo.Shift ON
INSERT dbo.Shift (ShiftID, Name, StartTime, EndTime, ModifiedDate)
SELECT * FROM AdventureWorks2019.HumanResources.Shift
SET IDENTITY_INSERT dbo.Shift OFF

SET IDENTITY_INSERT dbo.Department ON
INSERT dbo.Department (DepartmentID, Name, GroupName, ModifiedDate)
SELECT * FROM AdventureWorks2019.HumanResources.Department
SET IDENTITY_INSERT dbo.Department OFF

SET IDENTITY_INSERT dbo.ContactType ON
INSERT dbo.ContactType (ContactTypeID, Name, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.ContactType
SET IDENTITY_INSERT dbo.ContactType OFF

SET IDENTITY_INSERT dbo.AddressType ON
INSERT dbo.AddressType (AddressTypeID, Name, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.AddressType
SET IDENTITY_INSERT dbo.AddressType OFF

SET IDENTITY_INSERT dbo.PhoneNumberType ON
INSERT dbo.PhoneNumberType (PhoneNumberTypeID, Name, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.PhoneNumberType
SET IDENTITY_INSERT dbo.PhoneNumberType OFF

INSERT dbo.UnitMeasure (UnitMeasureCode, Name, ModifiedDate)
SELECT * FROM AdventureWorks2019.Production.UnitMeasure

SET IDENTITY_INSERT dbo.ShipMethod ON
INSERT dbo.ShipMethod (ShipMethodID, Name, ShipBase, ShipRate, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Purchasing.ShipMethod 
SET IDENTITY_INSERT dbo.ShipMethod OFF

INSERT dbo.Person (BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, 
	EmailPromotion, rowguid, ModifiedDate)
SELECT BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, 
	EmailPromotion, rowguid, ModifiedDate
FROM AdventureWorks2019.Person.Person

INSERT dbo.Employee (BusinessEntityID, NationalIDNumber, LoginID, OrganizationNode, JobTitle, 
	BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag, VacationHours, SickLeaveHours, 
	CurrentFlag, rowguid, ModifiedDate)
SELECT BusinessEntityID, NationalIDNumber, LoginID, OrganizationNode, JobTitle, 
	BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag, VacationHours, SickLeaveHours, 
	CurrentFlag, rowguid, ModifiedDate
FROM AdventureWorks2019.HumanResources.Employee

SET IDENTITY_INSERT dbo.EmailAddress ON
INSERT dbo.EmailAddress (BusinessEntityID, EmailAddressID, EmailAddress, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.EmailAddress
SET IDENTITY_INSERT dbo.EmailAddress OFF

SET IDENTITY_INSERT dbo.Address ON
INSERT dbo.Address (AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, SpatialLocation, 
	rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.Address
SET IDENTITY_INSERT dbo.Address OFF

INSERT dbo.BusinessEntityAddress (BusinessEntityID, AddressID, AddressTypeID, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.BusinessEntityAddress 

INSERT dbo.BusinessEntityContact (BusinessEntityID, PersonID, ContactTypeID, rowguid, ModifiedDate)
SELECT * FROM AdventureWorks2019.Person.BusinessEntityContact

INSERT dbo.EmployeeDepartmentHistory (BusinessEntityID, DepartmentID, ShiftID, StartDate, EndDate, ModifiedDate)
SELECT * FROM AdventureWorks2019.HumanResources.EmployeeDepartmentHistory  

INSERT dbo.EmployeePayHistory (BusinessEntityID, RateChangeDate, Rate, PayFrequency, ModifiedDate)
SELECT * FROM AdventureWorks2019.HumanResources.EmployeePayHistory

SET IDENTITY_INSERT dbo.SalesOrderHeader ON
INSERT dbo.SalesOrderHeader (SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, Status, OnlineOrderFlag, 
	PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, 
	ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID, SubTotal, TaxAmt, Freight, 
	Comment, rowguid, ModifiedDate)
SELECT SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, Status, OnlineOrderFlag, 
	PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, 
	ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID, SubTotal, TaxAmt, Freight, 
	Comment, rowguid, ModifiedDate
FROM AdventureWorks2019.Sales.SalesOrderHeader
SET IDENTITY_INSERT dbo.SalesOrderHeader OFF

SET IDENTITY_INSERT dbo.SalesOrderDetail ON
INSERT dbo.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, 
	UnitPriceDiscount, rowguid, ModifiedDate)
SELECT SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, 
	rowguid, ModifiedDate
FROM AdventureWorks2019.Sales.SalesOrderDetail
SET IDENTITY_INSERT dbo.SalesOrderDetail OFF

INSERT dbo.Vendor (BusinessEntityID, AccountNumber, Name, CreditRating, PreferredVendorStatus, ActiveFlag, 
	PurchasingWebServiceURL, ModifiedDate)
SELECT * FROM AdventureWorks2019.Purchasing.Vendor

INSERT dbo.ProductVendor (ProductID, BusinessEntityID, AverageLeadTime, StandardPrice, LastReceiptCost, LastReceiptDate, 
	MinOrderQty, MaxOrderQty, OnOrderQty, UnitMeasureCode, ModifiedDate)
SELECT * FROM AdventureWorks2019.Purchasing.ProductVendor

SET IDENTITY_INSERT dbo.PurchaseOrderHeader ON
INSERT dbo.PurchaseOrderHeader (PurchaseOrderID, RevisionNumber, Status, EmployeeID, VendorID, ShipMethodID, OrderDate, ShipDate, 
	SubTotal, TaxAmt, Freight, ModifiedDate)
SELECT PurchaseOrderID, RevisionNumber, Status, EmployeeID, VendorID, ShipMethodID, OrderDate, ShipDate, 
	SubTotal, TaxAmt, Freight, ModifiedDate
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
SET IDENTITY_INSERT dbo.PurchaseOrderHeader OFF

SET IDENTITY_INSERT dbo.PurchaseOrderDetail ON
INSERT dbo.PurchaseOrderDetail (PurchaseOrderID, PurchaseOrderDetailID, DueDate, OrderQty, ProductID, UnitPrice, 
	ReceivedQty, RejectedQty, ModifiedDate)
SELECT PurchaseOrderID, PurchaseOrderDetailID, DueDate, OrderQty, ProductID, UnitPrice, 
	ReceivedQty, RejectedQty, ModifiedDate
FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail
SET IDENTITY_INSERT dbo.PurchaseOrderDetail OFF