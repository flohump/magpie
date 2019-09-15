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
library(luscale)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

getInput <- function(gdx,ghg_price=TRUE,biodem=TRUE) {
  if(ghg_price) {
    a <- readGDX(gdx,"f56_pollutant_prices_coupling")
    write.magpie(a,"modules/56_ghg_policy/input/f56_pollutant_prices_coupling.cs3")
  }
  if(biodem) {
    a <- readGDX(gdx,"f60_bioenergy_dem_coupling")
    write.magpie(a,"modules/60_bioenergy/input/reg.2ndgen_bioenergy_demand.csv")
  }
}


#start MAgPIE run
source("config/default.cfg")
cfg$results_folder <- "output/:title:"

cfg$force_download <- TRUE

cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp8p5-co2_rev34_c200_690d3718e151be1b450b394c1064b1c5.tgz",
               "rev4.14_690d3718e151be1b450b394c1064b1c5_magpie.tgz",
               "rev4.14_690d3718e151be1b450b394c1064b1c5_validation.tgz",
               "additional_data_rev3.68_FH.tgz",
               "calibration_H12_c200_12Sep18.tgz",
               "peatland_input_v1.tgz")
cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"/p/projects/landuse/users/florianh/data"=NULL),
                           getOption("magpie_repos"))

cfg$gms$peatland  <- "ipcc_2014_mar19"
#cfg$gms$peatland  <- "off"
cfg$gms$c56_pollutant_prices <- "coupling"
cfg$gms$c60_2ndgen_biodem <- "coupling"
cfg$gms$s56_ghgprice_start <- 2020
cfg$gms$c56_emis_policy <- "all_nosoil"
cfg$gms$s58_peatland_policy_horizon  <- 80
cfg$gms$land <- "feb15"
cfg$gms$s56_reward_neg_emis <- -Inf
cfg$gms$s80_optfile <- 1

prefix <- "T95"

##SSP2
cfg$title <- paste(prefix,"Ref",sep="_")
cfg <- setScenario(cfg,c("SSP2","NPI"))
getInput("/p/projects/remind/runs/magpie4-2019-04-02-develop/output/r8473-trunk-C_NPi-mag-4/fulldata.gdx")
# cfg$gms$c56_pollutant_prices <- "SSP2-Ref-SPA0-V15-REMIND-MAGPIE"
# cfg$gms$c60_2ndgen_biodem <- "SSP2-Ref-SPA0"
cfg$gms$s56_peatland_policy <- 0
cfg$gms$s58_rewetting_switch  <- 0
start_run(cfg,codeCheck=FALSE)

getInput("/p/projects/remind/runs/magpie4-2019-04-02-develop/output/r8473-trunk-C_Budg600-mag-4/fulldata.gdx")
# cfg$gms$c56_pollutant_prices <- "SSP2-26-SPA2-V15-REMIND-MAGPIE"
# cfg$gms$c60_2ndgen_biodem <- "SSP2-26-SPA2"
cfg <- setScenario(cfg,c("SSP2","NDC"))


cfg$title <- paste(prefix,"RCP1p9",sep="_")
cfg$gms$s56_peatland_policy <- 0
cfg$gms$s58_rewetting_switch  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"RCP1p9+PeatProt",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"RCP1p9+PeatRestor",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- Inf
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"RCP1p9+PeatRestor_2000",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- Inf
cfg$gms$s58_rewet_cost_onetime  <- 2000
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"RCP1p9+PeatRestor_4000",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- Inf
cfg$gms$s58_rewet_cost_onetime  <- 4000
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"RCP1p9+PeatRestor_8000",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- Inf
cfg$gms$s58_rewet_cost_onetime  <- 8000
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"RCP1p9+PeatRestor_10000",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- Inf
cfg$gms$s58_rewet_cost_onetime  <- 10000
start_run(cfg,codeCheck=FALSE)

getInput("/p/projects/remind/runs/magpie4-2019-04-02-develop/output/r8473-trunk-C_NPi-mag-4/fulldata.gdx",biodem=TRUE,ghg_price = FALSE)
cfg$gms$c56_emis_policy <- "none"

cfg$title <- paste(prefix,"Ref+PeatProt",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- 0
cfg$gms$s56_aff_policy <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"Ref+PeatRestor",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- Inf
cfg$gms$s56_aff_policy <- 0
start_run(cfg,codeCheck=FALSE)
