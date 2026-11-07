USE [AdventureWorksDW2022];
GO
-- Vistas para el cubo.
IF SCHEMA_ID(N'd2') IS NULL EXEC(N'CREATE SCHEMA d2 AUTHORIZATION dbo');
GO
CREATE OR ALTER VIEW d2.Tiempo AS
SELECT DateKey, CalendarYear AS Anio,
 CAST(CalendarYear*10+CalendarQuarter AS int) AS TrimestreKey,
 CAST(CONCAT(CalendarYear,N'-T',CalendarQuarter) AS nvarchar(12)) AS Trimestre,
 CAST(CalendarYear*100+MonthNumberOfYear AS int) AS MesKey,
 CAST(CONCAT(CalendarYear,N'-',RIGHT(N'0'+CONVERT(nvarchar(2),MonthNumberOfYear),2)) AS nvarchar(7)) AS Mes,
 CAST(CONVERT(nvarchar(10),FullDateAlternateKey,23) AS nvarchar(10)) AS Fecha
FROM dbo.DimDate;
GO
CREATE OR ALTER VIEW d2.Producto AS
SELECT p.ProductKey, p.EnglishProductName AS Producto,
 COALESCE(s.ProductSubcategoryKey,-1) AS SubcategoriaKey,
 CAST(COALESCE(s.EnglishProductSubcategoryName,N'Sin subcategoria') AS nvarchar(50)) AS Subcategoria,
 COALESCE(c.ProductCategoryKey,-1) AS CategoriaKey,
 CAST(COALESCE(c.EnglishProductCategoryName,N'Sin categoria') AS nvarchar(50)) AS Categoria
FROM dbo.DimProduct p
LEFT JOIN dbo.DimProductSubcategory s ON s.ProductSubcategoryKey=p.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory c ON c.ProductCategoryKey=s.ProductCategoryKey;
GO
CREATE OR ALTER VIEW d2.Cliente AS
SELECT CustomerKey, CustomerAlternateKey AS Cliente
FROM dbo.DimCustomer;
GO
CREATE OR ALTER VIEW d2.Territorio AS
SELECT SalesTerritoryKey, SalesTerritoryRegion AS Region,
 SalesTerritoryCountry AS Pais, SalesTerritoryGroup AS Grupo
FROM dbo.DimSalesTerritory;
GO
CREATE OR ALTER VIEW d2.Ventas AS
SELECT ProductKey, OrderDateKey, CustomerKey, SalesTerritoryKey,
 SalesOrderNumber, SalesOrderLineNumber, SalesAmount, OrderQuantity,
 DENSE_RANK() OVER (ORDER BY SalesOrderNumber) AS PedidoKey
FROM dbo.FactInternetSales;
GO
-- PedidoKey permite contar pedidos distintos en SSAS.
-- Si cambian los datos, hacer un procesamiento completo; no usar cargas incrementales.
SELECT COUNT_BIG(*) AS Lineas, SUM(SalesAmount) AS Ventas,
 SUM(CONVERT(bigint,OrderQuantity)) AS Unidades,
 COUNT(DISTINCT SalesOrderNumber) AS PedidosOriginales,
 COUNT(DISTINCT PedidoKey) AS PedidosModelo
FROM d2.Ventas;
GO
