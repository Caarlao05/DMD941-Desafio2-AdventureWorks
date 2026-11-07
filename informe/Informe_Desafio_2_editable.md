# UNIVERSIDAD DON BOSCO

Facultad de Educación a Distancia

Desafío Práctico 2 · Experiencia de Aprendizaje 1

Datawarehouse y Minería de Datos G01T · Ponderación: 20 %

Docente: David Enrique Moya Aguilar

Carlos Eduardo Saavedra Vega · SV253275

Jason Alexander Castro Ascencio · CA152304

Trabajo en pareja autorizado por el docente, según indicación de los estudiantes.

AdventureWorksDW2022 · SQL Server · SSAS multidimensional · Power BI

Fecha de entrega indicada: 6 de noviembre. Documentación final: 7 de noviembre de 2026.

Repositorio: https://github.com/Caarlao05/DMD941-Desafio2-AdventureWorks

# 1. Introducción y objetivos

Se implementó una solución de análisis de ventas por Internet sobre AdventureWorks Data Warehouse. El flujo comprende la restauración local, la preparación de vistas SQL, el cubo multidimensional en Analysis Services, su incorporación y despliegue desde Visual Studio y un informe de Power BI con conexión en vivo.

Objetivo general: implementar y validar un flujo de análisis de ventas desde la base relacional hasta un cubo OLAP y su visualización.

Objetivos específicos: identificar el grano y las variables relevantes; configurar dimensiones, jerarquías y medidas; procesar el cubo; contrastar sus totales con SQL; visualizar tendencias y concentraciones de ventas.

Alcance: FactInternetSales representa líneas de pedidos de Internet. El importe SalesAmount mide ventas, no beneficio neto ni todas las ventas de la empresa.

Preguntas de análisis: ¿cuánto se vendió y cuántos pedidos se atendieron?, ¿cómo evolucionaron las ventas por mes?, ¿qué países, categorías y productos concentran las ventas?, ¿coinciden los totales entre SQL, SSAS y Power BI?

Entorno: SQL Server 2022 Developer, SSMS 22, SSAS 2022 en modo multidimensional, Visual Studio Community 2022 con Microsoft Analysis Services Projects y Power BI Desktop. El motor y Analysis Services usan localhost; son servicios distintos.

Contenido: restauración y SQL (p. 3), modelo (p. 4), despliegue (p. 5), validación (p. 6), Power BI (p. 7), filtros y análisis (p. 8), conclusiones y referencias (p. 9).

# 2. Restauración y consultas SQL

Se restauró AdventureWorksDW2022 a partir del respaldo Data Warehouse de Microsoft. La consulta local de FactInternetSales demuestra que la base está disponible y contiene datos. El respaldo binario se distribuye desde Microsoft y no se incorpora al repositorio.

Se crearon las vistas d2.Tiempo, d2.Producto, d2.Cliente, d2.Territorio y d2.Ventas sin modificar las tablas originales. El script 02_Vistas_Cubo.sql incluye un control de conciliación.

El archivo 03_Consultas_AdventureWorks.sql reúne consultas de evolución temporal, país, producto, categoría y controles de integridad. Las evidencias locales confirman los totales generales y el conteo de pedidos; no se afirma que todos los controles adicionales del archivo hayan sido ejecutados localmente.

Las ventas se agregan con SUM(SalesAmount), las unidades con SUM(OrderQuantity) y los pedidos con COUNT(DISTINCT SalesOrderNumber). COUNT(*) cuenta líneas, por lo que no sustituye al conteo de pedidos.

@Validacion_local_AdventureWorksDW2022.png|Figura 1. Consulta de totales en la base local.

# 3. Diseño del modelo multidimensional

La vista Ventas es el centro de un esquema en estrella. Cada registro corresponde a una línea de pedido, identificada por SalesOrderNumber y SalesOrderLineNumber. Se relaciona con las dimensiones mediante ProductKey, OrderDateKey, CustomerKey y SalesTerritoryKey.

Tiempo contiene la jerarquía año, trimestre, mes y fecha. Las claves de mes y trimestre incluyen el año para evitar mezclar periodos. Producto organiza categoría, subcategoría y producto; Territorio organiza grupo, país y región; Cliente identifica al comprador mediante su clave y código.

Medidas: Ventas y Unidades usan suma; Lineas cuenta registros; Pedidos distintos usa DistinctCount en un grupo de medidas separado. Ticket promedio divide Ventas entre Pedidos distintos.

PedidoKey se deriva con DENSE_RANK sobre SalesOrderNumber. Su correspondencia se validó frente al conteo original: 27,659 pedidos en ambos casos. Esta clave requiere procesamiento completo cuando cambia el conjunto; no debe utilizarse para cargas incrementales.

@VisualStudio_Modelo_estrella.png|Figura 2. Estructura del cubo en Visual Studio.

# 4. Implementación y procesamiento

Se creó y procesó DMD941_Desafio2 en SSAS mediante XMLA. Posteriormente se importó el modelo desde el servidor a un proyecto multidimensional de Visual Studio, se revisó su estructura y se desplegó desde el proyecto. Esta secuencia refleja el procedimiento realmente realizado.

El origen usa MSOLEDBSQL, autenticación integrada y la cuenta del servicio de Analysis Services. Se concedió a NT SERVICE\MSSQLServerOLAPService acceso de lectura al esquema d2. El script 04_Permisos_SSAS.sql permite reproducir esa configuración para la instancia predeterminada.

El destino es localhost, base DMD941_Desafio2, cubo CuboVentasInternet. El procesamiento completo carga dimensiones y grupos de medidas. El despliegue desde Visual Studio finalizó con cero errores y cero advertencias.

@VisualStudio_Implementacion.png|Figura 3. Implementación correcta desde Visual Studio.

@Procesamiento_Cubo_local.png|Figura 4. Ejecución correcta de ProcessFull en SSAS.

# 5. Conciliación de resultados

La exploración del cubo en Visual Studio devuelve los mismos totales generales que la consulta relacional. Power BI muestra el importe redondeado a dos decimales.

Ventas: SQL y cubo = 29,358,677.2207; Power BI = 29,358,677.22. Unidades = 60,398. Pedidos distintos = 27,659. Líneas = 60,398, según consulta SQL y MDX. Ticket promedio = 1,061.45, redondeado a dos decimales.

La igualdad entre líneas y unidades ocurre en este conjunto de datos y no constituye una regla general. Los pedidos distintos no deben sumarse entre categorías o productos, porque un pedido puede incluir varios productos.

@VisualStudio_Validacion_totales.png|Figura 5. Totales consultados en el explorador del cubo.

La validación documentada corresponde al total general sin filtros y a una prueba funcional del filtro de año. No constituye una comprobación exhaustiva de cada combinación de dimensiones.

# 6. Visualización en Power BI

VentasInternet.pbix utiliza conexión en vivo con Analysis Services en localhost y el catálogo DMD941_Desafio2. Las medidas provienen del cubo. El archivo necesita que el servidor y el modelo estén disponibles para consultar los datos.

El panel incluye cuatro indicadores, una serie de ventas mensuales, barras por país y categoría, una tabla de los diez productos con mayores ventas y un filtro de año.

@PowerBI_Panel_final.png|Figura 6. Panel final conectado al cubo, sin restricción de año.

La tabla Top 10 muestra un subtotal de 10,355,525.92 y 3,636 unidades. Este subtotal corresponde solo a los productos seleccionados por el filtro Top N y no al total de ventas del cubo.

# 7. Exploración e interpretación

Se comprobó la interacción del segmentador seleccionando únicamente 2013: las tarjetas y los gráficos se actualizaron. Después se restableció el intervalo completo para guardar la vista general.

@PowerBI_filtro_2013.png|Figura 7. Prueba del filtro de año con 2013 seleccionado.

Estados Unidos y Australia presentan las mayores ventas en la vista general. Bikes concentra ampliamente el importe vendido frente a Clothing y Accessories. Estos resultados describen ventas, no rentabilidad.

La serie mensual muestra un aumento durante 2013. La caída en el extremo de 2014 debe analizarse considerando la cobertura temporal del conjunto; no se atribuye a una causa comercial sin comprobar fechas y periodos completos.

En el ranking general, Road-150 Red, 48 encabeza la tabla visible con 1,205,876.99. Las diez filas suman aproximadamente el 35.27 % del total de ventas.

El segmentador presenta años de la dimensión desde 2005; esto no implica que existan ventas en todos ellos. La serie visible de hechos abarca de diciembre de 2010 a enero de 2014.

# 8. Conclusiones, entrega y referencias

Se logró conectar la base relacional, el cubo multidimensional y Power BI. Los totales generales coinciden entre SQL y SSAS y conservan su valor en Power BI con el redondeo de presentación.

La separación entre líneas, unidades y pedidos evita interpretar incorrectamente el volumen de transacciones. Las dimensiones permiten comparar periodos, mercados y productos; el filtro de año demuestra la exploración interactiva.

La entrega incluye este informe, consultas SQL, definiciones XMLA, solución de Visual Studio, archivo PBIX, tema y capturas. El README detalla cómo reproducirla. Debe compartirse el enlace del repositorio en el aula digital.

Referencias

[1] Microsoft. AdventureWorks sample databases. https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure

[2] Microsoft. Create a Cube Using a Data Source View. https://learn.microsoft.com/en-us/analysis-services/multidimensional-models/create-a-cube-using-a-data-source-view

[3] Microsoft. Connect to SSAS multidimensional models in Power BI Desktop. https://learn.microsoft.com/en-us/power-bi/connect-data/desktop-ssas-multidimensional

Las capturas incluidas corresponden a la ejecución local documentada. Las imágenes heredadas del borrador original, si se conservan como anexos en la carpeta, no sustituyen estas pruebas.