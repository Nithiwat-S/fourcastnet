Data Download and Pre-Processing for Running FourCastNet on singularity

Thank, Yeo Su Yia, Denise(dyeosy98) - Amazon Web Services (AWS), https://github.com/dyeosy98

Downloading NSF NCAR Curated ECMWF Reanalysis 5 (ERA5) data via the Registry of Open Data on AWS and pre-processing it for training the FourCastNet model.

Process below.

$ git clone https://github.com/Nithiwat-S/fourcastnet.git

$ cd fourcastnet

$ python -m venv venv

$ source venv/bin/activate

$ pip install -r requirements.txt

$ vi config.yaml, change download_path, and your parameter.

$ python download.py, see data file in download_path.

$ python format.py, see data file in write_path.

$ mkdir -p data/train data/test data/stats

$ mv h5 file from write_path to data/train and data/test.

$ vi mean.py, change path = "/mnt/fcn/data/train" and np.save path.

$ python mean.py

$ vi std.py, change path = "/mnt/fcn/data/train" and np.save path.

$ python std.py


