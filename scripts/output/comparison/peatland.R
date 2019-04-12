# |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
# |  authors, and contributors see AUTHORS file
# |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
# |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
# |  Contact: magpie@pik-potsdam.de

#########################
#### check modelstat ####
#########################
# Version 1.0, Florian Humpenoeder
#
library(lucode)
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

x <- list()
x$emis_co2_cell_annual <- NULL
x$emis_all_reg_annual <- NULL
x$area_p <- NULL
x$area_p_total <- NULL
x$land <- NULL
x$fprice <- NULL

missing <- NULL

calcEmisCum <- function(a) {
  im_years <- getYears(a,as.integer = T)
  im_years <- c(0,diff(im_years))
  im_years <- as.magpie(im_years,temporal=1)
  getYears(im_years) <- getYears(a)
  a[,im_years[1],] <- 0
  a <- a*im_years[,getYears(a),]
  a <- as.magpie(apply(a,c(1,3),cumsum),spatial=2,temporal=1)
  return(a)
}


for (i in 1:length(outputdirs)) {
  print(paste("Processing",outputdirs[i]))
  #gdx file
  gdx<-path(outputdirs[i],"fulldata.gdx")
  if(file.exists(gdx)) {
    #get scenario name
    load(path(outputdirs[i],"config.Rdata"))
    scen <- cfg$title
    
    #read area_p
    a <- readGDX(gdx,"ov58_peatland_man",select=list(type="level"))
    a <- add_dimension(a,dim = 3.1,add = "scenario",nm = scen)
    x$area_p <- mbind(x$area_p,a)

    #read area_p_total
    a <- readGDX(gdx,"ov58_peatland_man",select=list(type="level"))
    a <- dimSums(a,dim=c(3.2))
    b <- readGDX(gdx,"ov58_peatland_intact",select=list(type="level"))
    getNames(b) <- "intact"
    a <- mbind(a,b)
    a <- add_dimension(a,dim = 3.1,add = "scenario",nm = scen)
    x$area_p_total <- mbind(x$area_p_total,a)
    
    #read land
    a <- land(gdx,level="cell")
    a <- add_dimension(a,dim = 3.1,add = "scenario",nm = scen)
    x$land <- mbind(x$land,a)

    #emis_p_reg
    emis_p_reg <- readGDX(gdx,"ov58_peatland_emis",select=list(type="level"))
    emis_p_reg <- superAggregate(emis_p_reg,level="reg")
    emis_p_reg[,,"ch4"] <- emis_p_reg[,,"ch4"]/28
    emis_p_reg[,,"n2o"] <- emis_p_reg[,,"ch4"]/265
    emis_p_reg <- add_dimension(emis_p_reg,dim = 3.1,add = "scenario",nm = scen)

    #emis_lu_reg
    co2 <- setNames(emisCO2(gdx,level = "reg",unit="gas",cc = TRUE),"co2")
    doc <- setNames(co2,"doc")
    doc[,,] <- NA
    ch4 <- setNames(Emissions(gdx,level="reg",type="ch4",unit="gas")*28,"ch4")
    n2o <- setNames(Emissions(gdx,level="reg",type="n2o_n",unit="gas")*265,"n2o")
    emis_lu_reg <- mbind(co2,doc,ch4,n2o)
    emis_lu_reg <- add_dimension(emis_lu_reg,dim = 3.1,add = "scenario",nm = scen)

    lu <- add_dimension(emis_lu_reg,dim = 3.2,add = "GHG emission","Land-use change & Agriculture")
    peat <- add_dimension(dimSums(emis_p_reg,dim=c(1,3.4)),dim = 3.2,add = "GHG emission","Peatland")
    x$emis_all_reg_annual <- mbind(x$emis_all_reg_annual,mbind(lu,peat))
    
    #emis_p_cell_co2
    emis_p_cell <- readGDX(gdx,"ov58_peatland_emis",select=list(type="level"))
    emis_p_cell <- dimSums(emis_p_cell[,,c("co2","doc")],dim=3.2)
    emis_p_cell <- add_dimension(emis_p_cell,dim = 3.1,add = "scenario",nm = scen)
    
    #emis_lu_cell_co2
    emis_lu_cell <- setNames(emisCO2(gdx,level = "cell",unit="gas",cc = TRUE),"co2")
    emis_lu_cell <- add_dimension(emis_lu_cell*map_cell_clim,dim = 3.1,add = "scenario",nm = scen)
    
    lu <- add_dimension(emis_lu_cell,dim = 3.2,add = "GHG emission","Land-use change")
    peat <- add_dimension(dimSums(emis_p_cell,dim=c(1,3.4)),dim = 3.2,add = "GHG emission","Peatland")
    x$emis_co2_cell_annual <- mbind(x$emis_co2_cell_annual,mbind(lu,peat))

    #read fprice
    a <- priceIndex(gdx,level="regglo", products="kfo", baseyear = "y2010")
    a <- add_dimension(a,dim = 3.1,add = "scenario",nm = scen)
    x$fprice <- mbind(x$fprice,a)
    
        
  } else missing <- c(missing,outputdirs[i])
}

#remove 1995
x <- lapply(x, function(x) {x[,getYears(x,as.integer = T)>=2015,]})

#read emis factors (same for all scenarios)
x$emis_fac <- readGDX(gdx,"f58_ipcc_wetland_ef")
x$map_cell_clim <- readGDX(gdx,"p58_mapping_cell_climate")

#add emis_all

#add emis_all_cum
x$emis_all_cum <- calcEmisCum(x$emis_all)

#add emis_all_co2_cell###
afolu <- add_dimension(dimSums(x$emis_co2_cell,dim=3.2)*x$map_cell_clim,dim = 3.2,add = "CO2 emission","Land-use change")
#names(dimnames(afolu)) <- c("j.cell","t","scenario.CO2 emission.emis58.climate58")
#afolu <- clean_magpie(afolu)
peat <- add_dimension(dimSums(x$emis_p,dim=c(3.5)),dim = 3.2,add = "CO2 emission","Peatland")
x$emis_all_co2_cell <- mbind(afolu,peat)

#dimSums(x$emis_all_co2_cell,dim=1,na.rm=T)[,,"T18_26"][,,"boreal"]
#dimSums(afolu,dim=1,na.rm=T)[,,"T18_26"][,,"boreal"]

#add emis_all_co2_cell_cum
x$emis_all_co2_cell_cum <- calcEmisCum(x$emis_all_co2_cell)

#area_p_total_change
x$area_p_total_change <- x$area_p_total-setYears(x$area_p_total[,1,],NULL)

#area_all_change
x$land_change <- x$land-setYears(x$land[,1,],NULL)
x$area_all_change <- mbind(x$land_change,x$area_p_total_change)

files <- list.files(path="output", pattern="peatland_*")
nums <- as.numeric(gsub(paste("peatland_", ".RData", sep="|"), "", files))
if(length(nums)==0) last=0 else last <- max(nums)
newFile <- paste0("output/peatland_", sprintf("%02d", last + 1), ".RData")
save(x,file = newFile,compress = "xz")

if (!is.null(missing)) {
  cat("\nList of folders with missing fulldata.gdx\n")
  print(missing)
}
