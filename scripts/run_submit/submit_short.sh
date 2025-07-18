#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=mag-run
#SBATCH --output=slurm.log
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=3
#SBATCH --mem-per-cpu=5G
#SBATCH --time=24:00:00

Rscript submit.R
