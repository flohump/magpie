#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=mag-run
#SBATCH --output=slurm.log
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=0

Rscript submit.R

