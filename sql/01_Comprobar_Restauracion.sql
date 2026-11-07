-- Seleccionar la instancia del motor SQL en SSMS, no la de Analysis Services.
-- Diagnostico de solo lectura. No inicia ni modifica servicios.
SELECT @@SERVERNAME AS Instancia, @@VERSION AS Version;
SELECT name,state_desc FROM sys.databases;
-- Con servidor local, restaurar AdventureWorksDW2022.bak desde el asistente
-- Bases de datos > Restaurar base de datos > Dispositivo > Agregar.
-- Revisar Archivos para evitar sobrescribir bases o archivos existentes.
-- Tras restaurar:
IF DB_ID(N'AdventureWorksDW2022') IS NULL
 THROW 50001, 'Falta restaurar AdventureWorksDW2022 en esta instancia.', 1;
GO
USE [AdventureWorksDW2022];
GO
SELECT name FROM sys.tables ORDER BY name;
SELECT COUNT_BIG(*) AS Lineas FROM dbo.FactInternetSales;
GO
