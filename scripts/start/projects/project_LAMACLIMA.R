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

#cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"
cfg$output <- c("rds_report","extra/disaggregation","extra/disaggregation_transitions")

prefix <- "LAMA09"
cfg$gms$s80_optfile <- 1
cfg$gms$s80_maxiter <- 5

cfg$gms$s15_elastic_demand <- 0

#https://miro.com/app/board/o9J_lVys8js=/

#Scenario 1, based on SDP
cfg$title <- paste(prefix,"SSP1-1p5deg",sep="_")
cfg <- setScenario(cfg,c("SDP","NDC","ForestryOff"))
cfg$gms$c35_protect_scenario <- "WDPA"
#cfg$gms$s35_secdf_distribution <- 0
#1.5 degree policy
cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-Budg600"
cfg$gms$c56_pollutant_prices_noselect <- "R2M41-SSP2-NPi"
cfg$gms$policy_countries56  <- all_iso_countries
cfg$gms$s56_ghgprice_phase_in <- 1
cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-Budg600"
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
cfg$gms$s32_max_aff_area <- 500
cfg$gms$c32_aff_mask <- "noboreal"
#EFP
cfg$gms$c42_env_flow_policy <- "on"
cfg$gms$EFP_countries  <- all_iso_countries
start_run(cfg,codeCheck=FALSE)

#Scenario 2, based on SSP4
cfg$title <- paste(prefix,"SSP4-1p5deg",sep="_")
cfg <- setScenario(cfg,c("SSP4","NDC","ForestryOff"))
cfg$gms$c35_protect_scenario <- "WDPA"
#cfg$gms$s35_secdf_distribution <- 0
#1.5 degree policy
cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-Budg600"
cfg$gms$c56_pollutant_prices_noselect <- "R2M41-SSP2-NPi"
cfg$gms$policy_countries56  <- all_iso_countries#oecd_countries #todo
cfg$gms$s56_ghgprice_phase_in <- 1
cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-Budg600"
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
cfg$gms$scen_countries15  <- oecd_countries #todo
#AFF
cfg$gms$s32_planing_horizon <- 50
cfg$gms$s32_aff_plantation <- 1
cfg$gms$s32_max_aff_area <- Inf
cfg$gms$c32_aff_mask <- "noboreal"
#EFP
cfg$gms$c42_env_flow_policy <- "on"
cfg$gms$EFP_countries  <- oecd_countries #todo
start_run(cfg,codeCheck=FALSE)

