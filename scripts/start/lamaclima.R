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

#start MAgPIE run
source("config/default.cfg")

#cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"

#05 prod_reg free
#06 prod_reg free with lower bound on prod_cell


prefix <- "lama06X_"
#"SSP1","SSP3","SSP4","SSP5"
for (ssp in c("SSP2")) {
  cfg$title <- paste0(prefix,ssp,"_BASE")
  cfg <- setScenario(cfg,c(ssp,"BASE"))
  cfg$recalc_npi_ndc <- FALSE
  cfg$gms$s15_elastic_demand <- 0
  cfg$gms$land <- "feb15"
#  cfg$gms$s80_optfile <- 0
  cfg$gms$maccs  <- "off_jul16"
  cfg$gms$trade <- "supply_shock_jan20"
  start_run(cfg,codeCheck=FALSE)
}

