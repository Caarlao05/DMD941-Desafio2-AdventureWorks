SELECT @@SERVERNAME AS Instancia, @@VERSION AS Version;
SELECT name,state_desc FROM sys.databases;
IF DB_ID(N'AdventureWorksDW2022') IS NULL
 THROW 50001, 'Falta restaurar AdventureWorksDW2022 en esta instancia.', 1;
GO
USE [AdventureWorksDW2022];
GO
SELECT name FROM sys.tables ORDER BY name;
SELECT COUNT_BIG(*) AS Lineas FROM dbo.FactInternetSales;
GO
