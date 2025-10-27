# ================================================================
# class_algorithms.R — unified and improved versions of class methods
# Adapted to route optimization minimizing Manhattan distance
# ================================================================

# ------------------------------------------------
# 0. Helper: generate permutations (for small domains)
# ------------------------------------------------
generate_permutations <- function(v) {
  if (length(v) == 1) return(list(v))
  res <- list()
  for (i in seq_along(v)) {
    rest <- v[-i]
    sub_perms <- generate_permutations(rest)
    for (perm in sub_perms) {
      res <- append(res, list(c(v[i], perm)))
    }
  }
  res
}

# ------------------------------------------------
# 1. BLIND SEARCH
# ------------------------------------------------
fsearch <- function(outer_abbr, FUN, samples = 1000, ...) {
  best_cost <- Inf
  best_route <- NULL
  
  for (i in 1:samples) {
    route <- sample(outer_abbr)
    cost <- FUN(route, ...)
    
    if (cost < best_cost) {
      best_cost <- cost
      best_route <- route
    }
  }
  
  list(
    method = "Blind Search",
    best_route = best_route,
    best_cost = best_cost
  )
}

# ------------------------------------------------
# 2. MONTE CARLO SEARCH
# ------------------------------------------------
mcsearch <- function(N, outer_abbr, FUN, type = "min", ...) {
  routes <- replicate(N, sample(outer_abbr), simplify = FALSE)
  costs <- sapply(routes, FUN, ...)
  
  idx <- ifelse(type == "min", which.min(costs), which.max(costs))
  best_route <- routes[[idx]]
  best_cost <- costs[idx]
  
  df <- data.frame(
    Route = sapply(routes, paste, collapse = " -> "),
    Distance = costs
  )
  df <- df[order(df$Distance), ]
  
  list(
    method = "Monte Carlo Search",
    best_route = best_route,
    best_cost = best_cost,
    top_routes = head(df, 10)
  )
}

# ------------------------------------------------
# 3. GRID SEARCH (local refinement)
# ------------------------------------------------
gsearch <- function(levels = 3, outer_abbr, FUN, type = "min", ...) {
  current_best <- sample(outer_abbr)
  best_cost <- FUN(current_best, ...)
  
  for (level in 1:levels) {
    neighbors <- replicate(20, {
      r <- current_best
      swap <- sample(1:length(r), 2)
      r[swap] <- r[rev(swap)]
      r
    }, simplify = FALSE)
    
    costs <- sapply(neighbors, FUN, ...)
    idx <- ifelse(type == "min", which.min(costs), which.max(costs))
    current_best <- neighbors[[idx]]
    best_cost <- costs[idx]
  }
  
  list(
    method = "Grid Search (local refinement)",
    best_route = current_best,
    best_cost = best_cost
  )
}

# ------------------------------------------------
# 4. HILL CLIMBING
# ------------------------------------------------
hclimbing <- function(par, fn, maxit = 1000, report = 200, type = "min", ...) {
  best <- par
  fbest <- fn(par, ...)
  
  for (i in 1:maxit) {
    neighbor <- best
    swap <- sample(1:length(best), 2)
    neighbor[swap] <- neighbor[rev(swap)]
    fneighbor <- fn(neighbor, ...)
    
    improved <- (type == "min" && fneighbor < fbest) ||
      (type == "max" && fneighbor > fbest)
    if (improved) {
      best <- neighbor
      fbest <- fneighbor
    }
    
    if (report > 0 && (i == 1 || i %% report == 0)) {
      cat(sprintf("Iter %d | Distance: %.2f | Route: %s\n",
                  i, fbest, paste(best, collapse = " -> ")))
    }
  }
  
  list(
    method = "Hill Climbing",
    best_route = best,
    best_cost = fbest
  )
}

# ------------------------------------------------
# 5. SIMULATED ANNEALING (R base)
# ------------------------------------------------
sannealing <- function(par, fn, graph, PT, S0, demand, surplus,
                       penalty_per_unit = 0.5,   # bloques adicionales por unidad no servida
                       T_init = 1000, T_min = 1e-3, alpha = 0.95,
                       maxit = 3000, report = 500) {
  
  current_route <- par
  current_cost  <- fn(current_route, graph = graph, PT = PT, S0 = S0,
                      demand = demand, surplus = surplus,
                      penalty_per_unit = penalty_per_unit)
  
  best_route <- current_route
  best_cost  <- current_cost
  T <- T_init
  
  for (i in 1:maxit) {
    neighbor <- current_route
    swap <- sample(1:length(neighbor), 2)
    neighbor[swap] <- neighbor[rev(swap)]
    
    neighbor_cost <- fn(neighbor, graph = graph, PT = PT, S0 = S0,
                        demand = demand, surplus = surplus,
                        penalty_per_unit = penalty_per_unit)
    
    delta <- neighbor_cost - current_cost
    
    # Aceptar peor con probabilidad e^(-Δ/T)
    if (delta < 0 || runif(1) < exp(-delta / T)) {
      current_route <- neighbor
      current_cost <- neighbor_cost
    }
    
    if (current_cost < best_cost) {
      best_route <- current_route
      best_cost  <- current_cost
    }
    
    T <- alpha * T
    
    if (report > 0 && (i %% report == 0)) {
      cat(sprintf("Iter %d | T = %.3f | Dist = %.2f | Best = %.2f\n",
                  i, T, current_cost, best_cost))
    }
    
    if (T < T_min) break
  }
  
  list(
    method = "Simulated Annealing",
    best_route = best_route,
    best_cost = best_cost
  )
}

# ------------------------------------------------
# 6. RUNNER — unified comparison
# ------------------------------------------------
run_all_algorithms <- function(outer_abbr, FUN, graph, PT, S0, demand, surplus,
                               penalty_per_unit = 0.5,
                               samples = 500, maxit = 1000) {
  
  cat("\n=== BLIND SEARCH ===\n")
  blind_res <- fsearch(outer_abbr, FUN, samples = samples, graph = graph,
                       PT = PT, S0 = S0, demand = demand, surplus = surplus,
                       penalty_per_unit = penalty_per_unit)
  print(blind_res)
  
  cat("\n=== MONTE CARLO SEARCH ===\n")
  mc_res <- mcsearch(N = samples, outer_abbr = outer_abbr, FUN = FUN,
                     graph = graph, PT = PT, S0 = S0, demand = demand,
                     surplus = surplus, penalty_per_unit = penalty_per_unit)
  print(mc_res$best_cost)
  
  cat("\n=== GRID SEARCH ===\n")
  grid_res <- gsearch(levels = 3, outer_abbr = outer_abbr, FUN = FUN,
                      graph = graph, PT = PT, S0 = S0, demand = demand,
                      surplus = surplus, penalty_per_unit = penalty_per_unit)
  print(grid_res)
  
  cat("\n=== HILL CLIMBING ===\n")
  hc_res <- hclimbing(par = sample(outer_abbr), fn = FUN,
                      graph = graph, PT = PT, S0 = S0, demand = demand,
                      surplus = surplus, penalty_per_unit = penalty_per_unit,
                      maxit = maxit, report = 200)
  print(hc_res)
  
  cat("\n=== SIMULATED ANNEALING ===\n")
  sa_res <- sannealing(
    par = sample(outer_abbr),
    fn = FUN,
    graph = graph,
    PT = PT,
    S0 = S0,
    demand = demand,
    surplus = surplus,
    penalty_per_unit = penalty_per_unit,
    T_init = 1000, T_min = 1e-3, alpha = 0.95,
    maxit = 3000, report = 300
  )
  print(sa_res)
  
  results <- list(blind_res, mc_res, grid_res, hc_res, sa_res)
  best_idx <- which.min(sapply(results, function(x) x$best_cost))
  best_method <- results[[best_idx]]
  
  cat("\n--- SUMMARY ---\n")
  cat(sprintf("Best method: %s | Distance: %.2f (blocks)\nRoute: PT -> %s -> PT\n",
              best_method$method,
              best_method$best_cost,
              paste(best_method$best_route, collapse = " -> ")))
  
  return(results)
}

