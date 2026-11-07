# UNIVERSIDAD DON BOSCO
## Facultad de Educación a Distancia
## Desafío Práctico 2
Datawarehouse y Minería de Datos G01T
Experiencia de Aprendizaje 1 · Ponderación: 20 %
Docente: David Enrique Moya Aguilar
### Integrantes
Carlos Eduardo Saavedra Vega · SV253275
Jason Alexander Castro Ascencio · CA152304
Fecha de entrega indicada: 6 de noviembre
### Informe ampliado y guía de finalización
Estado: evidencia SQL previa disponible; definición del cubo validada estructuralmente; ejecución local y Power BI pendientes.
Repositorio: https://github.com/Caarlao05/DMD941-Desafio2-AdventureWorks
Modalidad: trabajo en pareja autorizado por el docente, según confirmación de los estudiantes.

---

# Índice
1. Introducción y objetivos ................................................ 3
2. Entorno, alcance y preguntas de análisis ........................ 3
3. Restauración y exploración .......................................... 4
4. Consultas SQL y resultados observados ........................ 5
5. Interpretación de los resultados ................................... 6
6. Diseño e implementación del cubo OLAP ...................... 7
7. Visualización en Power BI ............................................. 8
8. Verificación, conclusiones y entrega .............................. 9
9. Referencias ................................................................ 10
### Criterio de documentación
Las capturas de este informe proceden del PDF proporcionado por los estudiantes. Sus resultados se transcriben como evidencia visible, sin afirmar que las consultas se hayan ejecutado nuevamente durante esta revisión.
La sección 6 describe las definiciones SSAS ya preparadas; la sección 7 especifica el panel pendiente de construir. Deben actualizarse con la configuración real y capturas propias una vez completados el cubo y el informe.
La reproducción local utiliza AdventureWorksDW2022. Las capturas previas corresponden a AdventureWorksDW2025; se conservan como antecedentes y deben contrastarse con la nueva ejecución.

---

# 1. Introducción y objetivos
El trabajo aborda una solución de análisis multidimensional sobre AdventureWorks Data Warehouse. El flujo previsto comprende restaurar la base en SQL Server, explorar ventas mediante SQL, diseñar y procesar un cubo en SQL Server Analysis Services (SSAS) y visualizar sus medidas desde Power BI Desktop.
El modelo toma FactInternetSales como tabla central, con dimensiones de fecha de pedido, producto, cliente y territorio. Las consultas relacionales proporcionan controles para contrastar posteriormente los resultados del cubo y del informe.
### Objetivo general
Implementar y validar un flujo de análisis de ventas desde AdventureWorksDW hasta un cubo multidimensional y un panel de Power BI.
### Objetivos específicos
• Verificar la restauración y la disponibilidad de las tablas.
• Identificar el grano, las medidas y las dimensiones relevantes.
• Diseñar jerarquías y agregaciones que eviten duplicaciones.
• Procesar el cubo y contrastar sus resultados con SQL.
• Construir visualizaciones y documentar evidencias reproducibles.
# 2. Entorno, alcance y preguntas de análisis
SQL Server y SSMS: restauración y consultas. Visual Studio con Analysis Services Projects: diseño. SSAS en modo multidimensional: despliegue y procesamiento. Power BI Desktop: conexión y gráficos. GitHub: entrega de archivos.
Las capturas identifican AdventureWorksDW2025. Para la reproducción local se dispone de SQL Server 2022 y del respaldo AdventureWorksDW2022.bak. Falta habilitar una conexión al motor e instalar SSAS multidimensional, Visual Studio con su extensión y Power BI Desktop.
### Preguntas propuestas
• ¿Cuál es el importe vendido, cuántas unidades y cuántos pedidos existen?
• ¿Cómo evolucionan las ventas por año y mes?
• ¿Qué países, categorías y productos concentran los ingresos?
• ¿Coinciden los totales de SQL, SSAS y Power BI bajo los mismos filtros?
El alcance se limita a ventas por Internet. No representa todas las ventas empresariales ni permite deducir beneficio neto a partir de SalesAmount.

---

# 3. Restauración y exploración
La evidencia aportada muestra la restauración correcta de AdventureWorksDW2025 en SSMS. El respaldo corresponde a la variante Data Warehouse. Microsoft proporciona los archivos y el procedimiento de restauración en su documentación oficial [1].
[Insertar captura original: Figura 1. Mensaje de restauración correcta de AdventureWorksDW2025.]
La segunda captura muestra el listado de tablas mediante sys.tables. Esta evidencia acredita la disponibilidad del esquema; el conteo de FactInternetSales aparece en la figura 3.
[Insertar captura original: Figura 2. Base restaurada y listado de tablas.]

---

# 4. Consultas SQL y resultados observados
El archivo sql/03_Consultas_AdventureWorks.sql reúne las consultas revisadas Q00-Q14. Debe ejecutarse en la base indicada; si el nombre instalado difiere, ajustar USE antes de iniciar.
Q00-Q03 verifican filas, ventas, unidades, pedidos y evolución temporal; Q04-Q07 analizan país, producto, categoría y año por país; Q08-Q09 revisan relaciones y conciliación anual. Q10-Q14 añaden entorno, periodo, clientes, ticket promedio, categorías faltantes, participación por país y duplicación del grano.
La granularidad es una línea de pedido, identificada por SalesOrderNumber y SalesOrderLineNumber. Por ello COUNT(*) mide líneas y COUNT(DISTINCT SalesOrderNumber) mide pedidos. Los importes y cantidades se suman; el ticket se calcula sobre pedidos distintos.
[Insertar captura original: Figura 3. Resumen de ventas mostrado en el documento original.]
### Mejoras al script
El TOP 10 agrupa por ProductKey y nombre, evitando fusionar claves distintas con el mismo nombre. El análisis por categoría conserva productos sin clasificación mediante LEFT JOIN. Esto representa productos por clave del almacén; un análisis por identidad comercial requeriría definir otra agrupación.
Las consultas agregan en el motor y usan claves para las uniones. No se afirma una mejora de rendimiento medida: para evaluarla se requieren planes de ejecución y mediciones en la instancia real.

---

# 5. Interpretación de los resultados
Las capturas muestran 29,358,677.22 de ventas, 60,398 unidades, 27,659 pedidos distintos y 60,398 líneas. El ticket promedio calculado es 1,061.45 por pedido. La coincidencia entre unidades y líneas es propia del resultado observado y no convierte ambos indicadores en equivalentes.
[Insertar captura original: Figura 4. Ventas y unidades por categoría.]
Bikes aporta 28,318,144.65, aproximadamente el 96.46 % del importe. Accessories aporta 700,759.96 (2.39 %) y Clothing 339,772.61 (1.16 %). Los porcentajes pueden sumar 100.01 % por redondeo. La suma de los importes coincide con el total general.
Accessories lidera las unidades con 36,092, mientras Bikes registra 15,205 y Clothing 9,101. Esto distingue volumen físico e ingresos: una categoría puede vender más unidades sin aportar el mayor importe.
[Insertar captura original: Figura 5. Ventas por país.]
United States registra 9,389,789.51 y Australia 9,061,000.58. Juntos concentran aproximadamente el 62.85 % de las ventas. Les siguen United Kingdom, Germany, France y Canada. La suma visible de los seis países también coincide con el total.
La captura mensual incluye diciembre de 2010 y meses posteriores, pero no muestra toda la serie. No permite concluir cuál fue el año de mayor venta ni demostrar estacionalidad. Verificar el periodo completo con Q10 y comparar años con cobertura equivalente.
Los importes se presentan sin asignar una divisa no acreditada en las capturas. La concentración observada orienta nuevas preguntas comerciales, pero no demuestra rentabilidad ni causas de la demanda.

---

# 6 Diseño e implementación del cubo OLAP
Se preparó la definición CuboVentasInternet para la base SSAS DMD941_Desafio2. La validación estructural AMO finalizó correctamente. Aún no se ha desplegado ni procesado contra un servidor; dicha validación no sustituye las pruebas con datos.
### 6.1 Origen y vista de datos
El archivo sql/02_Vistas_Cubo.sql define cinco vistas en el esquema d2: Tiempo, Producto, Cliente, Territorio y Ventas. Se conservan las tablas originales. La vista Producto incorpora categoría y subcategoría mediante LEFT JOIN y asigna una categoría explícita a los valores sin clasificación.
El origen AdventureWorksDW usa autenticación integrada y apunta inicialmente a localhost y AdventureWorksDW2022. La identidad del servicio SSAS necesita lectura sobre las vistas. Ajustar el servidor al nombre real antes de desplegar.
### 6.2 Dimensiones y jerarquías
Tiempo: DateKey y fecha de pedido. Jerarquía Anio > Trimestre > Mes > Tiempo. MesKey = año × 100 + mes; TrimestreKey = año × 10 + trimestre. Las claves distinguen periodos de años diferentes. El nombre mensual AAAA-MM permite orden cronológico.
Producto: ProductKey como clave y jerarquía Categoria > Subcategoria > Producto. Las relaciones de atributos siguen las dependencias de clasificación.
Cliente: CustomerKey como clave y código alternativo como etiqueta; no se incorporan nombres personales al cubo.
Territorio: SalesTerritoryKey como clave; jerarquía Grupo > Pais > Territorio. Las cuatro dimensiones se relacionan con ambos grupos de medidas.
### 6.3 Medidas implementadas en la definición
Ventas = SUM(SalesAmount); Unidades = SUM(OrderQuantity); Lineas = Count de la línea; Pedidos distintos = DistinctCount de PedidoKey en un grupo propio. Ticket promedio divide Ventas entre Pedidos distintos y devuelve vacío cuando no hay pedidos.
PedidoKey se deriva con DENSE_RANK sobre SalesOrderNumber en la vista completa. Permite un conteo distinto numérico equivalente al original; debe verificarse con el control incluido en 02_Vistas_Cubo.sql. Si cambia el origen, realizar Process Full: esta clave derivada no debe usarse para cargas incrementales.
### 6.4 Archivos y ejecución pendiente
ssas/01_Crear_Cubo.xmla crea una base nueva; no reemplaza una existente. ssas/02_Procesar_Cubo.xmla solicita Process Full. ssas/03_Validaciones.mdx incluye seis consultas de comprobación. Se entregan también las definiciones .ds, .dsv, .dim y .cube para Visual Studio.
Después de ejecutar las vistas, incorporar los objetos a un proyecto multidimensional, compilar, configurar el destino, desplegar y procesar. Capturar la vista de datos, las jerarquías, Dimension Usage, el procesamiento satisfactorio y los totales MDX.

---

# 7. Visualización en Power BI
Estado: tema Tema_UDB.json y especificación Construir_Panel.md preparados; archivo PBIX pendiente. Microsoft documenta la conexión en vivo a modelos SSAS multidimensionales; las medidas deben definirse en el modelo, ya que esta modalidad no permite crear medidas de informe [4].
### 7.1. Conexión
1. Abrir Power BI Desktop y seleccionar Obtener datos > Base de datos de SQL Server Analysis Services.
2. Introducir la instancia de SSAS, seleccionar conexión en vivo y elegir DMD941_Desafio2 y CuboVentasInternet. Verificar permisos del usuario.
3. Confirmar que aparezcan las medidas y dimensiones esperadas. Guardar el archivo como VentasInternet.pbix.
### 7.2. Diseño del panel propuesto
Encabezado: Ventas por Internet - AdventureWorksDW. Incluir el periodo analizado y los filtros activos.
Fila superior: tarjetas con Ventas, Unidades, Pedidos distintos y Ticket promedio.
Zona central: gráfico de líneas con Año-Mes en orden cronológico y Ventas; barras horizontales con País y Ventas.
Zona inferior: barras por Categoría y una tabla TOP 10 de productos por Ventas. Incluir Unidades para comparar volumen e importe.
Página de validación: matriz Año x País con Ventas, subtotales y total general, comparable con Q07.
Segmentadores: Año, País y Categoría. Comprobar que cada selección filtre los visuales de forma coherente y que al limpiar filtros reaparezca el total general.
### 7.3. Criterios de presentación e interpretación
Usar títulos claros, separadores de miles y dos decimales para importes. Indicar si los valores se expresan en miles o millones. Evitar atribuir caídas a factores económicos sin evidencia adicional.
El comentario final debe identificar el periodo y filtros utilizados, el mayor aporte por país y categoría, la tendencia observada y las limitaciones. Los resultados de la sección 5 sirven como referencia inicial, pero deben contrastarse con el panel.
Evidencias pendientes: conexión al cubo, panel completo sin filtros, panel con una selección y matriz de validación. Las capturas deben mostrar etiquetas y valores legibles.

---

# 8. Verificación, conclusiones y entrega
### 8.1. Matriz de control
Indicador | SQL visible | SSAS | Power BI
Ventas | 29,358,677.22 | Pendiente | Pendiente
Unidades | 60,398 | Pendiente | Pendiente
Pedidos distintos | 27,659 | Pendiente | Pendiente
Líneas | 60,398 | Pendiente | Pendiente
Ticket promedio | 1,061.45 calculado | Pendiente | Pendiente
Usar el mismo periodo, fecha de pedido, filtros y permisos en los tres entornos. Comparar importes con la misma precisión: diferencia esperada 0.00; para conteos, diferencia exacta cero. Los valores calculados desde capturas no sustituyen una nueva ejecución de control.
Ejecutar Q08 y Q12 para revisar claves sin dimensión y clasificación faltante; Q14 debe devolver cero filas. Q09 debe producir diferencia 0.00. Si existe discrepancia, revisar filtros, fecha utilizada, relaciones, medida de conteo y procesamiento actualizado antes de aprobar el resultado.
### 8.2. Conclusiones sustentadas
La evidencia proporcionada documenta una restauración correcta y consultas sobre ventas por Internet. Los resultados muestran concentración de ingresos en Bikes y en United States y Australia, mientras Accessories destaca por unidades.
La distinción entre líneas, unidades y pedidos es necesaria para definir indicadores coherentes. Las agregaciones por país y categoría visibles concilian con el total general.
El flujo completo aún no está validado: faltan el despliegue y el procesamiento del cubo, la conexión a Power BI y la conciliación entre los tres entornos. Al completar esas pruebas, actualizar estas conclusiones con los resultados comprobados.
### 8.3. Archivos y cierre de entrega
• informe/Informe_Desafio_2.pdf: versión final con capturas completas.
• sql/Consultas_AdventureWorks.sql: consultas ejecutables.
• ssas/: solución, proyecto y definiciones del cubo y dimensiones.
• powerbi/VentasInternet.pbix: informe conectado al cubo.
• evidencias/: capturas originales con nombres numerados.
• README.md: requisitos, restauración, despliegue, conexión y reproducción.
El repositorio debe explicar cómo descargar el respaldo oficial y configurar las instancias. No incluir contraseñas. Añadir su URL a la portada, comprobar acceso y compartir el enlace en el aula. La modalidad en pareja está confirmada por los estudiantes. Sustituir los estados pendientes antes de entregar.

---

# 9. Referencias
[1] Microsoft. (s. f.). AdventureWorks sample databases. Microsoft Learn.
https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure
[2] Microsoft. (s. f.). Use aggregate functions. Microsoft Learn.
https://learn.microsoft.com/en-us/analysis-services/multidimensional-models/use-aggregate-functions
[3] Microsoft. (s. f.). Define attribute relationships. Microsoft Learn.
https://learn.microsoft.com/en-us/analysis-services/multidimensional-models/attribute-relationships-define
[4] Microsoft. (s. f.). Connect to SSAS multidimensional models in Power BI Desktop. Microsoft Learn.
https://learn.microsoft.com/en-us/power-bi/connect-data/desktop-ssas-multidimensional
### Material de trabajo revisado
DMD941 - Desafio Práctico 2 (2).pdf: consigna y rúbrica de evaluación.
Word desafio 2.pdf: borrador del informe y capturas de restauración y consultas.
Consultas SQL.sql: consultas originales Q00-Q09.
### Nota sobre la revisión
Se amplió la redacción, se interpretaron los resultados visibles y se preparó una guía para implementar los componentes pendientes. Se generaron las definiciones SSAS y se validó su estructura con AMO. No se ejecutó SQL ni se desplegó o procesó el modelo en un servidor. El archivo PBIX sigue pendiente. Los archivos preparados y el informe se publicaron en el repositorio indicado en la portada; se actualizarán después de la ejecución local.
El script revisado incorpora controles adicionales; su ejecución y sus resultados deben registrarse en el entorno del estudiante.