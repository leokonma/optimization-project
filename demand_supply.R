# ================================================================
# demand_supply.R — generación de vectores de demanda y superávit
# ================================================================

build_demand_supply <- function(outer_abbr, N_OUTER, N_SURPLUS, PT = "PT") {
  # Excluir el punto central de las estaciones válidas
  outer_abbr <- setdiff(outer_abbr, PT)
  
  # Validaciones
  if (length(outer_abbr) < N_SURPLUS + 1)
    stop("Error: N_SURPLUS demasiado alto para la cantidad de estaciones externas disponibles.")
  
  # 1) Seleccionar estaciones con superávit
  surplus_nodes <- sample(outer_abbr, N_SURPLUS)
  
  # 2) Estaciones de demanda = las demás
  demand_nodes <- setdiff(outer_abbr, surplus_nodes)
  
  # 3) Crear valores coherentes
  set.seed(123)
  demand_values <- sample(10:20, length(demand_nodes), replace = TRUE)
  surplus_values <- sample(15:20, length(surplus_nodes), replace = TRUE)
  
  # 4) Crear vectores nombrados
  demand <- setNames(demand_values, demand_nodes)
  surplus <- setNames(surplus_values, surplus_nodes)
  
  return(list(demand = demand, surplus = surplus))
}

