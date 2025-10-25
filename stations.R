# ================================================================
# stations.R — Crear abreviaciones y mapeo de estaciones
# ================================================================

# Operador "or" seguro: devuelve a si existe, b si no
`%||%` <- function(a, b) if (length(a)) a else b

# Generar abreviatura de un nombre
abbr <- function(s){
  s <- gsub("[^[:alnum:] ]"," ",s)                       # quitar caracteres no alfanuméricos
  w <- unlist(strsplit(s,"\\s+"))                        # separar por espacios
  w <- w[nchar(w)>2] %||% w                              # quedarse con palabras > 2 letras
  substr(paste0(toupper(substr(w,1,1)), collapse=""), 1, 6)  # primeras letras mayúsculas
}

# Crear mapeo de estaciones (con PT + outer)
make_mapping <- function(all_names, N_OUTER, PT = "PT", PT_name = "CENTRAL", seed = 123){
  set.seed(seed)
  outer_full <- sample(all_names, N_OUTER)
  outer_abbr <- sapply(outer_full, abbr)
  
  # Resolver duplicados
  if (any(duplicated(outer_abbr))) {
    dup <- which(duplicated(outer_abbr))
    for (k in dup) outer_abbr[k] <- paste0(outer_abbr[k], k)
  }
  
  # Evitar conflicto con PT
  outer_abbr[outer_abbr == PT] <- paste0(outer_abbr[outer_abbr == PT], "1")
  
  mapping <- data.frame(
    Abbrev = c(PT, outer_abbr),
    Station = c(PT_name, outer_full),
    stringsAsFactors = FALSE
  )
  
  list(mapping = mapping, outer_abbr = outer_abbr, PT = PT)
}
