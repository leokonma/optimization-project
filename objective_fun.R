# ================================================================
# Función objetivo para optimización de rutas
# ================================================================
setwd("C:/Users/leodo/OneDrive/Escritorio/optimization/code")
source("main_Data.R")
# ================================================================
# Función objetivo (plantilla)
# ================================================================
# ================================================================
# Función objetivo — plantilla con todos los campos
# ================================================================
objective_function <- function(PT, coords, demand, surplus, S0, lambda = 1000, t_per = 2) {
  
  # Entradas:
  # PT      : nombre del punto central
  # coords  : coordenadas de todos los nodos
  # demand  : vector de demanda neta por nodo (positiva = entrega)
  # surplus : vector de superávit por nodo (negativa = pickup)
  # S0      : stock inicial en PT
  # lambda  : penalización por demanda no satisfecha
  # t_per   : tiempo/costo por unidad de distancia
  
  # Placeholder: cálculos aún no realizados
  delivery_costs <- NA  # costos de entrega a estaciones con demanda
  pickup_costs   <- NA  # costos de recolección desde estaciones con superávit
  unmet_demand   <- NA  # demanda no satisfecha si S0 < demanda total
  objective      <- NA  # valor final de la función objetivo
  
  # Devolver lista con todas las entradas y campos pendientes
  list(
    PT             = PT,
    coords         = coords,
    demand         = demand,
    surplus        = surplus,
    stock_initial  = S0,
    lambda         = lambda,
    t_per          = t_per,
    delivery_costs = delivery_costs,
    pickup_costs   = pickup_costs,
    unmet_demand   = unmet_demand,
    objective      = objective
  )
}
# Crear la función objetivo con los datos preparados en main
obj <- objective_function(PT = PT, coords = coords, demand = d, surplus = s, S0 = S0,
                          lambda = lambda, t_per = t_per)

# Revisar la estructura completa
str(obj)

# Acceder a los campos
obj$PT
obj$demand
obj$surplus
obj$delivery_costs
obj$pickup_costs
obj$unmet_demand
obj$objective

