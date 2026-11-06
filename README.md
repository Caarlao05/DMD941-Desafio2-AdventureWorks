# Desafío Práctico 2

Universidad Don Bosco — Datawarehouse y Minería de Datos G01T.

**Integrantes:** Carlos Eduardo Saavedra Vega (SV253275) y Jason Alexander Castro Ascencio (CA152304). Modalidad en pareja autorizada por el docente según confirmación de los estudiantes.

Repositorio: https://github.com/Caarlao05/DMD941-Desafio2-AdventureWorks

## Estado real

- Documento ampliado, análisis de capturas originales y SQL revisado: preparados.
- Modelo SSAS: definiciones creadas y validación estructural AMO satisfactoria.
- Conexión SQL local, restauración local, compilación en Visual Studio, despliegue y procesamiento SSAS: pendientes de ejecución.
- Power BI: tema y especificación de visuales preparados; falta guardar el PBIX con conexión real.
- Las capturas heredadas son de AdventureWorksDW2025 en otro equipo. No constituyen evidencia de la reproducción local 2022.

## Requisitos

SQL Server 2022 con motor accesible; AdventureWorksDW2022.bak; SSAS multidimensional; Visual Studio compatible con Microsoft Analysis Services Projects; Power BI Desktop de 64 bits; proveedor Microsoft OLE DB Driver for SQL Server que corresponda a MSOLEDBSQL en el origen.

## Ejecución

1. Iniciar el servicio de la instancia SQL existente y conectar SSMS con autenticación de Windows. Si está detenido, abrir Servicios desde Inicio y localizar SQL Server (MSSQLSERVER), o la instancia nombrada correcta. No reinstalar ni borrar las otras instancias.
2. Restaurar el respaldo AdventureWorksDW2022.bak desde SSMS, revisando que el destino no sobrescriba bases existentes. Ejecutar sql/01_Comprobar_Restauracion.sql.
3. Ejecutar sql/02_Vistas_Cubo.sql y sql/03_Consultas_AdventureWorks.sql. Confirmar calidad de claves y totales. Los scripts usan AdventureWorksDW2022; ajustar si el nombre real difiere.
4. Crear en Visual Studio un proyecto Analysis Services Multidimensional and Data Mining. Agregar los archivos de ssas/Objetos_VisualStudio como elementos existentes. Abrir el origen AdventureWorksDW.ds y ajustar la instancia SQL. Revisar DSV, cuatro dimensiones, dos grupos de medidas y jerarquías. La apertura y compilación de estos archivos en Visual Studio están pendientes de verificar.
5. Configurar la instancia SSAS de destino y la base DMD941_Desafio2, compilar, desplegar y ejecutar Process Full. La cuenta de procesamiento necesita SELECT sobre las vistas d2; el administrador debe asignarle acceso apropiado si no lo tiene.
6. Ejecutar ssas/03_Validaciones.mdx, una consulta a la vez, en SSMS conectado a Analysis Services. Comparar con SQL sin filtros.
7. Seguir powerbi/Construir_Panel.md, importar Tema_UDB.json y guardar powerbi/VentasInternet.pbix.
8. Completar las evidencias indicadas en evidencias/LEEME.md, actualizar el informe y registrar los resultados en validacion/Conciliacion.md.

## Ruta alternativa de despliegue XMLA

Si se necesita recuperar el modelo antes de crear el proyecto, abrir ssas/01_Crear_Cubo.xmla en SSMS conectado a Analysis Services. Revisar Data Source e Initial Catalog y ejecutarlo una sola vez para crear DMD941_Desafio2. El comando no contiene reemplazo ni eliminación: si la base ya existe, revisar su contenido en lugar de borrarla.

Después se puede usar en Visual Studio la plantilla Import from Server (Multidimensional and Data Mining) para obtener el proyecto y guardarlo en ssas/Proyecto. Esto no elimina la obligación académica de revisar y documentar el diseño dentro de Visual Studio. Ejecutar ssas/02_Procesar_Cubo.xmla después de comprobar origen y permisos.

## Diseño

Hechos: una línea de pedido de Internet. Medidas: Ventas, Unidades, Lineas, Pedidos distintos y Ticket promedio. Dimensiones: Tiempo, Producto, Cliente y Territorio. Periodos identificados por año y mes; pedidos distintos en grupo independiente.

Las vistas no cambian las tablas del ejemplo. PedidoKey usa DENSE_RANK de SalesOrderNumber sobre el conjunto completo: requiere procesamiento completo si cambian los datos, no cargas incrementales. Los nombres y claves de producto se conservan por ProductKey.

## Organización

- informe/: PDF y texto editable.
- sql/: comprobación, vistas, análisis y controles.
- ssas/: generador reproducible, XMLA, objetos para Visual Studio y MDX.
- powerbi/: tema y especificación del panel.
- evidencias/: imágenes originales y lista de capturas pendientes.
- validacion/: conciliación pendiente y resultados de comprobaciones estructurales.

El código SQL pasó el analizador sintáctico TSql160Parser sin errores. Esta prueba no ejecuta consultas ni valida los datos.

No incluir el respaldo .bak ni credenciales en el repositorio. El respaldo oficial se obtiene en https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure.

## Referencias técnicas

- https://learn.microsoft.com/en-us/analysis-services/amo/amo-concepts-and-object-model
- https://learn.microsoft.com/en-us/analysis-services/instances/install-windows/install-analysis-services
- https://learn.microsoft.com/en-us/power-bi/connect-data/desktop-ssas-multidimensional

## Entrega

Guardar la solución .sln y proyecto .dwproj creados por Visual Studio, el PBIX, las capturas finales y el PDF actualizado. Publicar la carpeta completa en GitHub, verificar acceso del docente y añadir el enlace a la portada y al aula digital. Este paquete aún no acredita una ejecución completa.

