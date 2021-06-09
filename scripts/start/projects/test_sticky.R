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

#cfg$force_download <- TRUE

#cfg$gms$c56_pollutant_prices <- "R21M42-SSP2-PkBudg900"
#cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP2-PkBudg900"


cfg$results_folder <- "output/:title:"
cfg$output <- c("rds_report","extra/disaggregation","extra/disaggregation_transitions")

prefix <- "ST03"

cfg <- setScenario(cfg,c("SSP2","NPI","cc"))
cfg$gms$labor_prod <- "off"

cfg$title <- paste(prefix,"SSP2-Ref-sticky_feb18",sep="_")
cfg$gms$factor_costs                 <- "sticky_feb18"
start_run(cfg,codeCheck=FALSE)

cfg$title <- paste(prefix,"SSP2-Ref-sticky_labour_jun21",sep="_")
cfg$gms$factor_costs                 <- "sticky_labour_jun21"
start_run(cfg,codeCheck=FALSE)

