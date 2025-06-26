## Data Download and Pre-Processing for Running FourCastNet on singularity

Thank, Yeo Su Yia, Denise(dyeosy98) - Amazon Web Services (AWS), https://github.com/dyeosy98

Downloading NSF NCAR Curated ECMWF Reanalysis 5 (ERA5) data via the Registry of Open Data on AWS and pre-processing it for training the FourCastNet model.


## Process below.

#=========================================================================
##get code.

$ git clone https://github.com/Nithiwat-S/fourcastnet.git

$ cd fourcastnet

#=========================================================================
##get data.

$ module load Anaconda3/2024.10_gcc-11.5.0

$ source activate

$ conda env list

$ conda env remove --name env_xxxx

$ conda create -n env_era5-download python=3.11

$ conda activate env_era5-download

$ cd aws-era5-download-script

$ ls -al requirements.txt

$ pip install -r requirements.txt

$ mkdir -p ../aws_era5_data/era5_data

$ mkdir -p ../aws_era5_data/data_processed

$ more download.yaml.org

$ more download.yaml, change months = ['01']

$ more config.yaml.org

$ more config.yaml, change download_path, write_path and your parameter.

$ python download.py, see data file in download_path.

$ python format.py, see data file in write_path.

$ mkdir -p ../data/train ../data/test ../data/stats

$ mv ../aws_era5_data/data_processed/2010.h5 ../data/train/

$ mv ../aws_era5_data/data_processed/2011.h5 ../data/test/

$ more mean.py, change path = "/mnt/fcn/data/train" and np.save path to ../data/stats.

$ python mean.py

$ more std.py, change path = "/mnt/fcn/data/train" and np.save path to ../data/stats.

$ python std.py

$ ls -la ../data/*/

$ h5dump -H -A 0 ../data/train/2010.h5

$ h5ls -v ../data/train/2010.h5/params and see Dataset {2/2}

$ open h5 file on jupyterlab

#=========================================================================
##config model (from https://github.com/NVIDIA/physicsnemo/tree/main/examples/weather/fcn_afno)

$ more fourcastnet/fcn_afno/conf/config.yaml, change

channels: from [0, 1, …, 19] to [0, 1] ;from Dataset

max_epoch: from 80 to 10

num_workers_train: from 8 to 1

num_workers_valida: from 8 to 1

$ more fourcastnet/fcn_afno/train_era5.py, change

lr (learning rate): from 0.0005 to 0.000005

#=========================================================================
##create container and run.

$ module load apptainer/1.3.6_gcc-11.5.0

$ apptainer --version

$ cd fourcastnet/run

$ more nvidia-physicsnemo-25-03.def

$ apptainer build nvidia-physicsnemo-25-03.sif nvidia-physicsnemo-25-03.def

$ ls -alh

$$$run physicsnemo-25----------

    $ more run_fcn_afno_1gpu1A100.sh, edit work directory

    $ sbatch run_fcn_afno_1gpu1A100.sh

$$$run physicsnemo-24----------

    $ rsync -av /lustre-home/gpu/home/research/nithiwat-r/fourcastnet/run/nvidia-modulus-24-12.sif .

    $ ls -alh
    
    $ more run_fcn_afno_1gpu1V100.sh, edit work directory

    $ sbatch run_fcn_afno_1gpu1V100.sh

$ squeue

$ cat fcn_afno-*.out

#=========================================================================
##model output. Outputs pytorch file (.pt) will be in the checkpoints/ folder.

$ ls -alh ../fcn_afno/checkpoints

$ ls -alh ../fcn_afno-24/checkpoints

rerun, delete all file in outputs directory.

$ rm -rf outputs/*

$ sbatch run_fcn_afno_1gpu1A100.sh
