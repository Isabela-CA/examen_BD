# examen_BD

# Proyecto SQL - Base de Datos Chinook

Este proyecto implementa una serie de **consultas avanzadas**, **funciones almacenadas**, **triggers** y **eventos programados** sobre la base de datos **Chinook** en MySQL.  
El objetivo es extender la funcionalidad de la base, mejorar la automatización de procesos y generar reportes útiles para análisis y control.

---

## Contenido

1. **Consultas SQL (20)**
2. **Funciones Almacenadas (5)**
3. **Triggers (5)**
4. **Eventos Programados (5)**

---

## Consultas SQL

Se implementan 15 consultas para obtener información clave:
- Encuentra el **empleado que ha generado la mayor cantidad de ventas** en el último trimestre.

- Lista los **cinco artistas con más canciones vendidas** en el último año.

- Obtén el **total de ventas y la cantidad de canciones vendidas por país**.

- Calcula el **número total de clientes que realizaron compras por cada género** en un mes específico.

- Encuentra a los **clientes que han comprado todas las canciones de un mismo álbum**.

- Lista los **tres países con mayores ventas** durante el último semestre.

- Muestra los **cinco géneros menos vendidos** en el último año.

- Calcula el **promedio de edad de los clientes** al momento de su primera compra.

- Encuentra los **cinco empleados que realizaron más ventas de Rock**.

- Genera un informe de los **clientes con más compras recurrentes**.

- Calcula el **precio promedio de venta por género**.

- Lista las **cinco canciones más largas** vendidas en el último año.

- Muestra los **clientes que compraron más canciones de Jazz**.

- Encuentra la **cantidad total de minutos comprados por cada cliente** en el último mes.

- Muestra el **número de ventas diarias** de canciones en cada mes del último trimestre.

- Calcula el **total de ventas por cada vendedor** en el último semestre.

- Encuentra el **cliente que ha realizado la compra más cara** en el último año.

- Lista los **cinco álbumes con más canciones vendidas** durante los últimos tres meses.

- Obtén la **cantidad de canciones vendidas** por cada género en el último mes.

- Lista los **clientes que no han comprado nada en el último año**.

---

## Funciones Almacenadas

- **TotalGastoCliente(ClienteID, Anio)**: Calcula el gasto total de un cliente en un año específico.--
- **PromedioPrecioPorAlbum(AlbumID)**: Retorna el precio promedio de las canciones de un álbum.
- **DuracionTotalPorGenero(GeneroID)**: Calcula la duración total de todas las canciones vendidas de un género específico.--
- **DescuentoPorFrecuencia(ClienteID)**: Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
- **VerificarClienteVIP(ClienteID)**: Verifica si un cliente es "VIP" basándose en sus gastos anuales.
---

## Triggers

1. **`ActualizarTotalVentasEmpleado`**  
   Suma automáticamente las ventas al acumulado del empleado que realizó la venta.

2. **`AuditarActualizacionCliente`**  
   Registra cambios realizados a la información de un cliente.

3. **`RegistrarHistorialPrecioCancion`**  
   Guarda el historial de cambios en el precio de las canciones.

4. **`NotificarCancelacionVenta`**  
   Registra una notificación cuando se elimina una venta.

5. **`RestringirCompraConSaldoDeudor`**  
   Impide que clientes con deuda realicen nuevas compras.

---

##  Eventos Programados

1. **`ReporteVentasMensual`**  
   Genera y almacena un informe mensual de ventas.

2. **`ActualizarSaldosCliente`**  
   Actualiza automáticamente los saldos de los clientes al final de cada mes.

3. **`AlertaAlbumNoVendidoAnual`**  
   Registra una alerta cuando un álbum no tiene ventas en el último año.

4. **`LimpiarAuditoriaCada6Meses`**  
   Elimina registros antiguos de auditoría cada 6 meses.

5. **`ActualizarListaDeGenerosPopulares`**  
   Actualiza la lista de géneros más vendidos cada mes.

---

## ⚙️ Requisitos

- MySQL 8.x o superior
- Activar el **programador de eventos**:
  ```sql
  SET GLOBAL event_scheduler = ON;
