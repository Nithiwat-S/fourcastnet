#!/bin/bash
#SBATCH --job-name=fcn_afno
#SBATCH --partition gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:a100:1
###SBATCH --gres=gpu:v100gl:1
#SBATCH --mem=64G
#SBATCH --time=08:00:00
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err

module purge
module load apptainer/1.3.6_gcc-11.5.0

cd /lustre-home/gpu/home/research/nithiwat-r/physicsnemo/PhysicsNeMo/examples/weather/fcn_afno
rm -rf outputs
rm -rf checkpoints

# Run with Apptainer and bind needed paths
srun apptainer exec --nv \
  --bind $PWD:/workspace \
  --bind /lustre-home/gpu/home/users/nithiwat/fourcastnet/data:/data \
  nvidia-physicsnemo25.03.sif \
  bash -c "cd /workspace && python train_era5.py"

