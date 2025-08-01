from botocore.config import Config
import h5py
import os
import numpy as np
import yaml

def generate_params_list(config):

    pl_params = config["pl_params"]
    sfc_params = config["sfc_params"]
    pressure_levels = config["pressure_levels"]

    params = []

    for param in pl_params:
        for pressure_level in pressure_levels[param]:
            params.append(f'{param}{pressure_level}')
    for param in sfc_params:
        params.append(param)

    return params

def main():

    # Initialize config
    print("Initializing config...")
    with open('config.yaml', 'r') as file:
        config = yaml.safe_load(file)

    h5params = generate_params_list(config)

    #path = "/mnt/fcn/data/train"
    path = "../data/train"

    files = os.listdir(path)

    means = []
    stds = []

    for i in range(0, len(files)):
        
        with h5py.File(f'{path}/{files[i]}', 'r') as f:

            print(f'Calculating mean for {files[i]}...')
            print(f'=={f.keys()}==')

            keys = list(f.keys())
            data_key = keys[0]
            param_key = keys[1]

            print(f'=={f[data_key]}==')
            means.append(np.mean(f[data_key], (0, 2, 3))) # means[i] will be list of 34 

    #f[hour][param][latitude][longitude]
    #for every param, find mean of numbers for all hour, latitude, longitude

    print("Aggregating means...")
    # print("Aggregating stds...")
    for i in range(0, len(h5params)):

        params_means = np.mean(means, 0) 
        print(f'params_means ({np.shape(params_means)}): {params_means}')
        np.save(
            #"/mnt/fcn/data/stats/global_means.npy", params_means.reshape(1, -1, 1, 1)
            "../data/stats/global_means.npy", params_means.reshape(1, -1, 1, 1)
        )

        print(f'{h5params[i]} mean: {params_means[i]}')

if __name__ == "__main__":
    main()
