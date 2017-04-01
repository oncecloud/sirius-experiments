#!/bin/bash

cd /mnt/data/icg27/firmament-experiments/analysis/plotting/
python plot_optimizations.py --trace_paths=/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4000_tasks_flowlessly_relax_without_arc_prioritization/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4000_tasks_flowlessly_relax/ --trace_labels='No AP,AP' --runtimes_after_timestamp=999999 --paper_mode
mv optimizations_box_and_whiskers.pdf relax_optimization_box_and_whiskers.pdf

#python plot_octopus_relax_optimizatios_tasks_per_round.py --setups="1000,2000,3000,4000,5000" --trace_paths=/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1000_tasks_flowlessly_relax_without_arc_prioritization/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2000_tasks_flowlessly_relax_without_arc_prioritization/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3000_tasks_flowlessly_relax_without_arc_prioritization/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4000_tasks_flowlessly_relax_without_arc_prioritization/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_5000_tasks_flowlessly_relax_without_arc_prioritization/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_1000_tasks_flowlessly_relax/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_2000_tasks_flowlessly_relax/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_3000_tasks_flowlessly_relax/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_4000_tasks_flowlessly_relax/,/mnt/data/icg27/firmament_simulations/synthetic_octopus/synthetic_octopus_10k_machines_90_utilization_5000_tasks_flowlessly_relax/ --runtimes_after_timestamp=999999 --paper_mode
#mv algorithms_runtime_tasks_per_round.pdf octopus_relax_optimizations.pdf

#python plot_relax_optimizations_cdf.py --trace_paths=/mnt/data/icg27/firmament_simulations/quincy/google_14400_sec_95_utilization_quincy_preemption_bounded_1024MB_flowlessly_relax/,/mnt/data/icg27/firmament_simulations/quincy/google_14400_sec_95_utilization_quincy_preemption_bounded_1024MB_flowlessly_relax_without_arc_priority/ --trace_labels="relax arc prioritization,relax" --runtimes_after_timestamp=1000000 --log_scale=True --paper_mode
