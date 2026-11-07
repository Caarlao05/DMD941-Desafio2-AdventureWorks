# Desafío 2 · AdventureWorksDW2022

Carlos Eduardo Saavedra Vega (SV253275) y Jason Alexander Castro Ascencio (CA152304).

Repositorio: https://github.com/Caarlao05/DMD941-Desafio2-AdventureWorks

## Ejecución verificada

Base local restaurada; vistas SQL creadas; cubo SSAS procesado; proyecto importado, revisado y desplegado desde Visual Studio sin errores; Power BI conectado en vivo y filtro de 2013 probado.

Totales: ventas 29,358,677.2207; unidades 60,398; líneas 60,398; pedidos distintos 27,659; ticket promedio 1,061.45. Power BI redondea ventas a 29,358,677.22. La tabla Top 10 tiene su propio subtotal (10,355,525.92).

## Reproducción

1. Instalar SQL Server 2022 Developer y Analysis Services en modo multidimensional, Visual Studio 2022 con Analysis Services Projects, proveedor MSOLEDBSQL y Power BI Desktop.
2. Descargar AdventureWorksDW2022.bak desde Microsoft y restaurarlo como AdventureWorksDW2022. El respaldo no se incluye.
3. Ejecutar sql/01_Comprobar_Restauracion.sql y sql/02_Vistas_Cubo.sql en el motor localhost. sql/03_Consultas_AdventureWorks.sql contiene análisis y controles adicionales; no todos cuentan con evidencia de ejecución local.
4. Ejecutar sql/04_Permisos_SSAS.sql como administrador del motor para la cuenta de la instancia predeterminada de SSAS. Si la cuenta del servicio es distinta, ajustar el script.
5. Abrir ssas/DMD941_Desafio2/DMD941_Desafio2.sln. Revisar origen de datos e implementación: localhost y DMD941_Desafio2. Implementar y procesar completamente el modelo.
6. Abrir powerbi/VentasInternet.pbix con las credenciales Windows autorizadas en SSAS. La conexión en vivo requiere el servidor disponible; el PBIX no contiene una copia importada de los datos.
7. Comparar los totales y probar el segmentador. Guardar el informe y compartir el enlace del repositorio en el aula digital.

El esquema d2 conserva las tablas originales. PedidoKey usa DENSE_RANK: procesar completamente cuando cambien los datos; no usarlo para cargas incrementales.

El informe final está en informe/Informe_Desafio_2_ampliado.pdf; las evidencias locales están en evidencias/. No se incluyen contraseñas, respaldos ni cachés de Visual Studio en el ZIP final.
