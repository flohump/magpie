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

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")
cfg$results_folder <- "output/:title:"

cfg$input <- c(cfg$input,"peatland_input_v1.tgz")
cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"/p/projects/landuse/users/florianh/data"=NULL),
                           getOption("magpie_repos"))

cfg$gms$peatland  <- "ipcc_2014_mar19"
prefix <- "T51"

##SSP2
cfg$title <- paste(prefix,"Ref",sep="_")
cfg <- setScenario(cfg,c("SSP2","NPI"))
cfg$gms$c56_pollutant_prices <- "SSP2-Ref-SPA0-V15-REMIND-MAGPIE"
cfg$gms$c60_2ndgen_biodem <- "SSP2-Ref-SPA0"
cfg$gms$s56_peatland_policy <- 0
cfg$gms$s58_rewetting  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"CPol",sep="_")
cfg <- setScenario(cfg,c("SSP2","NDC"))
cfg$gms$c56_pollutant_prices <- "SSP2-26-SPA2-V15-REMIND-MAGPIE"
cfg$gms$c60_2ndgen_biodem <- "SSP2-26-SPA2"
cfg$gms$s56_peatland_policy <- 0
cfg$gms$s58_rewetting  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"CPol+Pprot",sep="_")
cfg <- setScenario(cfg,c("SSP2","NDC"))
cfg$gms$c56_pollutant_prices <- "SSP2-26-SPA2-V15-REMIND-MAGPIE"
cfg$gms$c60_2ndgen_biodem <- "SSP2-26-SPA2"
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"CPol+Pprot+Prestor",sep="_")
cfg <- setScenario(cfg,c("SSP2","NDC"))
cfg$gms$c56_pollutant_prices <- "SSP2-26-SPA2-V15-REMIND-MAGPIE"
cfg$gms$c60_2ndgen_biodem <- "SSP2-26-SPA2"
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting  <- Inf
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"CPol+Pprot_nobio",sep="_")
cfg <- setScenario(cfg,c("SSP2","NDC"))
cfg$gms$c56_pollutant_prices <- "SSP2-26-SPA2-V15-REMIND-MAGPIE"
cfg$gms$c60_2ndgen_biodem <- "SSP2-Ref-SPA0"
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting  <- 0
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"CPol+Pprot+Prestor_nobio",sep="_")
cfg <- setScenario(cfg,c("SSP2","NDC"))
cfg$gms$c56_pollutant_prices <- "SSP2-26-SPA2-V15-REMIND-MAGPIE"
cfg$gms$c60_2ndgen_biodem <- "SSP2-Ref-SPA0"
cfg$gms$s56_peatland_policy <- 1
cfg$gms$s58_rewetting  <- Inf
start_run(cfg,codeCheck=FALSE)
