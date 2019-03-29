##########################################################
#### Cellular land pattern ####
##########################################################
# Version 1.0,  Florian Humpenoeder

library(magpie4)
library(luplot)
library(ggplot2)

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdir <- "."
  readArgs("outputdir")
} 

load(paste0(outputdir, "/config.Rdata"))
gdx	<- path(outputdir,"fulldata.gdx")
###############################################################################

land_pools <- land(gdx,level="cell")
p <- alloc_plot(land_pools,level="cell",weight="Value",ylab="Share of cluster",norm=T)
ggsave(plot = p, filename = path(outputdir,paste(cfg$title,"land_pattern_cellular.pdf",sep="_")), scale = 3, height = 10, width = 5)
