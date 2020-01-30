# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

#########################
####  PriceElasticitiesSupply ####
#########################
# Version 1.0, Florian Humpenoeder
#
library(lucode)
library(magclass)
library(luplot)
library(magpie4)

options(error=function()traceback(2))

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdirs <- path("output/",list.dirs("output/", full.names = FALSE, recursive = FALSE))
  #Define arguments that can be read from command line
  readArgs("outputdirs")
}
###############################################################################
cat("\nStarting output generation\n")

if (file.exists("output/f17_prod_reg.cs3")) file.rename("output/f17_prod_reg.cs3","output/f17_prod_reg.bak")

all <- NULL
missing <- NULL

for (i in 1:length(outputdirs)) {
  print(paste("Processing",outputdirs[i]))
  #gdx file
  gdx<-path(outputdirs[i],"fulldata.gdx")
  if(file.exists(gdx)) {
    #get scenario name
    load(path(outputdirs[i],"config.Rdata"))
    scen <- cfg$gms$c09_pop_scenario
    #read-in reporting file
    a <- readGDX(gdx,"ov_prod_reg",select = list(type="level"))
    a <- add_dimension(a,3.2,"s17_scen",scen)
    all <- mbind(all,a)
  } else missing <- c(missing,outputdirs[i])
}
if (!is.null(missing)) {
  cat("\nList of folders with missing fulldata.gdx\n")
  print(missing)
}

write.magpie(all,"output/f17_prod_reg.cs3")
