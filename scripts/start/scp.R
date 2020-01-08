# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


######################################
#### Script to start a MAgPIE run ####
######################################

library(lucode)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

#cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"

prefix <- "04_"

for (ssp in c("SSP2")) {
  
  cfg <- setScenario(cfg,c(ssp,"NDC"))
  cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-Budg600"
  cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-Budg600"
  #  cfg$gms$s15_elastic_demand <- 0
  cfg$gms$land <- "landmatrix_dec18"
  cfg$gms$s80_maxiter <- 20
  #  cfg$gms$land <- "feb15"
  #  cfg$gms$s80_optfile <- 0
  cfg$gms$processing <- "scp"
  
  for (scp in c("off","begr","sugar","mixed_fixed","mixed_free")) {
    cfg$title <- paste0(prefix,ssp,"_Budg600_scp_",scp)
    cfg$gms$c20_scp <- scp
    start_run(cfg,codeCheck=FALSE)
  }
  
}

