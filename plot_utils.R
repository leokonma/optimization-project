plot_network <- function(g, PT, demand, surplus, coords,
                         main = "Network in Manhattan distances (PT point of distribution)") {
  
  layout <- as.matrix(coords[, c("x", "y")])
  
  # Colores personalizados
  pt_color <- "#E74C3C"       # Rojo más oscuro o puedes usar "gold", "firebrick", "#FF6666"
  demand_color <- "#3498DB"   # Azul para demanda
  surplus_color <- "#2ECC71"  # Verde para superávit
  
  colors <- rep("skyblue", vcount(g))
  names(colors) <- V(g)$name
  colors[PT] <- pt_color
  colors[names(demand)] <- demand_color
  colors[names(surplus)] <- surplus_color
  
  plot(
    g,
    layout = layout,
    vertex.size = ifelse(V(g)$name == PT, 45, 28),
    vertex.color = colors,
    vertex.label.color = "black",
    vertex.label.cex = 0.9,
    edge.color = "gray40",
    edge.width = 2,
    edge.label = E(g)$weight,
    edge.label.color = "black",
    edge.label.cex = 0.8,
    vertex.frame.color = "white",
    main = main
  )
  
  legend(
    "topleft",
    legend = c("PT (Central)", "Demanda", "Superávit"),
    col = c(pt_color, demand_color, surplus_color),
    pch = 19,
    pt.cex = 1.5,
    bty = "n",
    cex = 0.9
  )
}
# ================================================================
# plot_best_route — resalta la mejor ruta sobre la red Manhattan
# ================================================================
plot_best_route <- function(g, route, PT, coords, color_route = "#E74C3C") {
  # Ruta completa (inicio y fin en PT)
  full_route <- c(PT, route, PT)
  layout <- as.matrix(coords[, c("x", "y")])
  
  # Resetear colores de aristas
  E(g)$color <- "gray80"
  E(g)$width <- 1
  
  # Resaltar aristas que están en la ruta óptima
  for (i in seq_along(full_route[-1])) {
    from <- full_route[i]
    to   <- full_route[i + 1]
    eid <- get.edge.ids(g, c(from, to))
    if (eid > 0) {
      E(g)$color[eid] <- color_route
      E(g)$width[eid] <- 4
    }
  }
  
  # Dibujar grafo con layout fijo
  plot(
    g,
    layout = layout,
    vertex.size = ifelse(V(g)$name == PT, 45, 28),
    vertex.color = ifelse(V(g)$name == PT, "#F1C40F", "skyblue"),
    vertex.label.color = "black",
    vertex.label.cex = 0.9,
    edge.color = E(g)$color,
    edge.width = E(g)$width,
    edge.label = E(g)$weight,
    edge.label.color = "black",
    edge.label.cex = 0.8,
    vertex.frame.color = "white",
    main = paste("Best route —", PT, "distribution network")
  )
}
# ================================================================
# Función: plot_network_time
# Graficar la red coloreando aristas por tiempo estimado (min)
# ================================================================
plot_network_time <- function(g, PT, coords,
                              main = "Distribution network — weighted by travel time (min)") {
  # Crear paleta de colores
  time_vals <- E(g)$time_weight
  pal <- colorRampPalette(c("lightblue", "orange", "red"))
  edge_colors <- pal(100)[as.numeric(cut(time_vals, breaks = 100))]
  
  # Estilos de nodos
  node_color <- ifelse(V(g)$name == PT, "gold", "skyblue")
  node_size <- ifelse(V(g)$name == PT, 25, 15)
  
  # Graficar
  plot(g,
       layout = cbind(V(g)$x, V(g)$y),
       vertex.label = V(g)$name,
       vertex.color = node_color,
       vertex.size = node_size,
       edge.width = 2,
       edge.color = edge_colors,
       main = main)
  
  legend("bottomleft",
         legend = c("Shorter time", "Medium", "Longer time"),
         col = c("lightblue", "orange", "red"),
         lwd = 4, bty = "n", cex = 0.8)
}
