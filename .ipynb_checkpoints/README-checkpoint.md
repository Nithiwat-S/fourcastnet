## Data Download and Pre-Processing for Running FourCastNet on singularity

Thank, Yeo Su Yia, Denise(dyeosy98) - Amazon Web Services (AWS), https://github.com/dyeosy98

Downloading NSF NCAR Curated ECMWF Reanalysis 5 (ERA5) data via the Registry of Open Data on AWS and pre-processing it for training the FourCastNet model.


## Process below.

#=========================================================================
##get code

$ git clone https://github.com/Nithiwat-S/fourcastnet.git

$ cd fourcastnet

#=========================================================================
##get data

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

$ h5ls -v 2010.h5/params and see Dataset {2/2}

$ h5ls -d 2010.h5/params | more

$ goto h5 file on jupyterlab

#=========================================================================
##create container and run.

$ module load apptainer/1.3.6_gcc-11.5.0

$ singularity --version

$ vi nvidia-physicsnemo-25-03.def

$ singularity build nvidia-physicsnemo-25-03.sif nvidia-physicsnemo-25-03.def

$ vi physicsnemo/examples/weather/fcn_afno/conf/config.yaml, change
channels: from [0, 1, …, 19] to [0, 1] ;from Dataset
max_epoch: from 80 to 10
num_workers_train: from 8 to 1
num_workers_valida: from 8 to 1

$ vi physicsnemo/examples/weather/fcn_afno/train_era5.py, change
lr (learning rate): from 0.0005 to 0.000005

$ vi run_fcn_afno_1gpu1A100.sh, edit work directory

$ sbatch run_fcn_afno_1gpu1A100.sh

$$Outputs pytorch file (.pt) will be in the checkpoints/ folder.

$ ls -alh checkpoints/

rerun, delete all file in outputs directory.

$ rm -rf outputs/*