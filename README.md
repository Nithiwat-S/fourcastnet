## Data Download and Pre-Processing for Running FourCastNet on singularity

Thank, Yeo Su Yia, Denise(dyeosy98) - Amazon Web Services (AWS), https://github.com/dyeosy98

Downloading NSF NCAR Curated ECMWF Reanalysis 5 (ERA5) data via the Registry of Open Data on AWS and pre-processing it for training the FourCastNet model.


## Process below.

#=========================================================================

$ git clone https://github.com/Nithiwat-S/fourcastnet.git

$ cd fourcastnet

#=========================================================================

$ module load Anaconda3/2024.10_gcc-11.5.0

$ source activate

$ conda env remove --name env_xxxx

$ conda create -n env_era5-download python=3.11

$ conda activate env_era5-download

$ ls -al requirements.txt

$ pip install -r requirements.txt

$ mkdir -p /lustre-home/gpu/home/users/nithiwat-r/fourcastnet/era5_data_test/era5_data

$ mkdir -p /lustre-home/gpu/home/users/nithiwat-r/fourcastnet/era5_data_test/data_processed

$ vi download.yaml.org

$ vi download.yaml, change months = ['01']

$ vi config.yaml.org

$ vi config.yaml, change download_path, write_path and your parameter.

$ python download.py, see data file in download_path.

$ python format.py, see data file in write_path.

$ cd ..

$ mkdir -p data/train data/test data/stats

$ mv era5_data_test/data_processed/2010.h5 data/train/

$ mv era5_data_test/data_processed/2011.h5 data/test/

$ cd fourcastnet

$ vi mean.py.org

$ vi mean.py, change path = "/mnt/fcn/data/train" and np.save path to data/stats.

$ python mean.py

$ vi std.py.org

$ vi std.py, change path = "/mnt/fcn/data/train" and np.save path to data/stats.

$ python std.py

$ h5dump -H -A 0 2010.h5

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