# Panel de ventas por Internet

Estado: diseño y tema preparados; falta construir y guardar VentasInternet.pbix en Power BI Desktop.

1. Obtener datos > Base de datos de SQL Server Analysis Services.
2. Servidor: la instancia SSAS multidimensional instalada. Base: DMD941_Desafio2.
3. Conectar en vivo y seleccionar CuboVentasInternet.
4. Vista > Temas > Examinar temas > Tema_UDB.json.
5. Página de tamaño 16:9 (1280 × 720). Crear los visuales siguientes.

| Visual | Campos exactos del cubo | Formato y ubicación |
|---|---|---|
| Tarjeta Ventas | Ventas | Arriba; 2 decimales, sin divisa hasta comprobarla |
| Tarjeta Unidades | Unidades | Arriba; entero |
| Tarjeta Pedidos | Pedidos distintos | Arriba; entero |
| Tarjeta Ticket promedio | Ticket promedio | Arriba; 2 decimales |
| Líneas Ventas por mes | Tiempo.Mes y Ventas | Centro izquierdo; ordenar Mes ascendente |
| Barras Ventas por país | Territorio.Pais y Ventas | Centro derecho; ordenar Ventas descendente |
| Barras Categorías | Producto.Categoria y Ventas | Parte inferior izquierda |
| Tabla Productos | Producto.Producto, Ventas y Unidades | Parte inferior derecha; filtro Top N = 10 por Ventas |
| Segmentadores | Tiempo.Anio, Territorio.Pais, Producto.Categoria | Franja bajo el título |

Los nombres de campo pueden aparecer agrupados según los metadatos del conector. Seleccionar las medidas del cubo; no crear medidas DAX locales para esta conexión.

## Página Validación

Matriz: Tiempo.Anio en filas, Territorio.Pais en columnas y Ventas en valores. Habilitar totales. Agregar una tabla de las cinco medidas. Limpiar filtros y comparar con SQL Q01/Q07/Q11 y MDX M01/M03.

## Comprobaciones

- Seleccionar un año y un país: tarjetas y gráficos deben cambiar juntos.
- Limpiar segmentadores: debe recuperarse el total general de la base local.
- Los meses están identificados como AAAA-MM; no se mezclan años.
- No sumar los pedidos de distintos productos: el mismo pedido puede incluir más de uno.
- No introducir manualmente las cifras de las capturas en tarjetas. Todas deben venir del cubo procesado.
- Guardar VentasInternet.pbix y capturas sin filtros, con filtros y de la conexión.

Referencia: https://learn.microsoft.com/en-us/power-bi/connect-data/desktop-ssas-multidimensional
