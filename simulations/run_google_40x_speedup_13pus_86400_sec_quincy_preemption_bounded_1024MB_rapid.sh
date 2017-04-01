#!/bin/bash
cd firmament
rm -r /mnt/data/google_40x_speedup_13pus_86400_sec_quincy_preemption_bounded_1024MB_rapid/
mkdir /mnt/data/google_40x_speedup_13pus_86400_sec_quincy_preemption_bounded_1024MB_rapid/
./build/src/simulator --flagfile=/home/srguser/firmament-experiments/configs/google_40x_speedup_13pus_86400_sec_quincy_preemption_bounded_1024MB_rapid.cfg
scp -r /mnt/data/google_40x_speedup_13pus_86400_sec_quincy_preemption_bounded_1024MB_rapid/ icg27@ganymede.cl.cam.ac.uk:/mnt/data/icg27/firmament_simulations/