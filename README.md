# Desafío 2 — AdventureWorks

Proyecto de Datawarehouse y Minería de Datos de la Universidad Don Bosco. Analizamos las ventas por Internet de AdventureWorksDW2022 con SQL Server, un cubo OLAP y Power BI.

**Integrantes:** Carlos Eduardo Saavedra Vega (SV253275) y Jason Alexander Castro Ascencio (CA152304).

## Archivos

- `sql/`: consultas, vistas y permisos para el cubo.
- `ssas/DMD941_Desafio2/`: solución de Visual Studio con el cubo y sus dimensiones.
- `ssas/03_Validaciones.mdx`: consultas para revisar los resultados del cubo.
- `powerbi/VentasInternet.pbix`: informe de ventas.

## Cómo ejecutarlo

Se necesita SQL Server 2022, Analysis Services en modo multidimensional, Visual Studio con Analysis Services Projects, el proveedor MSOLEDBSQL y Power BI Desktop.

1. Restaurar AdventureWorksDW2022.
2. Ejecutar los scripts 01 y 02 de la carpeta `sql`, y el 04 para dar acceso al servicio de Analysis Services. Ajustar la cuenta si se usa otra instancia. El script 03 contiene las consultas de análisis.
3. Abrir `ssas/DMD941_Desafio2/DMD941_Desafio2.sln`, revisar la conexión e implementar en `localhost`, base `DMD941_Desafio2`. Procesar el cubo con la opción completa.
4. Abrir `powerbi/VentasInternet.pbix`. Usa una conexión en vivo, por lo que Analysis Services debe estar en ejecución.

Los totales generales son 29,358,677.22 en ventas, 60,398 unidades y 27,659 pedidos.
