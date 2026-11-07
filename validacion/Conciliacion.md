# Conciliación de resultados

No llenar SSAS o Power BI con números copiados de las capturas: obtenerlos de las ejecuciones reales.

| Indicador | Referencia anterior DW2025 | SQL local DW2022 | SSAS local | Power BI | Diferencia y resultado |
|---|---:|---|---|---|---|
| Ventas | 29358677.22 | Pendiente | Pendiente | Pendiente | Pendiente |
| Unidades | 60398 | Pendiente | Pendiente | Pendiente | Pendiente |
| Pedidos distintos | 27659 | Pendiente | Pendiente | Pendiente | Pendiente |
| Líneas | 60398 | Pendiente | Pendiente | Pendiente | Pendiente |
| Ticket promedio | 1061.45 calculado | Pendiente | Pendiente | Pendiente | Pendiente |

Los valores de referencia no son una expectativa obligatoria para otro respaldo. El criterio de aprobación es que SQL local, SSAS local y Power BI coincidan para la misma base, versión, periodo, fecha de pedido, filtros y permisos.

Importes: comparar con igual precisión (2 decimales), diferencia 0.00. Conteos: igualdad exacta. Comprobar también año × país y categorías, no solo el total.

Registrar instancia SQL, instancia SSAS, versión del respaldo, fecha de procesamiento, filtros y capturas asociadas. Revisar Q08, Q09, Q12 y Q14 antes de aprobar.
