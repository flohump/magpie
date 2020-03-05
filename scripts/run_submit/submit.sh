#!/bin/bash

#SBATCH --qos=priority
#SBATCH --job-name=mag-run
#SBATCH --output=full.log
#SBATCH --mail-type=END
#SBATCH --cpus-per-task=13
#SBATCH --partition=standard
#SBATCH --mem-per-cpu=10000

Rscript submit.R

