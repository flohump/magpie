# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


# ----------------------------------------------------------
# description: TEST LU SPA
# ----------------------------------------------------------

library(gms)
library(magclass)
library(gdx)
library(luscale)
library(magpie4)

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
source("scripts/start/extra/lpjml_addon.R")

cfg$results_folder <- "output/:title:"
cfg$output <- c("rds_report")
#download_and_update(cfg)

prefix <- "LU06"

# #SSP1
# cfg$title <- paste(prefix,"SSP1","REF","SPA0",sep="_")
# cfg <- setScenario(cfg,c("SSP1","NPI"))
# cfg$gms$c56_pollutant_prices <- "R21M42-SSP1-NPi"
# cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP1-NPi"
# start_run(cfg,codeCheck=FALSE)
# 
# cfg$title <- paste(prefix,"SSP1","1p5deg","SPA1",sep="_")
# cfg <- setScenario(cfg,c("SSP1","NDC"))
# cfg$gms$c56_pollutant_prices <- "R21M42-SSP1-PkBudg900"
# cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP1-PkBudg900"
# start_run(cfg,codeCheck=FALSE)
# 
# #SSP2
# cfg$title <- paste(prefix,"SSP2","REF","SPA0",sep="_")
# cfg <- setScenario(cfg,c("SSP2","NPI"))
# cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-NPi"
# cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-NPi"
# start_run(cfg,codeCheck=FALSE)
# 
# cfg$title <- paste(prefix,"SSP2","1p5deg","SPA2",sep="_")
# cfg <- setScenario(cfg,c("SSP2","NDC"))
# cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-PkBudg900"
# cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-PkBudg900"
# start_run(cfg,codeCheck=FALSE)
# 
# cfg$title <- paste(prefix,"SSP2","1p5deg","SPA0",sep="_")
# cfg <- setScenario(cfg,c("SSP2","NDC"))
# cfg$gms$c56_lu_spa <- "none"
# cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-PkBudg900"
# cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-PkBudg900"
# start_run(cfg,codeCheck=FALSE)
# 
#SSP5
cfg$title <- paste(prefix,"SSP5","REF","SPA0","CHECK2",sep="_")
cfg <- setScenario(cfg,c("SSP5","NPI"))
cfg$gms$c56_pollutant_prices <- "R21M42-SSP5-NPi"
cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP5-NPi"
start_run(cfg,codeCheck=FALSE)

# cfg$title <- paste(prefix,"SSP5","1p5deg","SPA5",sep="_")
# cfg <- setScenario(cfg,c("SSP5","NDC"))
# cfg$gms$c56_pollutant_prices <- "R21M42-SSP5-PkBudg900"
# cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP5-PkBudg900"
# cfg$gms$c60_biodem_level <- 0 #otherwise infeasible
# start_run(cfg,codeCheck=FALSE)
# 
# cfg$title <- paste(prefix,"SSP5","1p5deg","SPA0",sep="_")
# cfg <- setScenario(cfg,c("SSP5","NDC"))
# cfg$gms$c56_lu_spa <- "none"
# cfg$gms$s32_aff_plantation <- 0
# cfg$gms$s32_aff_bii_coeff <- 0
# cfg$gms$c56_pollutant_prices <- "R21M42-SSP5-PkBudg900"
# cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP5-PkBudg900"
# cfg$gms$c60_biodem_level <- 0 #otherwise infeasible
# start_run(cfg,codeCheck=FALSE)
