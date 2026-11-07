-- Revisado documentalmente; pendiente de ejecutar en la instancia del estudiante.
USE [AdventureWorksDW2022];
GO

-- Q00. Identificar base y confirmar cantidad de filas.
SELECT DB_NAME() AS BaseDeDatosActiva;
SELECT COUNT_BIG(*) AS CantidadFilasFactInternetSales
FROM dbo.FactInternetSales;
GO

-- Q01. Resumen de ventas, unidades y numero de pedidos distintos.
-- Nota: FactInternetSales tiene lineas de pedido; contar filas NO equivale a contar pedidos.
SELECT
    CAST(SUM(f.SalesAmount) AS decimal(18,2)) AS TotalVentas,
    SUM(f.OrderQuantity) AS UnidadesVendidas,
    COUNT(DISTINCT f.SalesOrderNumber) AS PedidosDistintos,
    COUNT_BIG(*) AS LineasDeVenta
FROM dbo.FactInternetSales AS f;
GO

-- Q02. Ventas por anio (fecha de PEDIDO).
SELECT
    d.CalendarYear AS Anio,
    CAST(SUM(f.SalesAmount) AS decimal(18,2)) AS TotalVentas,
    SUM(f.OrderQuantity) AS UnidadesVendidas
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

-- Q03. Ventas por anio y mes, ordenadas cronologicamente.
SELECT
    d.CalendarYear AS Anio,
    d.MonthNumberOfYear AS NumeroMes,
    d.EnglishMonthName AS Mes,
    CAST(SUM(f.SalesAmount) AS decimal(18,2)) AS TotalVentas
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear, d.EnglishMonthName
ORDER BY d.CalendarYear, d.MonthNumberOfYear;
GO

-- Q04. Ventas por pais/territorio.
SELECT
    t.SalesTerritoryCountry AS Pais,
    CAST(SUM(f.SalesAmount) AS decimal(18,2)) AS TotalVentas,
    SUM(f.OrderQuantity) AS UnidadesVendidas
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimSalesTerritory AS t
    ON t.SalesTerritoryKey = f.SalesTerritoryKey
GROUP BY t.SalesTerritoryCountry
ORDER BY TotalVentas DESC;
GO

-- Q05. TOP 10 productos por importe de ventas.
SELECT TOP (10)
    p.ProductKey,
    p.EnglishProductName AS Producto,
    CAST(SUM(f.SalesAmount) AS decimal(18,2)) AS TotalVentas,
    SUM(f.OrderQuantity) AS UnidadesVendidas
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
GROUP BY p.ProductKey, p.EnglishProductName
ORDER BY TotalVentas DESC, Producto ASC, p.ProductKey;
GO

-- Q06. Ventas por categoria de productos.
SELECT
    COALESCE(cat.EnglishProductCategoryName, N'Sin categoria') AS Categoria,
    CAST(SUM(f.SalesAmount) AS decimal(18,2)) AS TotalVentas,
    SUM(f.OrderQuantity) AS UnidadesVendidas
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimProduct AS p
    ON p.ProductKey = f.ProductKey
LEFT JOIN dbo.DimProductSubcategory AS sub
    ON sub.ProductSubcategoryKey = p.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory AS cat
    ON cat.ProductCategoryKey = sub.ProductCategoryKey
GROUP BY cat.EnglishProductCategoryName
ORDER BY TotalVentas DESC;
GO

-- Q07. Cruce anio x pais, util para validar matriz del cubo/Power BI.
SELECT
    d.CalendarYear AS Anio,
    t.SalesTerritoryCountry AS Pais,
    CAST(SUM(f.SalesAmount) AS decimal(18,2)) AS TotalVentas
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
INNER JOIN dbo.DimSalesTerritory AS t
    ON t.SalesTerritoryKey = f.SalesTerritoryKey
GROUP BY d.CalendarYear, t.SalesTerritoryCountry
ORDER BY d.CalendarYear, TotalVentas DESC;
GO

-- Q08. Control basico de calidad (no sustituye validaciones de relaciones).
SELECT
    COUNT_BIG(*) AS FilasDeVentas,
    SUM(CASE WHEN f.SalesAmount IS NULL THEN 1 ELSE 0 END) AS VentasSinImporte,
    SUM(CASE WHEN f.OrderQuantity IS NULL THEN 1 ELSE 0 END) AS VentasSinCantidad,
    SUM(CASE WHEN d.DateKey IS NULL THEN 1 ELSE 0 END) AS FechaPedidoSinDimension,
    SUM(CASE WHEN p.ProductKey IS NULL THEN 1 ELSE 0 END) AS ProductoSinDimension,
    SUM(CASE WHEN t.SalesTerritoryKey IS NULL THEN 1 ELSE 0 END) AS TerritorioSinDimension
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
LEFT JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
LEFT JOIN dbo.DimSalesTerritory AS t ON t.SalesTerritoryKey = f.SalesTerritoryKey;
GO

-- Q09. Validar coherencia entre total y desagregacion anual.
WITH VentasAnuales AS (
    SELECT d.CalendarYear AS Anio, SUM(f.SalesAmount) AS TotalAnual
    FROM dbo.FactInternetSales AS f
    INNER JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
    GROUP BY d.CalendarYear
)
SELECT
    CAST((SELECT SUM(SalesAmount) FROM dbo.FactInternetSales) AS decimal(18,2))
        AS TotalDesdeHechos,
    CAST((SELECT SUM(TotalAnual) FROM VentasAnuales) AS decimal(18,2))
        AS SumaPorAnio,
    CAST(
        (SELECT SUM(SalesAmount) FROM dbo.FactInternetSales)
        - (SELECT SUM(TotalAnual) FROM VentasAnuales)
        AS decimal(18,2)
    ) AS Diferencia;
GO
-- Q10. Version, base y periodo: documentar el entorno real.
SELECT @@VERSION AS VersionSQL, DB_NAME() AS BaseActiva;
SELECT MIN(d.FullDateAlternateKey) AS PrimeraFecha,
       MAX(d.FullDateAlternateKey) AS UltimaFecha
FROM dbo.FactInternetSales f
JOIN dbo.DimDate d ON d.DateKey = f.OrderDateKey;
GO

-- Q11. Clientes distintos y ticket promedio (importe por pedido).
SELECT COUNT(DISTINCT f.CustomerKey) AS ClientesDistintos,
       CAST(SUM(f.SalesAmount) /
       NULLIF(COUNT(DISTINCT f.SalesOrderNumber),0) AS decimal(18,2)) AS TicketPromedio
FROM dbo.FactInternetSales f;
GO

-- Q12. Validar clientes y clasificacion de productos sin perder filas.
SELECT
 SUM(CASE WHEN c.CustomerKey IS NULL THEN 1 ELSE 0 END) AS ClienteSinDimension,
 SUM(CASE WHEN s.ProductSubcategoryKey IS NULL THEN 1 ELSE 0 END) AS SinSubcategoria,
 SUM(CASE WHEN cat.ProductCategoryKey IS NULL THEN 1 ELSE 0 END) AS SinCategoria
FROM dbo.FactInternetSales f
LEFT JOIN dbo.DimCustomer c ON c.CustomerKey=f.CustomerKey
LEFT JOIN dbo.DimProduct p ON p.ProductKey=f.ProductKey
LEFT JOIN dbo.DimProductSubcategory s ON s.ProductSubcategoryKey=p.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory cat ON cat.ProductCategoryKey=s.ProductCategoryKey;
GO

-- Q13. Participacion por pais: mismo contexto que el total general.
WITH Pais AS (
 SELECT t.SalesTerritoryCountry AS Pais, SUM(f.SalesAmount) AS Ventas
 FROM dbo.FactInternetSales f
 JOIN dbo.DimSalesTerritory t ON t.SalesTerritoryKey=f.SalesTerritoryKey
 GROUP BY t.SalesTerritoryCountry
)
SELECT Pais, CAST(Ventas AS decimal(18,2)) AS Ventas,
 CAST(100.0*Ventas/NULLIF(SUM(Ventas) OVER(),0) AS decimal(10,2)) AS Porcentaje
FROM Pais ORDER BY Ventas DESC;
GO

-- Q14. Control del grano: debe devolver cero filas.
SELECT SalesOrderNumber, SalesOrderLineNumber, COUNT_BIG(*) AS Repeticiones
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber, SalesOrderLineNumber
HAVING COUNT_BIG(*) > 1;
GO

