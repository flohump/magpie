# |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: DeepElectric
# position: 5
# ----------------------------------------------------------


##### Version log (YYYYMMDD - Description - Author(s))
## 20200527 - Default SSP2 Baseline and Policy runs - FH,AM,EMJB,JPD

## Load lucode2 and gms to use setScenario later
library(lucode2)
library(gms)
library(magclass)
library(gdx)

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

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Source default cfg. This loads the object "cfg" in R environment
source("config/default.cfg")


cfg$results_folder <- "output/:title:"
cfg$output <- c("rds_report") # Only run rds_report after model run

ssp <- "SSP2"

## Create a set of runs based on default.cfg

cfg$title <- "DE_PkBudg900_ref_VRE1_CPnatveg"
cfg <- setScenario(cfg,c(ssp,"NPI"))
cfg$gms$c56_pollutant_prices <- "coupling"
cfg$gms$c60_2ndgen_biodem <- "coupling"
getInput("/p/tmp/merfort/DeepEl_coupl_resub/magpie/output/C_TraInd-PkBudg900_ref_VRE1-mag-4/fulldata.gdx")
start_run(cfg,codeCheck=FALSE) # Start MAgPIE run

cfg$title <- "DE_PkBudg900_ref_VRE1_CPforest"
cfg <- setScenario(cfg,c(ssp,"NPI"))
cfg$gms$c56_pollutant_prices <- "coupling"
cfg$gms$c60_2ndgen_biodem <- "coupling"
cfg$input <- c(cfg$input,"patch_EmisPolicy.tgz")
getInput("/p/tmp/merfort/DeepEl_coupl_resub/magpie/output/C_TraInd-PkBudg900_ref_VRE1-mag-4/fulldata.gdx")
start_run(cfg,codeCheck=FALSE) # Start MAgPIE run
