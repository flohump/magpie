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

prev_year        <- "y2015"            #timestep before calculations in MAgPIE
in_folder        <- "modules/58_peatland/input"

if(!exists("source_include")) {
  sum_spam_file    <- "0.5-to-n200_sum.spam"
  title       <- "base_run"
  outputdir       <- "output/SSP2_Ref_c200"

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
write.report(x,file = path(outputdir,land_iso_out_file),model = "MAgPIE 4.2",scenario = title,unit = "Mha")
file.copy(path(outputdir,land_iso_out_file),path("output",paste0(title,".csv")),overwrite = TRUE)
#dimSums(x,dim=c(1,3))

print("Write outputs cell.land")
#check
#dimSums(land_hr,dim=c(1))
land_hr[dimSums(land_hr,dim=c(2,3)) == 0,,] <- NA
#dimSums(land_hr,dim=c(1),na.rm=TRUE)
write.magpie(land_hr,path(outputdir,land_hr_out_file),comment="unit: Mha per grid-cell")
file.copy(path(outputdir,land_hr_out_file),path("output",paste0(title,".nc")),overwrite = TRUE)






