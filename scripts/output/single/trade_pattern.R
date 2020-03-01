# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

library(magclass)
library(magpie4)
library(lucode)
library(quitte)
options("magclass.verbosity" = 1)

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdir <- "/p/projects/landuse/users/miodrag/projects/tests/flexreg/output/H12_setup1_2016-11-23_12.38.56/"
  readArgs("outputdir")
} 

load(paste0(outputdir, "/config.Rdata"))
gdx	<- path(outputdir,"fulldata.gdx")
mif <- paste0(outputdir, "/report.mif")
rda <- paste0(outputdir, "/report.rda")
###############################################################################

ov_supply <- readGDX(gdx,"ov_supply",select=list(type="level"))
write.magpie(ov_supply,"modules/21_trade/input/f21_supply.csv")

ov_prod_reg <- readGDX(gdx,"ov_prod_reg",select=list(type="level"))
write.magpie(ov_prod_reg,"modules/21_trade/input/f21_prod_reg.csv")
