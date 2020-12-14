# |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: TEST
# ----------------------------------------------------------


######################################
#### Script to start a MAgPIE run ####
######################################

library(lucode2)
library(magclass)
library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE runs
source("config/default.cfg")

#cfg$force_download <- FALSE

cfg$results_folder <- "output/:title:"

cfg$output <- c("rds_report")

cfg <- gms::setScenario(cfg,c("SSP2","BASE"))
# cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-Budg600"
# cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-Budg600"

cfg$title <- paste0("T6_LCON8000_aug18_NPI")
cfg <- gms::setScenario(cfg,c("SSP2","NPI"))
cfg$gms$landconversion <- "global_static_aug18"
start_run(cfg,codeCheck=FALSE)
# 
# cfg$title <- paste0("T4_LCON8000_aug18_BASE")
# cfg <- gms::setScenario(cfg,c("SSP2","BASE"))
# cfg$gms$landconversion <- "global_static_aug18"
# start_run(cfg,codeCheck=FALSE)

cfg$title <- paste0("T6_LCON8000_dec20_NPI")
cfg <- gms::setScenario(cfg,c("SSP2","NPI"))
cfg$gms$landconversion <- "global_static_dec20"
# cfg$gms$s39_cost_establish <- 8000
# cfg$gms$s39_cost_establish_forestry <- 8000
start_run(cfg,codeCheck=FALSE)

# cfg$title <- paste0("T4_LCON8000_dec20_BASE")
# cfg <- gms::setScenario(cfg,c("SSP2","BASE"))
# cfg$gms$landconversion <- "global_static_dec20"
# cfg$gms$s39_cost_establish <- 8000
# cfg$gms$s39_cost_establish_forestry <- 8000
# start_run(cfg,codeCheck=FALSE)

# cfg$title <- paste0("T4_LCON4000_dec20_NPI")
# cfg <- gms::setScenario(cfg,c("SSP2","NPI"))
# cfg$gms$landconversion <- "global_static_dec20"
# cfg$gms$s39_cost_establish <- 4000
# cfg$gms$s39_cost_establish_forestry <- 4000
# start_run(cfg,codeCheck=FALSE)
# 
# cfg$title <- paste0("T4_LCON4000_dec20_BASE")
# cfg <- gms::setScenario(cfg,c("SSP2","BASE"))
# cfg$gms$landconversion <- "global_static_dec20"
# cfg$gms$s39_cost_establish <- 4000
# cfg$gms$s39_cost_establish_forestry <- 4000
# start_run(cfg,codeCheck=FALSE)

# for (x in seq(0, 8000, by=1000)) {
#   cfg$title <- paste0("T3_LCON_",x)
#   cfg$gms$s39_cost_establish <- x
#   cfg$gms$s39_cost_establish_forestry <- x
#   start_run(cfg,codeCheck=FALSE)
# }
