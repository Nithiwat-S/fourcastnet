## Data Download and Pre-Processing for Running FourCastNet on singularity

Thank, Yeo Su Yia, Denise(dyeosy98) - Amazon Web Services (AWS), https://github.com/dyeosy98

Downloading NSF NCAR Curated ECMWF Reanalysis 5 (ERA5) data via the Registry of Open Data on AWS and pre-processing it for training the FourCastNet model.


## Process below.

#=========================================================================

$ git clone https://github.com/Nithiwat-S/fourcastnet.git

$ cd fourcastnet

#=========================================================================

$ python --version

$ python -m venv venv

$ source venv/bin/activate

$ pip install -r requirements.txt

$ vi config.yaml, change download_path, and your parameter.

$ python download.py, see data file in download_path.

$ python format.py, see data file in write_path.

$ mkdir -p data/train data/test data/stats

$ mv h5 file from write_path to data/train and data/test.

$ vi mean.py, change path = "/mnt/fcn/data/train" and np.save path to data/stats.

$ python mean.py

$ vi std.py, change path = "/mnt/fcn/data/train" and np.save path to data/stats.

$ python std.py

#=========================================================================

$ singularity --version

$ singularity build --fakeroot --fix-perms nvidia-modulus24-12.sif nvidia-modulus24.12.def

$ singularity exec --nv nvidia-modulus24-12.sif nvidia-smi

## source from https://github.com/NVIDIA/modulus.git

$ cd fcn_afno

$ vi conf/config.yaml, change

channels: from [0, 1, …, 19] to [0, 1, …, 33]

(test-data)channels: from [0, 1, …, 19] to [0, 1, …, 12]

max_epoch: from 80 to 10

num_workers_train: from 8 to 1

num_workers_valida: from 8 to 1

#

$ vim train_era5.py, change

lr (learning rate): from 0.0005 to 0.000005

#

$ singularity shell --nv ../nvidia-modulus24-12.sif

Singularity> nvidia-smi

Singularity> exit

#

$ singularity exec --nv --bind ../data:/data ../nvidia-modulus24-12.sif mpirun --allow-run-as-root -np 2 python train_era5.py

#

Outputs pytorch file (.pt) will be in the checkpoints/ folder.

$ ls -alh checkpoints/

rerun, delete all file in outputs directory.

$ rm -rf outputs/*