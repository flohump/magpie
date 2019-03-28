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


getInput <- function(gdx) {
  a <- readGDX(gdx,"f56_pollutant_prices_coupling")
  write.magpie(a,"modules/56_ghg_policy/input/f56_pollutant_prices_coupling.cs3")
  a <- readGDX(gdx,"f60_bioenergy_dem_coupling")
  write.magpie(a,"modules/60_bioenergy/input/reg.2ndgen_bioenergy_demand.csv")
}


#start MAgPIE run
source("config/default.cfg")
cfg$results_folder <- "output/:title:"

cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp8p5-co2_rev34_c200_690d3718e151be1b450b394c1064b1c5.tgz",
               "rev4.14_690d3718e151be1b450b394c1064b1c5_magpie.tgz",
               "rev4.14_690d3718e151be1b450b394c1064b1c5_validation.tgz",
               "additional_data_rev3.68_FH.tgz",
               "calibration_H12_c200_12Sep18.tgz",
               "peatland_input_v1.tgz")
cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"/p/projects/landuse/users/florianh/data"=NULL),
                           getOption("magpie_repos"))

cfg$gms$peatland  <- "ipcc_2014_mar19"
cfg$gms$c56_pollutant_prices <- "coupling"
cfg$gms$c60_2ndgen_biodem <- "coupling"
cfg$gms$s56_ghgprice_start <- 2020
cfg$gms$c56_emis_policy <- "redd"
cfg$gms$s58_peatland_policy_horizon  <- 80
cfg$gms$land <- "dec18"

prefix <- "T74"

##SSP2
cfg$title <- paste(prefix,"Ref",sep="_")
cfg <- setScenario(cfg,c("SSP2","NPI"))
getInput("/p/projects/remind/runs/magpie4-2019-03-15-develop/output/r8423-C_NPi-mag-7/fulldata.gdx")
# cfg$gms$c56_pollutant_prices <- "SSP2-Ref-SPA0-V15-REMIND-MAGPIE"
# cfg$gms$c60_2ndgen_biodem <- "SSP2-Ref-SPA0"
cfg$gms$s56_peatland_policy <- 0
cfg$gms$s58_rewetting_switch  <- 0
start_run(cfg,codeCheck=FALSE)

getInput("/p/projects/remind/runs/magpie4-2019-03-15-develop/output/r8423-C_Budg600-mag-7/fulldata.gdx")
# cfg$gms$c56_pollutant_prices <- "SSP2-26-SPA2-V15-REMIND-MAGPIE"
# cfg$gms$c60_2ndgen_biodem <- "SSP2-26-SPA2"
cfg <- setScenario(cfg,c("SSP2","NDC"))


cfg$title <- paste(prefix,"CPol",sep="_")
cfg$gms$s56_peatland_policy <- 0
cfg$gms$s58_rewetting_switch  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"CPol+Pprot",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"CPol+Pprot+Prestor",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- Inf
start_run(cfg,codeCheck=FALSE)


cfg$gms$c60_2ndgen_biodem <- "SSP2-Ref-SPA0"

cfg$title <- paste(prefix,"CPol+Pprot_nobio",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"CPol+Pprot+Prestor_nobio",sep="_")
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting_switch  <- Inf
start_run(cfg,codeCheck=FALSE)
