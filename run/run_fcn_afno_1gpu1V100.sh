#!/usr/bin/bash
#SBATCH --job-name=fcn_afno
#SBATCH --partition gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
###SBATCH --gres=gpu:a100:1
#SBATCH --gres=gpu:v100gl:1
#SBATCH --mem=32G
#SBATCH --time=08:00:00
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err

module purge
module load apptainer/1.3.6_gcc-11.5.0
apptainer=$(which apptainer)

cd $HOME/fourcastnet
rm -rf fcn_afno-24/outputs
rm -rf fcn_afno-24/checkpoints

# Run with Apptainer and bind needed paths
srun $apptainer exec --nv \
  --bind $PWD/fcn_afno-24:/workspace \
  --bind $HOME/fourcastnet/data:/data \
  $HOME/fourcastnet/run/nvidia-modulus-24-12.sif \
  bash -c "cd /workspace && python train_era5.py"
