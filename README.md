Instructions for reproduction:

## Download raw data from SRA
1. Download raw fastq files from SRA. A download script contatining the accession list is included in the `00_raw` directory (requires fasterq-dump from the [SRA Toolkit](https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit)).

2. Run `00_raw/rename.sh` to rename files.

## Set up snakemake environment
1. Install conda if not already installed. [Mamba/miniforge3](https://github.com/conda-forge/miniforge) recommended.

2. Set up the snakemake environment. In the main repo directory run:
    ```
    conda env create -f envs/snakemake.yml
    ```

3. Activate environment after setup completes:
    ```
    conda activate snakemake
    ```
## Run processing pipeline
Pipeline execution will differ if it's run locally on your machine vs on a computing cluster using SLURM.
### a) Run locally
#### Snakemake pipeline

> [!IMPORTANT]
> Adjust the number of available CPU cores (-c flag in snakemake commands below) and RAM (AVAILABLE_MEM variable in Snakefile, default is 32G) to your machine's capabilities!

1. Run a dry run first to verify that all the prerequisites are in place:
    ```
    snakemake --use-conda -c 16 -n
    ```

2. If no errors are reported, proceed with run:
    ```
    snakemake --use-conda -c 16
    ```
    Note: The initial setup of conda environments required for the pipeline might take considerable time.


#### Microdeletion script
3. Set up and activate the jupyter-trxtools environment:
    ```
    conda env create -f envs/jupyter-trxtools.yml
    ```
    After setup completes:
    ```
    conda activate jupyter-trxtools
    ```
4. Run the microdeletion script to create BigWigs with crosslink sites:
    ```
    ./BigWig_del.sh
    ```
5. Proceed to **Analysis using jupyter notebooks** below.

### b) Run on cluster using SLURM
#### Snakemake pipeline

> [!IMPORTANT]
> Adjust the number of available CPU cores (-c flag in snakemake commands below), concurrent jobs (-j flag in snakemake commands) and RAM (AVAILABLE_MEM variable in Snakefile, default is 32G) to your cluster's capabilities!

1. Run a dry run first to verify that all the prerequisites are in place:
    ```
    snakemake --slurm --use-conda -c 48 -j 24 -n
    ```

2. If no errors are reported, proceed with run:
    ```
    snakemake --slurm --use-conda -c 48 -j 24
    ```
    Note: The initial setup of conda environments required for the pipeline might take considerable time.


#### Microdeletion script
3. Set up and activate the jupyter-trxtools environment:
    ```
    conda env create -f envs/jupyter-trxtools.yml
    ```
    After setup completes:
    ```
    conda activate jupyter-trxtools
    ```
4. Run the microdeletion script to create BigWigs with crosslink sites:
    ```
    srun BigWig_del_srun.sh
    ```
5. Proceed to **Analysis using Jupyter notebooks** below.

## Analysis using Jupyter notebooks
The jupyter-trxtools environment comes with all the packages required for analysis, as well as jupyter with the jupyter-lab extension:
```
jupyter-lab
```

You can use jupyter-lab to open the whole project directory, then navigate to the `05_notebooks` directory in jupyter's file browser and run the notebooks.

When using VS Code or similar, remember to use the `jupyter-trxtools` environment as the python kernel.