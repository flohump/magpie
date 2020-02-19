# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

#########################
#### check modelstat ####
#########################
# Version 1.0, Florian Humpenoeder
#
library(lucode)
library(magclass)
library(luplot)
library(magpie4)
library(ggplot2)

options(error=function()traceback(2))

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdirs <- path("output/",list.dirs("output/", full.names = FALSE, recursive = FALSE))
  #Define arguments that can be read from command line
  readArgs("outputdirs")
}
###############################################################################
cat("\nStarting output generation\n")

forestry <- NULL
emis <- NULL
cdr <- NULL
missing <- NULL

for (i in 1:length(outputdirs)) {
  print(paste("Processing",outputdirs[i]))
  #gdx file
  gdx<-path(outputdirs[i],"fulldata.gdx")
  if(file.exists(gdx)) {
    #get scenario name
    load(path(outputdirs[i],"config.Rdata"))
    scen <- cfg$title
    #read-in reporting file
    x <- collapseNames(land(gdx,level="glo")[,,"forestry"])
    x <- x-setYears(x[,1,],NULL)
    getNames(x) <- scen
    forestry <- mbind(forestry,x)
    
    x <- collapseNames(emisCO2(gdx,level="glo",cumulative = TRUE)/1000)
    getNames(x) <- scen
    emis <- mbind(emis,x)

    x <- collapseNames(emisCO2(gdx,level="glo",cumulative = TRUE,type = "neg")/1000)
    getNames(x) <- scen
    cdr <- mbind(cdr,x)
    
  } else missing <- c(missing,outputdirs[i])
}
if (!is.null(missing)) {
  cat("\nList of folders with missing fulldata.gdx\n")
  print(missing)
}

p <- magpie2ggplot2(forestry,scenario = 1,ylab = "Mha",title = "Afforestation",legend_position = "bottom",group = NULL,legend_ncol = 1)
ggsave(plot = p,filename = "output/aff_area.pdf",width = 8,height = 7)

p <- magpie2ggplot2(emis,scenario = 1,ylab = "GtCO2",title = "Cumulative CO2 Emissions",legend_position = "bottom",group = NULL,legend_ncol = 1)
ggsave(plot = p,filename = "output/emis_cum.pdf",width = 8,height = 7)

p <- magpie2ggplot2(cdr,scenario = 1,ylab = "GtCO2",title = "Cumulative CDR",legend_position = "bottom",group = NULL,legend_ncol = 1)
ggsave(plot = p,filename = "output/cdr_cum.pdf",width = 8,height = 7)
