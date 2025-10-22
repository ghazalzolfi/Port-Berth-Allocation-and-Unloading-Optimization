# Port-Berth-Allocation-and-Unloading-Optimization

This repository contains the implementation of a **Mixed Integer Linear Programming (MILP)** model for the **berth allocation and ship scheduling problem** in a container port. The project was developed as part of the *Operations Research II* course.

---

## Problem Overview
In a container port, several ships arrive and need to be allocated to available berths for unloading.  
Each berth has:
- A **capacity limit** for handling containers.  
- A **length restriction** for docking ships.  
- A **setup time** required between consecutive unloadings.  

Each ship is characterized by:  
- **Arrival time** at the port.  
- **Length** (must fit into the berth).  
- **Cargo volume** to unload.  
- **Priority level** based on cargo type.  

The challenge is to **assign ships to berths and schedule unloading times** while minimizing the **total cost of waiting** and **extra capacity usage**.

---

## Objective
The project aims to:  
- Minimize the **total waiting cost** of ships, which depends on waiting duration and priority.  
- Minimize the **cost of additional capacity usage** in berths.  
- Ensure feasibility of allocations with respect to berth lengths, setup times, and arrival times.

---

## Model & Methodology
- The problem is formulated as a **Mixed Integer Linear Program (MILP)**.  
- The complete mathematical formulation is available here: **model/model.pdf**.  
- Implementations are provided in:
  - **Python with Pyomo**  
  - **Python with Gurobipy**  
  - **GAMS**  

Additionally, **sensitivity analysis** is performed on parameters such as:  
- Setup time between unloadings.  
- Unloading duration of specific ships.  
- Berth capacities.  
- Arrival times of selected ships.  

---
  
## Input Parameters
The parameters are stored in **data/Parameters.xlsx**. Examples:

| Parameter | Description |
|-----------|-------------|
| `arrival_time[i]` | Arrival time of ship *i* |
| `length[i]` | Length of ship *i* |
| `cargo[i]` | Cargo volume of ship *i* |
| `priority[i]` | Priority level of ship *i* |
| `berth_capacity[j]` | Maximum capacity of berth *j* |
| `berth_length[j]` | Length of berth *j* |
| `setup_time[j]` | Setup time required between unloadings at berth *j* |

---

## How to Run

### 1. Run with Python (Pyomo)
Use the Pyomo notebook in `python/pyomo_notebook.ipynb`.  
You can also convert/execute it via your IDE or Jupyter environment.

Command example:  
```bash
jupyter nbconvert --to notebook --execute python/pyomo_notebook.ipynb --output python/pyomo_notebook_out.ipynb
```

### 2. Run with Python (Gurobipy)
Use the Gurobipy notebook in `python/gurobipy_notebook.ipynb`.

Command example:  
```bash
jupyter nbconvert --to notebook --execute python/gurobipy_notebook.ipynb --output python/gurobipy_notebook_out.ipynb
```

### 3. Run with GAMS
Execute `GAMS/model.gms` in GAMS Studio or via command line:

Command example:  
```bash
gams GAMS/model.gms
```

### 4. View Results
Outputs and reports are stored in:  
- `python/` (Python results and analysis)  
- `GAMS/outputs/` (GAMS results and sensitivity analysis)

---

## Sensitivity Analysis
Sensitivity analysis is performed on selected parameters to study their effect on:
- The **objective function value** (total cost).  
- **Ship waiting times** and **berth utilization**.  

Results and plots are included in reports and outputs folders.

---

## Tools & Libraries
- **Python:** Pyomo, Gurobipy, Pandas, Matplotlib, openpyxl  
- **Solvers:** GLPK / CBC / Gurobi (if available)  
- **GAMS:** Alternative implementation and validation  
