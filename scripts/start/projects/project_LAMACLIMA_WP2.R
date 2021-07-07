# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: LAMACLIMA WP2 runs
# ----------------------------------------------------------

######################################
#### Script to start a MAgPIE run ####
######################################

#https://www.oecd-ilibrary.org/docserver/9789264243439-8-en.pdf?expires=1620650049&id=id&accname=guest&checksum=7D894DDBF0C64FCC776D3AE6014FA9F0
oecd_countries <- "AUS,AUT,BEL,CAN,CHL,CZE,DNK,EST,FIN,FRA,DEU,GRC,HUN,ISL,IRL,ISR,ITA,JPN,KOR,LUX,MEX,NLD,NOR,POL,PRT,SVK,ESP,SWE,CHE,TUR,GBR,USA"

library(gms)
library(magclass)
library(gdx)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")
source("scripts/start/extra/lpjml_addon.R")
cfg$input <- c(cellular = "rev4.61labourprodtest_h12_42b44dcd_cellularmagpie_debug_c200_GFDL-ESM4-ssp370_lpjml-ab83aee4.tgz",
               regional = "rev4.61labourprodtest_h12_magpie_debug.tgz",
               validation = "rev4.61labourprodtest_h12_validation_debug.tgz",
               calibration = "calibration_H12_newlpjml_bestcalib_fc-sticky-dynamic_crop-endoApr21-allM_20May21.tgz",
               additional = cfg$input[grep("additional_data", cfg$input)])
#cfg$gms$c52_carbon_scenario  <- "nocc"
#cfg$gms$c59_som_scenario  <- "nocc"

cfg$gms$labor_prod <- "on"
cfg$gms$factor_costs <- "sticky_labour_jul21"
cfg$force_replace <- TRUE
#cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"
cfg$output <- c("rds_report","extra/disaggregation")

cfg$gms$crop    <- "exo"
cfg$gms$s30_adjustment_cost <- 0

prefix <- "WP2"
cfg$force_replace <- TRUE

cfg$gms$s80_optfile <- 1
cfg$gms$s80_maxiter <- 30
cfg$gms$s35_forest_damage <- 2

cfg$qos <- "priority"

#Scenario 2, based on SSP4
cfg$title <- paste(prefix,"Inequality","StickyDyn","LabCCon",sep="_")
cfg <- setScenario(cfg,c("SSP4","NDC","ForestryEndo"))
cfg$gms$c38_sticky_mode <- "dynamic"
cfg$gms$c37_labour_switch <- "cc"
cfg$gms$c35_protect_scenario <- "FF_BH"
cfg$gms$c35_protect_scenario_noselect <- "WDPA"
cfg$gms$policy_countries35  <- oecd_countries
cfg$gms$s30_set_aside_shr <- 0.2
cfg$gms$s30_set_aside_shr_noselect <- 0
cfg$gms$c30_set_aside_target <- "by2030"
cfg$gms$policy_countries30 <- oecd_countries
cfg$gms$c35_forest_damage_end <- "by2030"
#cfg$gms$s35_secdf_distribution <- 0
#1.5 degree policy
cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-PkBudg900"
cfg$gms$c56_pollutant_prices_noselect <- "R2M41-SSP2-NPi"
cfg$gms$policy_countries56  <- oecd_countries
cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-PkBudg900"
#default food scenario
cfg$gms$c15_food_scenario <- "SSP4"
cfg$gms$c15_food_scenario_noselect <- "SSP4"
#exo diet and waste
cfg$gms$c15_exo_scen_targetyear <- "y2050"
cfg$gms$s15_exo_diet <- 1
cfg$gms$c15_EAT_scen <- "FLX"
cfg$gms$c15_kcal_scen <- "healthy_BMI"
cfg$gms$s15_exo_waste <- 1
cfg$gms$s15_waste_scen <- 1.2
cfg$gms$scen_countries15  <- oecd_countries
#AFF
cfg$gms$s32_planing_horizon <- 50
cfg$gms$s32_aff_plantation <- 0
cfg$gms$s32_aff_bii_coeff <- 0
cfg$gms$s32_max_aff_area <- Inf
cfg$gms$c32_aff_mask <- "noboreal"
#EFP
cfg$gms$c42_env_flow_policy <- "on"
cfg$gms$EFP_countries  <- oecd_countries
#AWM
cfg$gms$c50_scen_neff <- "neff75_80_starty2010"
cfg$gms$c50_scen_neff_noselect <- "neff65_70_starty2010"
cfg$gms$cropneff_countries  <- oecd_countries
#Fert
cfg$gms$c55_scen_conf <- "ssp1"
cfg$gms$c55_scen_conf_noselect <- "ssp4"
cfg$gms$scen_countries55  <- oecd_countries
#irrig
cfg$gms$s42_irrig_eff_scenario <- 3
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"Inequality","StickyFix","LabCCon",sep="_")
cfg$gms$c38_sticky_mode <- "fixed"
cfg$gms$c37_labour_switch <- "cc"
cfg$gms$s30_adjustment_cost <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"Inequality","StickyFix","LabCCoff",sep="_")
cfg$gms$c38_sticky_mode <- "fixed"
cfg$gms$c37_labour_switch <- "nocc"
cfg$gms$s30_adjustment_cost <- 0
cfg$sequential <- TRUE
start_run(cfg,codeCheck=FALSE)

x<-readGDX(paste0("output/",cfg$title,"/fulldata.gdx"),"ov_area",select=list(type="level"))
write.magpie(x,"modules/30_crop/exo/input/f30_croparea.cs3")
# files <- Sys.glob(paste0("output/",cfg$title,"/","*.gdx"))
# file.copy(files,to = ".",overwrite = TRUE)
# cfg$files2export$start <- c(cfg$files2export$start,"*.gdx")
cfg$sequential <- FALSE

cfg$title <- paste(prefix,"Inequality","StickyFix","LabCCon","CropFix10000",sep="_")
cfg$gms$c38_sticky_mode <- "fixed"
cfg$gms$c37_labour_switch <- "cc"
cfg$gms$s30_adjustment_cost <- 10000
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"Inequality","StickyFix","LabCCon","CropFix50000",sep="_")
cfg$gms$c38_sticky_mode <- "fixed"
cfg$gms$c37_labour_switch <- "cc"
cfg$gms$s30_adjustment_cost <- 50000
start_run(cfg,codeCheck=FALSE)


cfg$title <- paste(prefix,"Inequality","StickyFix","LabCCon","CropFix100000",sep="_")
cfg$gms$c38_sticky_mode <- "fixed"
cfg$gms$c37_labour_switch <- "cc"
cfg$gms$s30_adjustment_cost <- 100000
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"Inequality","StickyFix","LabCCon","CropFix1000000",sep="_")
cfg$gms$c38_sticky_mode <- "fixed"
cfg$gms$c37_labour_switch <- "cc"
cfg$gms$s30_adjustment_cost <- 1000000
start_run(cfg,codeCheck=FALSE)
