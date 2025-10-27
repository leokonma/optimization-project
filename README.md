# 🚚 Optimization of Distribution Network in R

This project implements a **simulation and optimization framework** for a distribution system with a **central depot (PT)** and multiple **outer stations**.  
It is developed in **R** and serves as a testing platform for various **metaheuristic optimization algorithms** such as **Blind Search**, **Hill Climbing**, **Simulated Annealing**, **Monte Carlo**, and **Grid Search**.

---

## 📂 Project Structure

<pre>
code/
├── class_algorithms.R   # Defines and runs multiple optimization algorithms
├── demand_supply.R      # Generates demand (D) and surplus (S) nodes
├── final algorthm.R     # Integrates and executes the complete optimization pipeline
├── graph_utils.R        # Builds the network graph with Manhattan distances
├── main_Data.R          # Main data preparation and parameter setup
├── plot_utils.R         # Visualization utilities for graphs and routes
├── stations.R           # Creates station abbreviations and mapping
</pre>

---

## ⚙️ Overview

### 🏗️ 1. `stations.R`
Generates abbreviations for all station names and creates the mapping between  
**central depot (PT)** and **outer stations**.  
**Functions:**
- `abbr()`: Cleans and abbreviates station names.  
- `make_mapping()`: Builds mapping and selects the PT station.

---

### 🧭 2. `graph_utils.R`
Builds the **network graph** connecting all nodes using **Manhattan distances**.  
**Functions:**
- `manhattan_dist()`: Calculates Manhattan distance between two coordinates.  
- `make_graph_with_weights()`: Generates the full network structure (edges, nodes, coordinates).  

---

### ⚖️ 3. `demand_supply.R`
Randomly assigns **demand** and **surplus** to outer stations.  
**Functions:**
- `build_demand_supply()`: Creates two balanced lists (`demand`, `surplus`)  
  used in optimization and cost evaluation.

---

### 📊 4. `plot_utils.R`
Handles **graph visualization** and **best-route plotting** using *igraph*.  
**Functions:**
- `plot_network()`: Displays the base distribution graph.  
- `plot_network_time()`: Shows edge weights in time units.  
- `plot_best_route()`: Highlights the optimal route found by an algorithm.

---

### 🧮 5. `class_algorithms.R`
Implements and executes multiple **optimization algorithms**.  
**Algorithms included:**
- Blind Search  
- Monte Carlo Search  
- Grid Search (local refinement)  
- Hill Climbing  
- Simulated Annealing  

Each algorithm searches for the most efficient delivery route by minimizing distance, time, or cost.

---

### 🧠 6. `final algorthm.R`
Integrates all modules and runs the **full optimization pipeline**:  
- Loads all helper scripts and data.  
- Executes algorithms sequentially.  
- Collects and summarizes results in a single `data.frame` (`summary_df`).  
- Displays optimal route and total cost/time.

---

### ⚙️ 7. `main_Data.R`
Prepares all simulation parameters and environment setup:  
- Defines constants (`N_OUTER`, `N_SURPLUS`, `S0`, etc.).  
- Builds mapping, graph, demand, and surplus.  
- Prints a clean summary of the scenario.  
Run this first before any optimization:

```r
source("main_Data.R")

