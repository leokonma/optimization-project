# ================================================================
# graph_utils.R — Construcción de grafo con distancias Manhattan
# ================================================================

library(igraph)

# Calcular distancia Manhattan entre dos nodos usando coords
manhattan_dist <- function(a, b, coords){
  ax <- coords$x[coords$name == a]
  ay <- coords$y[coords$name == a]
  bx <- coords$x[coords$name == b]
  by <- coords$y[coords$name == b]
  abs(ax - bx) + abs(ay - by)
}

# Crear grafo con coordenadas simuladas
make_graph_with_weights <- function(outer_abbr, PT = "PT", seed = 123){
  set.seed(seed)
  n <- length(outer_abbr) + 1
  coords <- data.frame(
    name = c(PT, outer_abbr),
    x = runif(n, 0, 10),
    y = runif(n, 0, 10)
  )
  
  g <- make_full_graph(n, directed = FALSE)
  V(g)$name <- coords$name
  E(g)$weight <- apply(as_edgelist(g), 1, function(e)
    manhattan_dist(e[1], e[2], coords)
  )
  
  manhattan_fun <- function(a, b) manhattan_dist(a, b, coords)
  
  list(g = g, coords = coords, manhattan = manhattan_fun)
}
