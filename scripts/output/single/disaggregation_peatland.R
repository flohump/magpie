# |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

#########################################################################
#### Interpolates land pools from low to high resolution, calculates ####
#### corresponding spam-files for following disaggregations #############
#########################################################################

#Version 1.00 - Florian Humpenoeder

library(lucode)
library(magpie4)
library(luscale)
library(madrat)

############################# BASIC CONFIGURATION #######################################
land_hr_file_degrad <- "f58_peatland_degrad_0.5.mz"
land_hr_file_intact <- "f58_peatland_intact_0.5.mz"
land_hr_out_file           <- "peatland_cell.nc"
land_iso_out_file           <- "peatland_iso.csv"
tech_iso_out_file           <- "peatland_TechPot_iso.csv"

prev_year        <- "y2015"            #timestep before calculations in MAgPIE
in_folder        <- "modules/58_peatland/input"

if(!exists("source_include")) {
  sum_spam_file    <- "0.5-to-n200_sum.spam"
  title       <- "base_run"
  outputdir       <- "output/T143_SSP2_RCP2p6+PeatRestor_medium/"

  ###Define arguments that can be read from command line
  readArgs("sum_spam_file","outputdir","title")
}
#########################################################################################

load(paste0(outputdir, "/config.Rdata"))
title <- cfg$title
print(title)

# Function to extract information from info.txt
get_info <- function(file, grep_expression, sep, pattern="", replacement="") {
  if(!file.exists(file)) return("#MISSING#")
  file <- readLines(file, warn=FALSE)
  tmp <- grep(grep_expression, file, value=TRUE)
  tmp <- strsplit(tmp, sep)
  tmp <- sapply(tmp, "[[", 2)
  tmp <- gsub(pattern, replacement ,tmp)
  if(all(!is.na(as.logical(tmp)))) return(as.vector(sapply(tmp, as.logical)))
  if (all(!(regexpr("[a-zA-Z]",tmp) > 0))) {
    tmp <- as.numeric(tmp)
  }
  return(tmp)
}
low_res       <- get_info(paste0(outputdir,"/info.txt"),"^\\* Output ?resolution:",": ")
sum_spam_file <- paste0("0.5-to-",low_res,"_sum.spam")
print(sum_spam_file)


# Load input data
gdx          <- path(outputdir,"fulldata.gdx")

#low res
land_lr      <- PeatlandArea(gdx,level="cell")
land_lr <- land_lr[,getYears(land_lr,as.integer = T) > 2015,]
land_ini_lr_degrad  <- setNames(readGDX(gdx,"f58_peatland_degrad", format="first_found"),"degrad")
land_ini_lr_intact  <- setNames(readGDX(gdx,"f58_peatland_intact", format="first_found"),"intact")
land_ini_lr_rewet <- setNames(land_ini_lr_intact,"rewet"); land_ini_lr_rewet[,,] <- 0;
land_ini_lr <- mbind(land_ini_lr_degrad,land_ini_lr_rewet,land_ini_lr_intact)
names(dimnames(land_ini_lr)) <- names(dimnames(land_lr))

#high res
land_ini_hr_degrad  <- setNames(read.magpie(path(in_folder,land_hr_file_degrad)),"degrad")
land_ini_hr_intact  <- setNames(read.magpie(path(in_folder,land_hr_file_intact)),"intact")
spatial_header <- getCells(land_ini_hr_intact)
getCells(land_ini_hr_intact) <- getCells(land_ini_hr_degrad)
land_ini_hr_rewet <- setNames(land_ini_hr_intact,"rewet"); land_ini_hr_rewet[,,] <- 0;
land_ini_hr <- mbind(land_ini_hr_degrad,land_ini_hr_rewet,land_ini_hr_intact)
names(dimnames(land_ini_hr)) <- names(dimnames(land_lr))

if(any(land_ini_hr < 0)) {
  warning(paste0("Negative values in inital high resolution dataset detected and set to 0. Check the file ",land_hr_file))
  land_ini_hr[which(land_ini_hr < 0,arr.ind = T)] <- 0
}

# Start interpolation (use interpolate from luscale)
print("Disaggregation")
land_hr <- interpolate( x          = land_lr,
                        x_ini_lr   = land_ini_lr,
                        x_ini_hr   = land_ini_hr,
                        spam       = path(outputdir,sum_spam_file),
                        prev_year  = prev_year)


#Country level outputs
CountryToCell   <- toolGetMapping("CountryToCellMapping.csv", type = "cell")
getCells(land_hr) <- CountryToCell$celliso
x <- toolAggregate(land_hr,CountryToCell,from="celliso",to="iso")
getNames(x) <- paste0("Land|Peatland|",getNames(x))
write.report(x,file = path(outputdir,land_iso_out_file),model = "MAgPIE 4",scenario = title,unit = "Mha")
#dimSums(x,dim=c(1,3))


a <- PeatlandEmissions(gdx,level="cell",unit="gas")
a <- a[,getYears(a,as.integer = T) >= 2015,]
b <- speed_aggregate(a,path(outputdir,sum_spam_file),weight = setYears(dimSums(land_hr[,1,],dim=3),NULL))
getCells(b) <- CountryToCell$celliso
x <- toolAggregate(b,CountryToCell,from="celliso",to="iso")
getNames(x) <- c("Emissions|Peatland|CH4 (Mt CH4/yr)","Emissions|Peatland|CO2 (Mt CO2/yr)","Emissions|Peatland|DOC (Mt CO2/yr)","Emissions|Peatland|N2O (Mt N2O/yr)")
write.report(x,file = path(outputdir,land_iso_out_file),model = "MAgPIE 4",scenario = title,append = TRUE)

a <- PeatlandEmissions(gdx,level="cell",unit="GWP")
a <- a[,getYears(a,as.integer = T) >= 2015,]
b <- speed_aggregate(a,path(outputdir,sum_spam_file),weight = setYears(dimSums(land_hr[,1,],dim=3),NULL))
getCells(b) <- CountryToCell$celliso
x <- toolAggregate(b,CountryToCell,from="celliso",to="iso")
getNames(x) <- c("Emissions|Peatland|CH4 (Mt CO2eq/yr)","Emissions|Peatland|CO2 (Mt CO2eq/yr)","Emissions|Peatland|DOC (Mt CO2eq/yr)","Emissions|Peatland|N2O (Mt CO2eq/yr)")
y <- dimSums(x,dim=3)
getNames(y) <- "Emissions|Peatland|Total (Mt CO2eq/yr)"
x <- mbind(x,y)
write.report(x,file = path(outputdir,land_iso_out_file),model = "MAgPIE 4",scenario = title,append = TRUE)

file.copy(path(outputdir,land_iso_out_file),path("output",paste0(title,".csv")),overwrite = TRUE)


#### technical potential
area <- dimSums(readGDX(gdx,"ov58_peatland_man",select = list(type="level"))[,,c("degrad","unused")],dim=3.1)[,getYears(land_hr),]

area_shr <- area/dimSums(area,dim=c(3))

# set inf to 0
area_shr[is.na(area_shr)]       <- 0
area_shr[is.nan(area_shr)]      <- 0
area_shr[is.infinite(area_shr)] <- 0

# disaggregate share of crop types in terms of croparea to 0.5 resolution
area_shr_hr <- speed_aggregate(area_shr,t(read.spam(path(outputdir,sum_spam_file))))
getCells(area_shr_hr) <- CountryToCell$celliso

# calculate crop tpye specific croparea in 0.5 resolution
area_hr     <- area_shr_hr*setNames(land_hr[,,"degrad"],NULL)

ef <- readGDX(gdx,"p58_ipcc_wetland_ef")
er <- collapseNames(ef[,,"rewet"])-collapseNames(ef[,,"degrad"])
clcl <- read.magpie("input/koeppen_geiger_0.5.mz")
getCells(clcl) <- CountryToCell$celliso
mapping <- readGDX(gdx,"clcl_mapping")
clcl <- groupAggregate(clcl,query = mapping,from="clcl", to="clcl58")
names(dimnames(clcl))[3] <- "clcl58"
tech <- area_hr[,1,] * er * clcl
tech <- dimSums(tech,dim=c(3.1,3.2))
tech <- toolAggregate(tech,CountryToCell,from="celliso",to="iso")
getNames(tech) <- c("Emissions|Peatland|CH4 (Mt CO2eq/yr)","Emissions|Peatland|N2O (Mt CO2eq/yr)","Emissions|Peatland|DOC (Mt CO2eq/yr)","Emissions|Peatland|CO2 (Mt CO2eq/yr)")
y <- dimSums(tech,dim=3)
getNames(y) <- "Emissions|Peatland|Total (Mt CO2eq/yr)"
tech <- mbind(tech,y)
#area
x <- toolAggregate(land_hr,CountryToCell,from="celliso",to="iso")
x <- x[,1,]
x[,,"rewet"] <- x[,,"degrad"]
x[,,"degrad"] <- -x[,,"degrad"]
x[,,"intact"] <- 0
getNames(x) <- paste0("Land|Peatland|",getNames(x)," (Mha)")
tech <- mbind(x,tech)
getYears(tech) <- 2100
write.report(tech,file = path(outputdir,tech_iso_out_file),model = "Technical Mitigation Potential",scenario = "Peatland Restoration",append = FALSE)

file.copy(path(outputdir,tech_iso_out_file),path("output",tech_iso_out_file),overwrite = TRUE)

print("Write outputs cell.land")
#check
#dimSums(land_hr,dim=c(1))
land_hr[dimSums(land_hr,dim=c(2,3)) == 0,,] <- NA
#dimSums(land_hr,dim=c(1),na.rm=TRUE)
write.magpie(land_hr,path(outputdir,land_hr_out_file),comment="unit: Mha per grid-cell")
file.copy(path(outputdir,land_hr_out_file),path("output",paste0(title,".nc")),overwrite = TRUE)



