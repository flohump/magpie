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
library(data.table)
library(quitte)
library(reshape2)

options(error=function()traceback(2))

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdirs <- path("output/",list.dirs("output/", full.names = FALSE, recursive = FALSE))
  #Define arguments that can be read from command line
  readArgs("outputdirs")
}
###############################################################################
cat("\nStarting output generation\n")

aff_area_shr <- NULL
aff_area <- NULL
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
    x <- collapseNames(read.magpie(path(outputdirs[i],"cell.land_0.5_share.mz"))[,,"forestry"])
    x <- x-setYears(x[,2020,],NULL)
    x <- x[,c(2050,2100),]
    aff_area_shr <- mbind(aff_area_shr,setNames(x,scen))
    x <- collapseNames(read.magpie(path(outputdirs[i],"cell.land_0.5.mz"))[,,"forestry"])
    x <- x-setYears(x[,2020,],NULL)
    x <- x[,c(2050,2100),]
    aff_area <- mbind(aff_area,setNames(x,scen))
  } else missing <- c(missing,outputdirs[i])
}
if (!is.null(missing)) {
  cat("\nList of folders with missing fulldata.gdx\n")
  print(missing)
}

write.magpie(aff_area_shr,"output/aff_area_shr.mz")
write.magpie(aff_area,"output/aff_area.mz")

mag_to_data_table <- function(x) {
  mag <- as.array(x)
  load("sysdata.rda")
  coord <- magclassdata$half_deg[, c("lon", "lat")]
  NODATA <- NA
  lon <- seq(-179.75, 179.75, by = 0.5)
  lat <- seq(-89.75, 89.75, by = 0.5)
  time <- as.numeric(unlist(lapply(strsplit(dimnames(mag)[[2]],"y"), function(mag) mag[2])))
  data <- dimnames(mag)[[3]]
  netcdf <- array(NODATA, dim = c(720, 360, dim(mag)[2],dim(mag)[3]), dimnames = list(lon, lat, time, data))
  for (i in 1:ncells(mag)) {
    netcdf[which(coord[i, 1] == lon), which(coord[i,2] == lat), , ] <- mag[i, , , drop = FALSE]
  }
  
  dt <- melt(netcdf)
  names(dt) <- c("lon","lat","time","data","value")
  dt <- as.data.table(dt)
  return(dt)
}

aff_area_shr <- mag_to_data_table(aff_area_shr)
aff_area <- mag_to_data_table(aff_area)

saveRDS(aff_area_shr,"aff_area_shr.rds")
saveRDS(aff_area,"aff_area.rds")
