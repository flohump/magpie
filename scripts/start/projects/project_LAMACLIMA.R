# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: LAMACLIMA WP4 runs
# ----------------------------------------------------------

######################################
#### Script to start a MAgPIE run ####
######################################

#https://www.oecd-ilibrary.org/docserver/9789264243439-8-en.pdf?expires=1620650049&id=id&accname=guest&checksum=7D894DDBF0C64FCC776D3AE6014FA9F0
oecd_countries <- "AUS,AUT,BEL,CAN,CHL,CZE,DNK,EST,FIN,FRA,DEU,GRC,HUN,ISL,IRL,ISR,ITA,JPN,KOR,LUX,MEX,NLD,NOR,POL,PRT,SVK,ESP,SWE,CHE,TUR,GBR,USA"

library(gms)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")
source("scripts/start/extra/lpjml_addon.R")
cfg$input <- c(cfg$input[grep("additional_data", cfg$input)],
               "rev4.61labourprodtest_h12_magpie_debug.tgz",
               "rev4.61labourprodtest_h12_42b44dcd_cellularmagpie_debug_c200_GFDL-ESM4-ssp370_lpjml-ab83aee4.tgz",
               "rev4.61labourprodtest_h12_validation_debug.tgz",
               "calibration_H12_newlpjml_bestcalib_fc-sticky-dynamic_crop-endoApr21-allM_20May21.tgz")
cfg$gms$c52_carbon_scenario  <- "nocc"
cfg$gms$c59_som_scenario  <- "nocc"

cfg$gms$labor_prod <- "on"
cfg$gms$factor_costs <- "sticky_labour_jun21"
cfg$force_replace <- TRUE
#cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"
cfg$output <- c("rds_report","extra/disaggregation","extra/disaggregation_transitions")

prefix <- "LAMA26"
#cfg$gms$c37_labour_switch <- "nocc"

cfg$gms$s80_optfile <- 1
cfg$gms$s80_maxiter <- 30

cfg$qos <- "priority"

#https://miro.com/app/board/o9J_lVys8js=/

#Scenario 1, based on SDP
cfg$title <- paste(prefix,"Sustainability",sep="_")
cfg <- setScenario(cfg,c("SDP","NDC","ForestryEndo"))
cfg$gms$c35_protect_scenario <- "FF_BH"
cfg$gms$c35_protect_scenario_noselect <- "FF_BH"
cfg$gms$policy_countries35  <- all_iso_countries
cfg$gms$s30_set_aside_shr <- 0.2
cfg$gms$s30_set_aside_shr_noselect <- 0.2
cfg$gms$c30_set_aside_target <- "by2030"
cfg$gms$policy_countries30 <- all_iso_countries
cfg$gms$c35_forest_damage_end <- "by2030"
#cfg$gms$s35_secdf_distribution <- 0
#1.5 degree policy
cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-PkBudg900"
cfg$gms$c56_pollutant_prices_noselect <- "R2M41-SSP2-NPi"
cfg$gms$policy_countries56  <- all_iso_countries
cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-PkBudg900"
#default food scenario
cfg$gms$c15_food_scenario <- "SSP1"
cfg$gms$c15_food_scenario_noselect <- "SSP1"
#exo diet and waste
cfg$gms$c15_exo_scen_targetyear <- "y2050"
cfg$gms$s15_exo_diet <- 1
cfg$gms$c15_EAT_scen <- "FLX"
cfg$gms$c15_kcal_scen <- "healthy_BMI"
cfg$gms$s15_exo_waste <- 1
cfg$gms$s15_waste_scen <- 1.2
cfg$gms$scen_countries15  <- all_iso_countries
#AFF
cfg$gms$s32_planing_horizon <- 50
cfg$gms$s32_aff_plantation <- 0
cfg$gms$s32_aff_bii_coeff <- 0
cfg$gms$s32_max_aff_area <- 500
cfg$gms$c32_aff_mask <- "noboreal"
#EFP
cfg$gms$c42_env_flow_policy <- "on"
cfg$gms$EFP_countries  <- all_iso_countries
#AWM
cfg$gms$c50_scen_neff <- "neff75_80_starty2010"
cfg$gms$c50_scen_neff_noselect <- "neff75_80_starty2010"
cfg$gms$cropneff_countries  <- all_iso_countries
#Fert
cfg$gms$c55_scen_conf <- "ssp1"
cfg$gms$c55_scen_conf_noselect <- "ssp1"
cfg$gms$scen_countries55  <- all_iso_countries
#irrig
cfg$gms$s42_irrig_eff_scenario <- 3
start_run(cfg,codeCheck=FALSE)

#Scenario 2, based on SSP4
cfg$title <- paste(prefix,"Inequality",sep="_")
cfg <- setScenario(cfg,c("SSP4","NDC","ForestryEndo"))
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
cfg$gms$s32_aff_plantation <- 1
cfg$gms$s32_aff_bii_coeff <- 1
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

cfg$title <- paste(prefix,"Inequality_NatAff",sep="_")
cfg$gms$s32_aff_plantation <- 0
cfg$gms$s32_aff_bii_coeff <- 0
start_run(cfg,codeCheck=FALSE)


