# ================================================================
# plot_utils.R — Visualizar grafo sin ruta
# ================================================================

library(igraph)

plot_network <- function(g, coords, PT = "PT") {
  # === Layout (coordenadas de nodos) ===
  lay <- as.matrix(coords[match(V(g)$name, coords$name), c("x", "y")])
  
  # === Estilo de nodos ===
  V(g)$color       <- "#77CAFF"
  V(g)$size        <- 28
  V(g)$label.color <- "black"
  V(g)$label.cex   <- 0.9
  V(g)$frame.color <- "#455A64"
  V(g)$color[V(g)$name == PT] <- "#E53935"
  V(g)$size[V(g)$name == PT]  <- 36
  
  # === Estilo de aristas ===
  E(g)$color <- "grey60"
  E(g)$width <- 2
  
  # === Plot del grafo ===
  par(mar = c(3, 3, 5, 3))
  plot(
    g,
    layout = lay,
    edge.curved = 0,
    edge.label = round(E(g)$weight, 1),
    edge.label.cex = 0.9,
    main = "Network in Manhattan distances (PT = depot)",
    asp = 1
  )
}

