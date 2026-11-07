# Preparar esta computadora

## 1 SQL Server y Analysis Services

Ya se encontraron archivos de SQL Server 2022 y un respaldo AdventureWorksDW2022.bak en Descargas. No borres las instancias existentes.

- Busca Servicios en Inicio y revisa SQL Server (MSSQLSERVER) o la instancia nombrada que vayas a usar. Si está detenida, inicia el servicio con permisos de administrador. Si falla, conserva el mensaje de error.
- Abre SSMS y prueba localhost para la instancia predeterminada; para una instancia nombrada, usa EQUIPO\INSTANCIA. Anota cuál conecta.
- Para agregar SSAS, usa el instalador completo de SQL Server 2022: Instalación > Nueva instalación independiente o agregar características. Si pide una carpeta de medios, el lanzador SQL2022-SSEI no sustituye los medios completos: descarga el medio desde la opción del instalador y ejecuta setup.exe.
- En características selecciona Analysis Services. Elige Modo multidimensional, agrega tu usuario como administrador y completa la instalación.
- Si el instalador pide nombre de instancia, usa un nombre identificable como SSAS_DMD941; la conexión será localhost\SSAS_DMD941. Anota el nombre realmente instalado.
- No selecciones modo Tabular para este trabajo. Agregar la extensión de Visual Studio no instala el servidor SSAS.

Guía oficial: https://learn.microsoft.com/en-us/analysis-services/instances/install-windows/install-analysis-services

## 2 Visual Studio

- Instala Visual Studio Community de una versión compatible con Microsoft Analysis Services Projects. Visual Studio Code, Build Tools y SSMS no sustituyen el IDE Visual Studio.
- Abre Visual Studio > Extensiones > Administrar extensiones; busca Microsoft Analysis Services Projects y verifica la compatibilidad del editor Microsoft con tu versión.
- Descarga la extensión y cierra Visual Studio si el instalador lo solicita.
- Reabre Visual Studio y comprueba que Nuevo proyecto incluya Analysis Services Multidimensional and Data Mining Project.

Guía oficial: https://learn.microsoft.com/en-us/sql/ssdt/download-sql-server-data-tools-ssdt

## 3 Power BI Desktop

Instala la versión de 64 bits desde Microsoft y ábrela. Para construir y guardar este informe local no hace falta publicarlo en Power BI Service. La entrega usa el PBIX y GitHub.

Guía oficial: https://learn.microsoft.com/en-us/power-bi/fundamentals/desktop-get-the-desktop

## 4 Retomar la implementación

Con SSMS conectado al motor y SSAS instalado en modo multidimensional, continúa con README.md. Comparte los nombres de las dos instancias, no contraseñas.

Los avisos de administrador y autenticación deben completarse por el usuario. No desactives controles de seguridad para instalar.
