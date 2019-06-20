# |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
# |  authors, and contributors see AUTHORS file
# |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
# |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
# |  Contact: magpie@pik-potsdam.de


######################################
#### Script to start a MAgPIE run ####
######################################

library(lucode)
library(magclass)
library(gdx)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")
cfg$results_folder <- "output/:title:"
cfg$recalibrate <- FALSE

cfg$gms$land <- "dec18"
cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp8p5-co2_rev34_c200_690d3718e151be1b450b394c1064b1c5.tgz",
               "rev4.18_690d3718e151be1b450b394c1064b1c5_magpie.tgz",
               "rev4.18_690d3718e151be1b450b394c1064b1c5_validation.tgz",
               "additional_data_rev3.67.tgz",
#               "calibration_H12_c200_12Sep18.tgz",
               "calibration_H12_c200_LPJmL5_LAI_20Jun19.tgz")

#turn on CC
cfg$gms$c14_yields_scenario  <- "cc"
cfg$gms$c42_watdem_scenario  <- "cc"
cfg$gms$c52_carbon_scenario  <- "cc"
cfg$gms$c59_som_scenario  <- "cc"

cfg$recalibrate <- FALSE

#"NorESM1_M","GFDL_ESM2M","MIROC_ESM_CHEM","HadGEM2_ES"
for (climatemodel in c("IPSL_CM5A_LR")) {
  #SSP2 Ref CC
  cfg$title <- paste0("SSP2_RCP60_LPJmL5")
  cfg$input[1] <- paste0("LPJmL5_LAI-",climatemodel,"-rcp6p0_rev34_c200_690d3718e151be1b450b394c1064b1c5.tgz")
  #cfg$input[1] <- paste0("isimip_rcp-",climatemodel,"-rcp6p0-co2_rev34_c200_690d3718e151be1b450b394c1064b1c5.tgz")
  cfg <- setScenario(cfg,c("SSP2","NPI"))
  cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-NPi"
  cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-NPi"
  #start_run(cfg,codeCheck=FALSE)
  
  ##SSP2 26 CC
  cfg$title <- paste0("SSP2_RCP26_LPJmL5")
  cfg$input[1] <- paste0("LPJmL5_LAI-",climatemodel,"-rcp2p6_rev34_c200_690d3718e151be1b450b394c1064b1c5.tgz")
  #cfg$input[1] <- paste0("isimip_rcp-",climatemodel,"-rcp2p6-co2_rev34_c200_690d3718e151be1b450b394c1064b1c5.tgz")
  cfg <- setScenario(cfg,c("SSP2","NDC"))
  cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-Budg950"
  cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-Budg950"
  start_run(cfg,codeCheck=FALSE)
}
  
