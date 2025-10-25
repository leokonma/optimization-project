# 🚚 Optimization of Distribution Network in R

This project implements a **simulation and optimization framework** for a distribution system with a **central depot (PT)** and multiple **outer stations**.  
It is built in **R** and serves as a foundation for testing optimization algorithms such as **Monte Carlo**, **Simulated Annealing**, **Blind Search**, and **Simplex-based methods**.

---

## 📁 Project Structure

<pre>
code/
├── demand_supply.R     # Generate demand (D) and surplus (S) nodes
├── graph_utils.R       # Build network graph with Manhattan distances
├── main_Data.R         # Main data preparation script
├── objective_fun.R     # Objective function (template for optimization)
├── plot_utils.R        # Plotting utilities for graph visualization
├── stations.R          # Create station abbreviations and mapping
├── .RData              # Session data (optional)
├── .Rhistory           # R session history
</pre>

---

## ⚙️ Overview

### 1️⃣ `stations.R`
Generates **abbreviations** for station names and builds the mapping structure.  
Functions:
- `abbr()`: Creates clean abbreviations from full names.  
- `make_mapping()`: Selects outer stations and ensures unique identifiers.

---

### 2️⃣ `graph_utils.R`
Creates a **complete undirected graph** connecting all nodes using **Manhattan distances**.  
Functions:
- `manhattan_dist(a, b, coords)`: Distance function between nodes.  
- `make_graph_with_weights()`: Generates graph and coordinates randomly.

---

### 3️⃣ `demand_supply.R`
Randomly assigns **demand** and **surplus** stations.  
Functions:
- `build_demand_supply()`: Divides nodes into demand (`D`) and surplus (`S`), assigning random volumes.

---

### 4️⃣ `plot_utils.R`
Visualizes the graph using the **igraph** package.  
Functions:
- `plot_network()`: Custom plot with colors, labels, and weighted edges.

---

### 5️⃣ `main_Data.R`
The **central execution script** that:
- Defines simulation parameters (`N_OUTER`, `N_SURPLUS`, `S0`, etc.).
- Loads all modules (`stations`, `graph_utils`, `demand_supply`, `plot_utils`).
- Creates the mapping, builds the graph, and generates demand/supply.
- Prints a detailed summary of the simulation setup.

Run this file first to prepare the environment:
```R
source("main_Data.R")
