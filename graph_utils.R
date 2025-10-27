# ================================================================
# graph_utils.R — grafo con layout Manhattan y pesos en distancia (bloques)
# ================================================================
library(igraph)

make_graph_with_weights <- function(outer_abbr = NULL, PT = "PT") {
  # ---- Nodos y layout fijo ----
  coords <- data.frame(
    name = c("EIJ","BT","U","ACSE","PSF","CM","M","PT","A","TS","EAN","P"),
    x = c(1,2,3,4,5, 1,2,3,4,5, 2,1),
    y = c(5,5,5,5,5, 4,3,2,3,4, 1,1)
  )
  
  # ---- Aristas y pasos Manhattan ----
  edges <- data.frame(
    from = c("EIJ","BT","U","ACSE","PSF","TS","A","M","CM","M","EAN","PT","PT","U","ACSE"),
    to   = c("BT","U","ACSE","PSF","TS","A","EAN","CM","EIJ","P","P","A","M","TS","CM"),
    manhattan_steps = c(1,1,1,1,1,1,4,1,1,1,1,2,6,3,4)
  )
  
  # Pesos = distancias Manhattan puras (bloques)
  edges$weight <- edges$manhattan_steps
  
  g <- graph_from_data_frame(edges[, c("from","to","weight")],
                             vertices = coords, directed = FALSE)
  
  E(g)$weight <- edges$weight
  V(g)$x <- coords$x
  V(g)$y <- coords$y
  
  #cat("\n--- Grafo generado con distancias Manhattan (bloques) ---\n")
  #print(head(edges, 5))
  
  return(list(g = g, coords = coords))
}

