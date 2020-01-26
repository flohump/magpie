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
library(gdx)

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

reset <- function(cfg) {
  interest_rate(0.05)
  cfg$gms$s56_payment <- 0
  cfg$gms$s56_c_price_aff_future <- 1 
  cfg$gms$s32_planing_horizon <- 75
  return(cfg)
}

interest_rate <- function(target) {
  a <- new.magpie(years = c(1995,2020,2025,2150),fill=c(0.07,0.07,target,target))
  a <- time_interpolate(a,seq(1995,2150,by=5))
  write.magpie(a,paste0("modules/12_interest_rate/input/f12_interest_rate_coupling.csv"))
}


#start MAgPIE run
source("config/default.cfg")

#cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"
cfg <- setScenario(cfg,c("SSP2","NDC"))
cfg$gms$interest_rate <- "glo_jan16"
cfg$gms$c12_interest_rate <- "coupling"
# cfg$gms$c56_pollutant_prices <- "coupling"
# cfg$gms$c60_2ndgen_biodem <- "coupling"
getInput("/p/projects/piam/runs/coupled-magpie/output/C_SSP2-PkBudg900-mag-4/fulldata.gdx")
cfg$gms$land <- "feb15"
cfg$gms$s15_elastic_demand <- 0
prefix <- "rew04_"

for (co2_price_path in c("Hotelling","PeakBudget")) {
  if (co2_price_path=="PeakBudget") {
    cfg$gms$c56_pollutant_prices <- "coupling"
    cfg$gms$c60_2ndgen_biodem <- "coupling"
    getInput("/p/projects/piam/runs/coupled-magpie/output/C_SSP2-PkBudg900-mag-4/fulldata.gdx")
  } else if (co2_price_path == "Hotelling") {
    cfg$gms$c56_pollutant_prices <- "SSPDB-SSP2-26-REMIND-MAGPIE"
    cfg$gms$c60_2ndgen_biodem <- "SSPDB-SSP2-26-REMIND-MAGPIE"
  }

  cfg <- reset(cfg)
  for (time_horizon in c(10,20,30,50,75,100)) {
    cfg$title <- paste0(prefix,co2_price_path,"_timehorizon_",time_horizon)
    cfg$gms$s32_planing_horizon=time_horizon
    start_run(cfg,codeCheck=FALSE)
  }
  
  cfg <- reset(cfg)
  for (discount in c(0.01,0.03,0.05,0.07,0.1)) {
    cfg$title <- paste0(prefix,co2_price_path,"_interestrate_",discount*100)
    interest_rate(discount)
    start_run(cfg,codeCheck=FALSE)
  }
  
  cfg <- reset(cfg)
  for (payment in c(0,1,2,3)) {
    if (payment==0) name="annually" else if (payment==1) name="begin" else if (payment==2) name="end" else if (payment==3) name="buffer"
    cfg$title <- paste0(prefix,co2_price_path,"_payment_",name)
    cfg$gms$s56_payment=payment
    start_run(cfg,codeCheck=FALSE)
  }
  
  cfg <- reset(cfg)
  for (co2_price_exp in c(0,1)) {
    if (co2_price_exp==0) name="myopic" else if (co2_price_exp==1) name="perfect-foresight"
    cfg$title <- paste0(prefix,co2_price_path,"_co2priceexp_",name)
    cfg$gms$s56_c_price_aff_future=co2_price_exp
    start_run(cfg,codeCheck=FALSE)
  }
}
