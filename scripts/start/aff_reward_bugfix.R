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
#  interest_rate(0.05)
  cfg$gms$s56_payment <- 0
  cfg$gms$s56_c_price_exp_aff <- 50 
  cfg$gms$s32_planing_horizon <- 50
#  cfg$gms$s32_aff_plantation <- 0
  cfg$gms$s56_buffer_aff <- 0.2
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
cfg$output <- c("rds_report","disaggregation")

#09 with high bioen_dem
#10 no bioen dem

prefix <- "bufix01"

for (ssp in c("SSP1")) {
  for (co2_price_path in c("Hotelling")) {
    for (forest_type in c(1)) {

    cfg <- setScenario(cfg,c(ssp,"NDC"))
    cfg$gms$c56_pollutant_prices <- "coupling"
    cfg$gms$c60_2ndgen_biodem <- "coupling"
    cfg$gms$c32_aff_policy <- "none"
    # cfg$gms$interest_rate <- "glo_jan16"
    # cfg$gms$c12_interest_rate <- "coupling"
    cfg$gms$land <- "feb15"
    cfg$gms$s15_elastic_demand <- 0
    cfg$gms$c60_biodem_level <- 0
    cfg$gms$s32_recur_cost <- 1
    cfg$gms$s32_aff_plantation <- forest_type
    
    if (forest_type==0) ftype="Natveg" else if (forest_type==1) ftype="Plantation"

    #  for (co2_price_scen in c("1p4C","1p5C","1p6C")) {
    file.copy(from = paste0("input/input_bioen_dem_",co2_price_path,".csv"), to = "modules/60_bioenergy/input/reg.2ndgen_bioenergy_demand.csv",overwrite = TRUE)
    file.copy(from = paste0("input/input_ghg_price_",co2_price_path,".cs3"), to = "modules/56_ghg_policy/input/f56_pollutant_prices_coupling.cs3",overwrite = TRUE)
    # if (bioen == "BioOn") {
    #   file.copy(from = paste0("input/input_bioen_dem_150EJ.csv"), to = "modules/60_bioenergy/input/reg.2ndgen_bioenergy_demand.csv",overwrite = TRUE)
    # } else if (bioen == "BioOff") {
    #   file.copy(from = paste0("input/input_bioen_dem_zero.csv"), to = "modules/60_bioenergy/input/reg.2ndgen_bioenergy_demand.csv",overwrite = TRUE)
    # }
    
    cfg <- reset(cfg)
    cfg$title <- paste0(prefix,"_",ssp,"_",co2_price_path,"_",ftype,"_default_fixedforever")
    start_run(cfg,codeCheck=FALSE)

    # if (ssp=="SSP1") {
    # cfg <- reset(cfg)
    # for (time_horizon in c(20,50,100)) {
    #   cfg$title <- paste0(prefix,"_",ssp,"_",co2_price_path,"_",ftype,"_timehorizon_",time_horizon,"yrs")
    #   cfg$gms$s32_planing_horizon <- time_horizon
    #   start_run(cfg,codeCheck=FALSE)
    # }
    # 
    # # cfg <- reset(cfg)
    # # for (discount in c(0.03,0.05,0.07)) {
    # #   cfg$title <- paste0(prefix,"_",ssp,"_",co2_price_path,"_",ftype,"_discountrate_",discount*100)
    # #   interest_rate(discount)
    # #   start_run(cfg,codeCheck=FALSE)
    # # }
    # 
    # cfg <- reset(cfg)
    # for (payment in c(0,2)) {
    #   if (payment==0) name="annual" else if (payment==1) name="begin" else if (payment==2) name="end" else if (payment==3) name="buffer"
    #   cfg$title <- paste0(prefix,"_",ssp,"_",co2_price_path,"_",ftype,"_payment_",name)
    #   cfg$gms$s56_payment <- payment
    #   start_run(cfg,codeCheck=FALSE)
    # }
    # 
    # cfg <- reset(cfg)
    # for (co2_price_exp in c(0,1)) {
    #   if (co2_price_exp==0) name="myopic" else if (co2_price_exp==1) name="foresight"
    #   cfg$title <- paste0(prefix,"_",ssp,"_",co2_price_path,"_",ftype,"_co2priceexp_",name)
    #   cfg$gms$s56_c_price_exp_aff <- co2_price_exp*cfg$gms$s32_planing_horizon
    #   start_run(cfg,codeCheck=FALSE)
    # }
    # 
    # # cfg <- reset(cfg)
    # # for (forest_type in c(0,1)) {
    # #   if (forest_type==0) name="natveg" else if (forest_type==1) name="plantation"
    # #   cfg$title <- paste0(prefix,"_",ssp,"_",co2_price_path,"_",ftype,"_foresttype_",name)
    # #   cfg$gms$s32_aff_plantation <- forest_type
    # #   start_run(cfg,codeCheck=FALSE)
    # # }
    # 
    # cfg <- reset(cfg)
    # for (buffer in c(0,0.2,0.4)) {
    #   cfg$title <- paste0(prefix,"_",ssp,"_",co2_price_path,"_",ftype,"_buffer_",buffer*100)
    #   cfg$gms$s56_buffer_aff <- buffer
    #   start_run(cfg,codeCheck=FALSE)
    # }
    # }
    
    }
  }
}
