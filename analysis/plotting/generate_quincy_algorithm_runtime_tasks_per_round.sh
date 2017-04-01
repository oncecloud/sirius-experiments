#!/bin/bash

cd /mnt/data/icg27/firmament-experiments/analysis/plotting/

python plot_quincy_algorithm_runtime_tasks_per_round.py --setups="2500,5000,7500,10000,12500,15000,17500" --trace_paths=/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_2500_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_5000_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_7500_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_10000_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_12500_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_15000_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_17500_tasks_flowlessly_cost_scaling/,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_2500_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_5000_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_7500_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_10000_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_12500_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_15000_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_20000_tasks_flowlessly_relax/ --runtimes_after_timestamp=999999 --paper_mode=true

# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_20000_tasks_flowlessly_relax
# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_22500_tasks_flowlessly_relax
# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_25000_tasks_flowlessly_relax
# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_27500_tasks_flowlessly_relax
# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_30000_tasks_flowlessly_relax

# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_20000_tasks_flowlessly_cost_scaling
# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_22500_tasks_flowlessly_cost_scaling
# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_25000_tasks_flowlessly_cost_scaling
# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_27500_tasks_flowlessly_cost_scaling
# ,/mnt/data/icg27/firmament_simulations/quincy/google_synthetic/google_synthetic_quincy_90_utilization_30000_tasks_flowlessly_cost_scaling

mv algorithms_runtime_tasks_per_round.pdf quincy_algorithms_runtime_tasks_per_round.pdf
