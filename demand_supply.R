# ================================================================
# demand_supply.R — Generar demanda (D) y oferta/superávit (S)
# ================================================================

build_demand_supply <- function(mapping, PT = "PT", N_SURPLUS = 4,
                                S0 = 10, seed_dem = 321, seed_split = 777){
  set.seed(seed_dem)
  expected_demand <- sample(3:15, nrow(mapping), replace = TRUE)
  expected_demand[mapping$Abbrev == PT] <- 0
  
  station_df <- data.frame(Station = mapping$Station, Abbrev = mapping$Abbrev, stringsAsFactors = FALSE)
  all_nodes <- station_df$Abbrev[station_df$Abbrev != PT]
  
  set.seed(seed_split)
  S <- sample(all_nodes, N_SURPLUS)
  D <- setdiff(all_nodes, S)
  
  d <- setNames(expected_demand[match(D, mapping$Abbrev)], D)
  s <- setNames(sample(8:20, length(S), replace = TRUE), S)
  
  list(D = D, S = S, d = d, s = s, S0 = S0)
}
