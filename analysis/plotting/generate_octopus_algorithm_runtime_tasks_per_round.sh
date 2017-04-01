#!/bin/bash

cd /mnt/data/icg27/firmament-experiments/analysis/plotting/

python plot_octopus_algoritum_runtime_tasks_per_round.py --setups="200,400,600,800,1000,1200,1400,1600,1800,2000,2200,2400,2600,2800,3000,3200,3400,3600,3800,4000,4200,4400,4600,4800,5000" --trace_paths=/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_200_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_400_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_600_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_800_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1000_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1200_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1400_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1600_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1800_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2000_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2200_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2400_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2600_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2800_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3000_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3200_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3400_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3600_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3800_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4000_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4200_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4400_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4600_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4800_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_5000_tasks_flowlessly_relax,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_200_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_400_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_600_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_800_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1000_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1200_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1400_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1600_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1800_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2000_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2200_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2400_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2600_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2800_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3000_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3200_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3400_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3600_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3800_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4000_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4200_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4400_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4600_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4800_tasks_flowlessly_cost_scaling,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_5000_tasks_flowlessly_cost_scaling --runtimes_after_timestamp=999999 --paper_mode=true
mv algorithms_runtime_tasks_per_round.pdf octopus_algorithms_runtime_tasks_per_round.pdf