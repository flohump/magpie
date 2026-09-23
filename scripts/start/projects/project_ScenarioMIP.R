# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: ScenarioMIP runs
# position: 1
# ----------------------------------------------------------

## Load lucode2 and gms to use setScenario later
library(lucode2)
library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Source default cfg. This loads the object "cfg" in R environment
source("config/default.cfg")

# create additional information to describe the runs
cfg$info$flag <- "SMIP7"
cfg$qos <- "standby"

cfg$results_folder <- "output/:title:"
cfg$force_replace <- TRUE

# support function to create standardized title
.title <- function(cfg, ...) return(paste(cfg$info$flag, sep="_",...))

#download default input data (scenario names: input/SMIP7_README.md)
cfg$input[["report_coupling"]] <- "SMIP7_report_coupling.tgz"
# TEMPORARY: additional_data_rev4.73.tgz lacks f30_rotation_max/min.csv; remove once fixed
cfg$input[["additional"]] <- "additional_data_rev4.72.tgz"
download_and_update(cfg)

cfg$gms$c56_pollutant_prices <- "coupling"
cfg$gms$c60_2ndgen_biodem <- "coupling"
cfg$gms$c_timesteps <- "less_TS"
cfg$gms$cropland    <- "detail_apr24"
cfg$gms$som <- "cellpool_jan23"
cfg$gms$s15_elastic_demand <- 1
cfg$gms$s56_limit_ch4_n2o_price <- 734
cfg$gms$s32_annual_aff_limit <- 0.03

### Main scenarios

#H-SSP3 (GCAM marker)
cfg$title <- .title(cfg, "H-SSP3-main")
cfg <- setScenario(cfg,c("SSP3","NPI-revert","AR-natveg","nocc_hist"))
cfg$gms$c56_mute_ghgprices_until <- "y2150"
cfg$path_to_report_ghgprices <- "input/SMIP7-H-SSP3-main.mif"
cfg$path_to_report_bioenergy    <- "input/SMIP7-H-SSP3-main.mif"
cfg$gms$c15_food_scenario <- "SSP2"
cfg$gms$s32_npi_ndc_reversal <- 2030
cfg$gms$s35_npi_ndc_reversal <- 2030
cfg$gms$s29_treecover_target <- 0
cfg$gms$s44_bii_target <- 0
cfg$gms$c44_bii_decrease <- 1
cfg$gms$s44_start_year <- 2030
cfg$gms$s56_fader_cpriceaff_start <- 2030
cfg$gms$s56_fader_cpriceaff_end <- 2030
cfg$gms$s59_scm_target <- 0
cfg$gms$c60_1stgen_biodem <- "const2030"
start_run(cfg, codeCheck = FALSE)

#M-SSP2 (IMAGE marker)
cfg$title <- .title(cfg, "M-SSP2-main")
cfg <- setScenario(cfg,c("SSP2","NPI","AR-natveg","nocc_hist"))
cfg$gms$c56_mute_ghgprices_until <- "y2150"
cfg$path_to_report_ghgprices <- "input/SMIP7-M-SSP2-main.mif"
cfg$path_to_report_bioenergy    <- "input/SMIP7-M-SSP2-main.mif"
cfg$gms$s29_treecover_target <- 0
cfg$gms$s44_bii_target <- 0
cfg$gms$c44_bii_decrease <- 1
cfg$gms$s44_start_year <- 2030
cfg$gms$s56_fader_cpriceaff_start <- 2030
cfg$gms$s56_fader_cpriceaff_end <- 2030
cfg$gms$s59_scm_target <- 0
cfg$gms$c60_1stgen_biodem <- "const2030"
start_run(cfg, codeCheck = FALSE)

#ML-SSP2 (COFFEE marker)
cfg$title <- .title(cfg, "ML-SSP2-main")
cfg <- setScenario(cfg,c("SSP2","NPI","AR-natveg","nocc_hist"))
cfg$gms$c56_mute_ghgprices_until <- "y2040"
cfg$path_to_report_ghgprices <- "input/SMIP7-ML-SSP2-main.mif"
cfg$path_to_report_bioenergy    <- "input/SMIP7-ML-SSP2-main.mif"
cfg$gms$s29_treecover_target <- 0
cfg$gms$s44_bii_target <- 0
cfg$gms$c44_bii_decrease <- 1
cfg$gms$s44_start_year <- 2030
cfg$gms$s56_fader_cpriceaff_start <- 2030
cfg$gms$s56_fader_cpriceaff_end <- 2030
cfg$gms$s59_scm_target <- 0
cfg$gms$c60_1stgen_biodem <- "const2030"
start_run(cfg, codeCheck = FALSE)

#L-SSP2 (MESSAGEix-GLOBIOM-GAINS marker)
cfg$title <- .title(cfg, "L-SSP2-main")
cfg <- setScenario(cfg,c("SSP2","NDC","AR-natveg","nocc_hist"))
cfg$gms$c56_mute_ghgprices_until <- "y2030"
cfg$path_to_report_ghgprices <- "input/SMIP7-L-SSP2-main.mif"
cfg$path_to_report_bioenergy    <- "input/SMIP7-L-SSP2-main.mif"
cfg$gms$s29_treecover_scenario_start <- 2030
cfg$gms$s29_treecover_scenario_target <- 2050
cfg$gms$s29_treecover_target <- 0.01
cfg$gms$s44_bii_target <- 0
cfg$gms$c44_bii_decrease <- 0
cfg$gms$s44_start_year <- 2030
cfg$gms$s56_fader_cpriceaff_start <- 2030
cfg$gms$s56_fader_cpriceaff_end <- 2030
cfg$gms$s59_scm_scenario_start <- 2030
cfg$gms$s59_scm_scenario_target <- 2050
cfg$gms$s59_scm_target <- 0.1
cfg$gms$c60_1stgen_biodem <- "const2030"
start_run(cfg, codeCheck = FALSE)

#LN-SSP2 (AIM marker)
cfg$title <- .title(cfg, "LN-SSP2-main")
cfg <- setScenario(cfg,c("SSP2","NPI","AR-plant","nocc_hist"))
cfg$gms$c56_mute_ghgprices_until <- "y2030"
cfg$path_to_report_ghgprices <- "input/SMIP7-LN-SSP2-main.mif"
cfg$path_to_report_bioenergy    <- "input/SMIP7-LN-SSP2-main.mif"
cfg$gms$s29_treecover_scenario_start <- 2050
cfg$gms$s29_treecover_scenario_target <- 2070
cfg$gms$s29_treecover_target <- 0.02
cfg$gms$s44_bii_target <- 0
cfg$gms$c44_bii_decrease <- 0
cfg$gms$s44_start_year <- 2050
cfg$gms$s56_fader_cpriceaff_start <- 2040
cfg$gms$s56_fader_cpriceaff_end <- 2050
cfg$gms$s59_scm_scenario_start <- 2050
cfg$gms$s59_scm_scenario_target <- 2070
cfg$gms$s59_scm_target <- 0.2
cfg$gms$c60_1stgen_biodem <- "const2030"
start_run(cfg, codeCheck = FALSE)

#VL-SSP1 (REMIND-MAgPIE marker)
cfg$title <- .title(cfg, "VL-SSP1-main")
cfg <- setScenario(cfg,c("VLLO","NDC","AR-natveg","nocc_hist"))
cfg$gms$c56_mute_ghgprices_until <- "y2030"
cfg$path_to_report_ghgprices <- "input/SMIP7-VL-SSP1-main.mif"
cfg$path_to_report_bioenergy    <- "input/SMIP7-VL-SSP1-main.mif"
cfg$gms$s29_treecover_scenario_start <- 2025
cfg$gms$s29_treecover_scenario_target <- 2050
cfg$gms$s29_treecover_target <- 0.03
cfg$gms$s44_bii_target <- 0.7
cfg$gms$c44_bii_decrease <- 1
cfg$gms$s44_start_year <- 2030
cfg$gms$s56_fader_cpriceaff_start <- 2030
cfg$gms$s56_fader_cpriceaff_end <- 2030
cfg$gms$s59_scm_scenario_start <- 2025
cfg$gms$s59_scm_scenario_target <- 2050
cfg$gms$s59_scm_target <- 0.3
cfg$gms$c60_1stgen_biodem <- "const2030"
start_run(cfg, codeCheck = FALSE)
