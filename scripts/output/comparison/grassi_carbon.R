# (C) 2008-2017 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

#########################
#### check modelstat ####
#########################
# Version 1.0, Florian Humpenoeder
#
library(magpie4)
library(lucode)
library(magclass)
library(quitte)

options(error=function()traceback(2))

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdirs <- path("output/",list.dirs("output/", full.names = FALSE, recursive = FALSE))
  #Define arguments that can be read from command line
  readArgs("outputdirs")
}
###############################################################################
cat("\nStarting output generation\n")

missing <- NULL

rep_file <- "report_grassi_03.csv"

if(file.exists(paste0("output/",rep_file))) file.rename(paste0("output/",rep_file),paste0("output/",sub(".csv",".bak",rep_file)))

reportGrassi <- function(gdx) {
  total <- emisCO2(gdx,level="glo",unit = "gas",sum=FALSE,cc = TRUE,correct = TRUE,lowpass = 1)
  lu_tot <- emisCO2(gdx,level="glo",unit = "gas",sum=FALSE,cc = FALSE,regrowth = TRUE,correct = TRUE,lowpass = 1)
  luc <- emisCO2(gdx,level="glo",unit = "gas",sum=FALSE,cc = FALSE,regrowth=FALSE,correct = TRUE,lowpass = 1)
  
  climatechange <- total-lu_tot
  regrowth <- lu_tot-luc
  
  forest <- c("forestry","primforest","secdforest")
  non_forest <- c("crop","past","urban","other")
  
  x <- NULL
  #Total
  x <- mbind(x,setNames(dimSums(total,dim=3),"Emissions|CO2|Land (Mt CO2/yr)"))
  #Direct
  x <- mbind(x,setNames(dimSums(lu_tot,dim=3),"Emissions|CO2|Land|Direct (Mt CO2/yr)"))
  #Land-use change
  x <- mbind(x,setNames(dimSums(luc,dim=3),"Emissions|CO2|Land|Direct|Land-use Change (Mt CO2/yr)"))
  x <- mbind(x,setNames(dimSums(luc[,,forest],dim=3),"Emissions|CO2|Land|Direct|Land-use Change|Forest (Mt CO2/yr)"))
  x <- mbind(x,setNames(dimSums(luc[,,non_forest],dim=3),"Emissions|CO2|Land|Direct|Land-use Change|Non-Forest (Mt CO2/yr)"))
  #Regrowth
  x <- mbind(x,setNames(dimSums(regrowth,dim=3),"Emissions|CO2|Land|Direct|Management (Mt CO2/yr)"))
  x <- mbind(x,setNames(dimSums(regrowth[,,forest],dim=3),"Emissions|CO2|Land|Direct|Management|Forest (Mt CO2/yr)"))
  #Should regrowth on other land (unmanaged) be included here or not?
  x <- mbind(x,setNames(dimSums(regrowth[,,non_forest],dim=3),"Emissions|CO2|Land|Direct|Management|Non-Forest (Mt CO2/yr)"))
  #Indirect
  x <- mbind(x,setNames(dimSums(climatechange,dim=3),"Emissions|CO2|Land|Indirect (Mt CO2/yr)"))
  x <- mbind(x,setNames(dimSums(climatechange,dim=3),"Emissions|CO2|Land|Indirect|Climate Change (Mt CO2/yr)"))
  x <- mbind(x,setNames(dimSums(climatechange[,,c("forestry","secdforest")],dim=3),"Emissions|CO2|Land|Indirect|Climate Change|Forest Managed (Mt CO2/yr)"))
  x <- mbind(x,setNames(dimSums(climatechange[,,"primforest"],dim=3),"Emissions|CO2|Land|Indirect|Climate Change|Forest Unmanaged (Mt CO2/yr)"))
  x <- mbind(x,setNames(dimSums(climatechange[,,c("crop","past","urban")],dim=3),"Emissions|CO2|Land|Indirect|Climate Change|Non-Forest Managed (Mt CO2/yr)"))
  x <- mbind(x,setNames(dimSums(climatechange[,,"other"],dim=3),"Emissions|CO2|Land|Indirect|Climate Change|Non-Forest Unmanaged (Mt CO2/yr)"))
  
  #read in area
  area <- land(gdx,level="glo")
  
  #calc area change (changes per year)
  timestep_length <- timePeriods(gdx)
  area_change <- new.magpie(getCells(area),getYears(area),getNames(area),NA)
  for (t in 2:length(timestep_length)) {
    area_change[,t,] <- (area[,t,] - setYears(area[,t-1,],NULL))/timestep_length[t]
  }
  
  x <- mbind(x,setNames(dimSums(area_change[,,forest],dim=3),"Resources|Land Cover Change|Forest (Mha/yr)"))
  x <- mbind(x,setNames(dimSums(area_change[,,c("forestry","secdforest")],dim=3),"Resources|Land Cover Change|Forest Managed (Mha/yr)"))
  x <- mbind(x,setNames(dimSums(area_change[,,"primforest"],dim=3),"Resources|Land Cover Change|Forest Unmanaged (Mha/yr)"))
  
  x <- mbind(x,setNames(dimSums(area[,,forest],dim=3),"Resources|Land Cover|Forest (Mha)"))
  x <- mbind(x,setNames(dimSums(area[,,c("forestry","secdforest")],dim=3),"Resources|Land Cover|Forest Managed (Mha)"))
  x <- mbind(x,setNames(dimSums(area[,,"primforest"],dim=3),"Resources|Land Cover|Forest Unmanaged (Mha)"))
  x <- mbind(x,setNames(dimSums(area[,,non_forest],dim=3),"Resources|Land Cover|Non-Forest (Mha)"))
  x <- mbind(x,setNames(dimSums(area[,,c("crop","past","urban")],dim=3),"Resources|Land Cover|Non-Forest Managed (Mha)"))
  x <- mbind(x,setNames(dimSums(area[,,"other"],dim=3),"Resources|Land Cover|Non-Forest Unmanaged (Mha)"))
  
  x <- x[,-1,]
  return(x)
}

for (i in 1:length(outputdirs)) {
  print(paste("Processing",outputdirs[i]))
  #gdx file
  gdx<-path(outputdirs[i],"fulldata.gdx")
  if(file.exists(gdx)) {
    #get scenario name
    load(path(outputdirs[i],"config.Rdata"))
    scen <- cfg$title
    #read-in reporting file
    a <- reportGrassi(gdx)
    #add to reporting csv file
    write.report(a,file = paste0("output/",rep_file),model = "MAgPIE",scenario = scen,append = TRUE)
  } else missing <- c(missing,outputdirs[i])
}
if (!is.null(missing)) {
  cat("\nList of folders with missing report.mif\n")
  print(missing)
}
