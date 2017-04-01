#!/bin/bash
cd firmament
rm -r /mnt/data/google_14400_sec_quincy_preemption_bounded_1024MB_flowlessly_incremental_relax/
mkdir /mnt/data/google_14400_sec_quincy_preemption_bounded_1024MB_flowlessly_incremental_relax/
./build/src/simulator --flagfile=/home/srguser/firmament-experiments/configs/google_14400_sec_quincy_preemption_bounded_1024MB_flowlessly_incremental_relax.cfg
scp -r /mnt/data/google_14400_sec_quincy_preemption_bounded_1024MB_flowlessly_incremental_relax/ icg27@ganymede.cl.cam.ac.uk:/mnt/data/icg27/firmament_simulations/
