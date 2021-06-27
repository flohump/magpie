# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: Paper Climate vs. Nature
# ----------------------------------------------------------


######################################
#### Script to start a MAgPIE run ####
######################################

library(gms)
library(lucode2)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")
source("scripts/start/extra/lpjml_addon.R")
#cfg$gms$c52_carbon_scenario  <- "nocc"
#cfg$gms$c59_som_scenario  <- "nocc"

#cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"
cfg$output <- c("rds_report","extra/disaggregation")

prefix <- "CN01"
cfg$qos <- "priority"

cfg$gms$s80_optfile <- 1
cfg$gms$s80_maxiter <- 30

cfg$gms$s32_planing_horizon <- 50

#cfg$gms$c56_emis_policy <- "redd+_nosoil"
#cfg$gms$s56_ghgprice_phase_in <- 1

#ref
for (pol in c("Ref","Climate","Nature","Climate+Nature")) {
  for (ssp in c("SSP2")) {
    if (pol == "Ref") {
      cfg <- setScenario(cfg,c(ssp,"NPI"))
      cfg$input[grep("cellularmagpie", cfg$input)] <- "rev4.62_h12_6f938f85_cellularmagpie_c200_MRI-ESM2-0-ssp460_lpjml-ab83aee4.tgz"
      cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-NPi"
      cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-NPi"
      cfg$gms$s32_aff_plantation <- 0
      cfg$gms$s32_aff_bii_coeff <- 0
      cfg$gms$c44_price_bv_loss <- "p0"
      cfg$gms$c35_protect_scenario <- "WDPA"
      cfg$gms$c30_set_aside_target <- "none"
      cfg$gms$s30_set_aside_shr <- 0
    } else if (pol == "Climate") {
      cfg <- setScenario(cfg,c(ssp,"NDC"))
      cfg$input[grep("cellularmagpie", cfg$input)] <- "rev4.62_h12_57347947_cellularmagpie_c200_MRI-ESM2-0-ssp119_lpjml-ab83aee4.tgz"
      cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-PkBudg900"
      cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-PkBudg900"
      cfg$gms$s32_aff_plantation <- 1
      cfg$gms$s32_aff_bii_coeff <- 1
      cfg$gms$c44_price_bv_loss <- "p0"
      cfg$gms$c35_protect_scenario <- "WDPA"
      cfg$gms$c30_set_aside_target <- "none"
      cfg$gms$s30_set_aside_shr <- 0
    } else if (pol == "Nature") {
      cfg <- setScenario(cfg,c(ssp,"NDC"))
      cfg$input[grep("cellularmagpie", cfg$input)] <- "rev4.62_h12_57347947_cellularmagpie_c200_MRI-ESM2-0-ssp119_lpjml-ab83aee4.tgz"
      cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-NPi"
      cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-NPi"
      cfg$gms$s32_aff_plantation <- 0
      cfg$gms$s32_aff_bii_coeff <- 0
      cfg$gms$c44_price_bv_loss <- "p3000" #"p10_p10000"
      cfg$gms$c35_protect_scenario <- "FF_BH"
      cfg$gms$c30_set_aside_target <- "by2030"
      cfg$gms$s30_set_aside_shr <- 0.2
    } else if (pol == "Climate+Nature") {
      cfg <- setScenario(cfg,c(ssp,"NDC"))
      cfg$input[grep("cellularmagpie", cfg$input)] <- "rev4.62_h12_57347947_cellularmagpie_c200_MRI-ESM2-0-ssp119_lpjml-ab83aee4.tgz"
      cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-PkBudg900"
      cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-NPi"
      cfg$gms$s32_aff_plantation <- 0
      cfg$gms$s32_aff_bii_coeff <- 0
      cfg$gms$c44_price_bv_loss <- "p3000" #"p10_p10000"
      cfg$gms$c35_protect_scenario <- "FF_BH"
      cfg$gms$c30_set_aside_target <- "by2030"
      cfg$gms$s30_set_aside_shr <- 0.2
    } 
    cfg$title <- paste(prefix,paste0(ssp,"-",pol),sep="_")
    start_run(cfg,codeCheck=FALSE)
  }
}
