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

cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"

for (res in c("c200","c600","c1000","c10000")) {
  for (opt in c("nlp_apr17","nlp_par")) {
    cfg$input <- c(paste0("isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev42_",res,"_690d3718e151be1b450b394c1064b1c5.tgz"),
                   "rev4.42_690d3718e151be1b450b394c1064b1c5_magpie.tgz",
                   "rev4.42_690d3718e151be1b450b394c1064b1c5_validation.tgz",
                   "calibration_H12_c200_26Feb20.tgz",
                   "additional_data_rev3.77.tgz")
    
    cfg$title <- paste0("res_SSP2_",res,"_",opt)
    cfg <- setScenario(cfg,c("SSP2","NPI"))
    cfg$gms$optimization <- opt
    start_run(cfg,codeCheck=FALSE)
  }
}
  
