##########################################################
#### Cellular land pattern ####
##########################################################
# Version 1.0,  Florian Humpenoeder

library(magpie)
library(luplot)

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdir <- "."
  readArgs("outputdir")
} 

load(paste0(outputdir, "/config.Rdata"))
gdx	<- path(outputdir,"fulldata.gdx")
###############################################################################

land_pools <- land(gdx,level="cell")
alloc_plot(land_pools,level="cell",weight="Value",print=F,ylab="Share of cluster",norm=T,file=path(outputdir,paste(cfg$title,"land_pattern_cellular.pdf",sep="_")),scale=4)
