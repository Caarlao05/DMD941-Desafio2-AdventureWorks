param([string]$SqlServer='localhost',[string]$DatabaseName='AdventureWorksDW2022',[string]$OutputDirectory=$PSScriptRoot,[string]$AmoDirectory='C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE')
$ErrorActionPreference='Stop'
Add-Type -Path (Join-Path $AmoDirectory 'Microsoft.AnalysisServices.Core.dll')
Add-Type -Path (Join-Path $AmoDirectory 'Microsoft.AnalysisServices.dll')
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null
$database=New-Object Microsoft.AnalysisServices.Database
$database.ID='DMD941_Desafio2';$database.Name='DMD941_Desafio2';$database.CompatibilityLevel=1100
$database.Description='Ventas por Internet. Definicion generada offline; requiere desplegar y procesar.'
$source=New-Object Microsoft.AnalysisServices.RelationalDataSource
$source.ID='AdventureWorksDW';$source.Name='AdventureWorksDW'
$source.ConnectionString="Provider=MSOLEDBSQL;Data Source=$SqlServer;Initial Catalog=$DatabaseName;Integrated Security=SSPI;"
$source.ImpersonationInfo=New-Object Microsoft.AnalysisServices.ImpersonationInfo
$source.ImpersonationInfo.ImpersonationMode='ImpersonateServiceAccount'
[void]$database.DataSources.Add($source)
$view=$database.DataSourceViews.Add('VentasInternet','VentasInternet');$view.DataSourceID=$source.ID
$view.Schema=New-Object System.Data.DataSet 'VentasInternet'
function Add-ModelTable([string]$name,[object[]]$columns,[string[]]$keys){
 $table=New-Object System.Data.DataTable $name
 $table.ExtendedProperties['TableType']='View';$table.ExtendedProperties['DbSchemaName']='d2'
 $table.ExtendedProperties['DbTableName']=$name;$table.ExtendedProperties['FriendlyName']=$name
 foreach($spec in $columns){
  $parts=$spec.Split(':');$kind=$parts[1]
  $type=switch($kind){'Int32'{[int]};'Int16'{[int16]};'Int64'{[long]};'Decimal'{[decimal]};default{[string]}}
  $col=$table.Columns.Add($parts[0],$type);$col.AllowDBNull=$false
  if($type -eq [string]){$col.MaxLength=[int]$parts[2]}
 }
 $table.PrimaryKey=[System.Data.DataColumn[]]@($keys | ForEach-Object {$table.Columns[$_]})
 $view.Schema.Tables.Add($table)
}
Add-ModelTable 'Tiempo' @('DateKey:Int32','Anio:Int16','TrimestreKey:Int32','Trimestre:String:12','MesKey:Int32','Mes:String:7','Fecha:String:10') @('DateKey')
Add-ModelTable 'Producto' @('ProductKey:Int32','Producto:String:50','SubcategoriaKey:Int32','Subcategoria:String:50','CategoriaKey:Int32','Categoria:String:50') @('ProductKey')
Add-ModelTable 'Cliente' @('CustomerKey:Int32','Cliente:String:15') @('CustomerKey')
Add-ModelTable 'Territorio' @('SalesTerritoryKey:Int32','Region:String:50','Pais:String:50','Grupo:String:50') @('SalesTerritoryKey')
Add-ModelTable 'Ventas' @('ProductKey:Int32','OrderDateKey:Int32','CustomerKey:Int32','SalesTerritoryKey:Int32','SalesOrderNumber:String:20','SalesOrderLineNumber:Int16','SalesAmount:Decimal','OrderQuantity:Int16','PedidoKey:Int64') @('SalesOrderNumber','SalesOrderLineNumber')
foreach($spec in @(@('Tiempo','DateKey','OrderDateKey'),@('Producto','ProductKey','ProductKey'),@('Cliente','CustomerKey','CustomerKey'),@('Territorio','SalesTerritoryKey','SalesTerritoryKey'))){
 [void]$view.Schema.Relations.Add(('FK_'+$spec[0]),$view.Schema.Tables[$spec[0]].Columns[$spec[1]],$view.Schema.Tables['Ventas'].Columns[$spec[2]],$false)
}
function New-ItemBinding([string]$table,[string]$column){
 $col=$view.Schema.Tables[$table].Columns[$column]
 $type=switch($col.DataType.Name){'Int32'{'Integer'};'Int16'{'SmallInt'};'Int64'{'BigInt'};'Decimal'{'Currency'};default{'WChar'}}
 $item=New-Object Microsoft.AnalysisServices.DataItem($table,$column,[System.Data.OleDb.OleDbType]$type)
 if($col.DataType -eq [string]){$item.DataSize=$col.MaxLength}
 $item.NullProcessing='Error';return $item
}
function New-ModelDimension([string]$name,[string]$key,[string]$label){
 $dim=$database.Dimensions.Add($name,$name)
 $dim.Source=New-Object Microsoft.AnalysisServices.DataSourceViewBinding($view.ID)
 $dim.StorageMode='Molap';$dim.UnknownMember='None';$dim.AttributeAllMemberName='Todos'
 $a=$dim.Attributes.Add($name,$name);$a.Usage='Key'
 [void]$a.KeyColumns.Add((New-ItemBinding $name $key));$a.NameColumn=New-ItemBinding $name $label
 return $dim
}
function Add-ModelAttribute($dimension,[string]$id,[string]$key,[string]$label){
 $a=$dimension.Attributes.Add($id,$id)
 [void]$a.KeyColumns.Add((New-ItemBinding $dimension.ID $key));$a.NameColumn=New-ItemBinding $dimension.ID $label
 if($view.Schema.Tables[$dimension.ID].Columns[$label].DataType -ne [string]){$a.NameColumn=$null}
 $a.OrderBy='Key';return $a
}
function Add-ModelHierarchy($dimension,[string]$name,[string[]]$attrs){
 $h=$dimension.Hierarchies.Add($name,$name)
 foreach($attr in $attrs){$h.Levels.Add($attr,$attr).SourceAttributeID=$attr}
}
$time=New-ModelDimension 'Tiempo' 'DateKey' 'Fecha';$time.Type='Time';$time.Attributes['Tiempo'].Type='Date'
$a=Add-ModelAttribute $time 'Anio' 'Anio' 'Anio';$a.Type='Years'
$a=Add-ModelAttribute $time 'Trimestre' 'TrimestreKey' 'Trimestre';$a.Type='Quarters'
$a=Add-ModelAttribute $time 'Mes' 'MesKey' 'Mes';$a.Type='Months'
[void]$time.Attributes['Tiempo'].AttributeRelationships.Add('Mes')
[void]$time.Attributes['Mes'].AttributeRelationships.Add('Trimestre')
[void]$time.Attributes['Trimestre'].AttributeRelationships.Add('Anio')
Add-ModelHierarchy $time 'Calendario' @('Anio','Trimestre','Mes','Tiempo')
$product=New-ModelDimension 'Producto' 'ProductKey' 'Producto';$product.Type='Products'
$a=Add-ModelAttribute $product 'Categoria' 'CategoriaKey' 'Categoria'
$a=Add-ModelAttribute $product 'Subcategoria' 'SubcategoriaKey' 'Subcategoria'
[void]$product.Attributes['Producto'].AttributeRelationships.Add('Subcategoria')
[void]$product.Attributes['Subcategoria'].AttributeRelationships.Add('Categoria')
Add-ModelHierarchy $product 'Clasificacion' @('Categoria','Subcategoria','Producto')
$customer=New-ModelDimension 'Cliente' 'CustomerKey' 'Cliente';$customer.Type='Customers'
$territory=New-ModelDimension 'Territorio' 'SalesTerritoryKey' 'Region'
$a=Add-ModelAttribute $territory 'Pais' 'Pais' 'Pais';$a=Add-ModelAttribute $territory 'Grupo' 'Grupo' 'Grupo'
[void]$territory.Attributes['Territorio'].AttributeRelationships.Add('Pais')
[void]$territory.Attributes['Pais'].AttributeRelationships.Add('Grupo')
Add-ModelHierarchy $territory 'Geografia' @('Grupo','Pais','Territorio')
$cube=$database.Cubes.Add('CuboVentasInternet','CuboVentasInternet')
$cube.Source=New-Object Microsoft.AnalysisServices.DataSourceViewBinding($view.ID)
$cube.StorageMode='Molap';$cube.DefaultMeasure='[Measures].[Ventas]'
foreach($dim in $database.Dimensions){[void]$cube.Dimensions.Add($dim.ID)}
function Add-ModelMeasureGroup([string]$name){
 $mg=$cube.MeasureGroups.Add($name,$name);$mg.StorageMode='Molap'
 foreach($spec in @(@('Tiempo','OrderDateKey'),@('Producto','ProductKey'),@('Cliente','CustomerKey'),@('Territorio','SalesTerritoryKey'))){
  $rel=New-Object Microsoft.AnalysisServices.RegularMeasureGroupDimension($spec[0]);[void]$mg.Dimensions.Add($rel)
  $a=$rel.Attributes.Add($spec[0]);$a.Type='Granularity'
  [void]$a.KeyColumns.Add((New-ItemBinding 'Ventas' $spec[1]))
 }
 $part=$mg.Partitions.Add(($name+'_Total'),($name+'_Total'));$part.StorageMode='Molap'
 $part.Source=New-Object Microsoft.AnalysisServices.QueryBinding($source.ID,'SELECT * FROM [d2].[Ventas]')
 return $mg
}
function Add-ModelMeasure($mg,[string]$name,[string]$column,[string]$aggregation,[string]$format){
 $m=$mg.Measures.Add($name,$name);$m.Source=New-ItemBinding 'Ventas' $column
 $m.Source.NullProcessing='ZeroOrBlank';$m.AggregateFunction=$aggregation;$m.FormatString=$format
 if($aggregation -eq 'Count' -or $aggregation -eq 'DistinctCount' -or $column -eq 'OrderQuantity'){$m.DataType='BigInt'}else{$m.DataType='Currency'}
}
$mg=Add-ModelMeasureGroup 'Ventas Internet'
Add-ModelMeasure $mg 'Ventas' 'SalesAmount' 'Sum' '#,##0.00'
Add-ModelMeasure $mg 'Unidades' 'OrderQuantity' 'Sum' '#,##0'
Add-ModelMeasure $mg 'Lineas' 'SalesOrderLineNumber' 'Count' '#,##0'
$mg=Add-ModelMeasureGroup 'Pedidos';Add-ModelMeasure $mg 'Pedidos distintos' 'PedidoKey' 'DistinctCount' '#,##0'
$script=$cube.MdxScripts.Add('Calculos','Calculos')
$mdx="CALCULATE; CREATE MEMBER CURRENTCUBE.[Measures].[Ticket promedio] AS IIF(IsEmpty([Measures].[Pedidos distintos]) OR [Measures].[Pedidos distintos] = 0, NULL, [Measures].[Ventas] / [Measures].[Pedidos distintos]), FORMAT_STRING = '#,##0.00', VISIBLE = 1, ASSOCIATED_MEASURE_GROUP = 'Ventas Internet';"
[void]$script.Commands.Add((New-Object Microsoft.AnalysisServices.Command($mdx)))
$issues=New-Object Microsoft.AnalysisServices.ValidationErrorCollection
$valid=$database.Validate($issues,$true,[Microsoft.AnalysisServices.ServerEdition]::Developer)
$log=@("Validacion AMO offline: $valid",'No comprueba conexion, permisos, datos, compilacion en Visual Studio ni procesamiento SSAS.')
foreach($issue in $issues){$log+= ($issue | Format-List * | Out-String)}
$log | Set-Content (Join-Path $OutputDirectory 'Validacion_AMO.txt') -Encoding utf8
$settings=New-Object System.Xml.XmlWriterSettings
$settings.Indent=$true;$settings.Encoding=New-Object System.Text.UTF8Encoding($false)
$writer=[System.Xml.XmlWriter]::Create((Join-Path $OutputDirectory '01_Crear_Cubo.xmla'),$settings)
try{(New-Object Microsoft.AnalysisServices.Scripter).ScriptCreate([Microsoft.AnalysisServices.MajorObject[]]@($database),$writer,$false)}finally{$writer.Dispose()}
$writer=[System.Xml.XmlWriter]::Create((Join-Path $OutputDirectory '02_Procesar_Cubo.xmla'),$settings)
try{[Microsoft.AnalysisServices.Scripter]::WriteProcess($writer,$database,[Microsoft.AnalysisServices.ProcessType]::ProcessFull)}finally{$writer.Dispose()}
Write-Output ($log -join "`n")
if(-not $valid){throw 'Corregir los errores AMO antes de desplegar.'}



