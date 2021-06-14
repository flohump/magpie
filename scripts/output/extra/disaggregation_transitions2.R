# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------------
# description: Interpolates land pools to 0.5 degree resolution
# comparison script: FALSE
# ---------------------------------------------------------------

library(lucode2)
library(magpie4)
library(luscale)
library(madrat)

############################# BASIC CONFIGURATION ##############################
if(!exists("source_include")) {
  outputdir <- "output/LAMA24_Sustainability/"
  readArgs("outputdir")
}
map_file                   <- Sys.glob(path(outputdir, "clustermap_*.rds"))
gdx                        <- path(outputdir,"fulldata.gdx")
land_hr_file               <- path(outputdir,"avl_land_t_0.5.mz")
land_hr_out_file           <- path(outputdir,"cell.land_0.5.mz")
land_hr_share_out_file     <- path(outputdir,"cell.land_0.5_share.mz")
land_trans_hr_out_file        <- path(outputdir,"cell.land_transitions_0.5.mz")
land_trans_hr_share_out_file  <- path(outputdir,"cell.land_transitions_0.5_share.mz")

load(paste0(outputdir, "/config.Rdata"))
################################################################################

if(length(map_file)==0) stop("Could not find map file!")
if(length(map_file)>1) {
  warning("More than one map file found. First occurrence will be used!")
  map_file <- map_file[1]
}
### Land STATES
# Load input data
land_lr   <- land(gdx,sum=FALSE,level="cell")
land_ini  <- setYears(read.magpie(land_hr_file)[,"y1995",],NULL)
land_ini  <- land_ini[,,getNames(land_lr)]
if(any(land_ini < 0)) {
  warning(paste0("Negative values in inital high resolution dataset ",
                 "detected and set to 0. Check the file ",land_hr_file))
  land_ini[which(land_ini < 0,arr.ind = T)] <- 0
}

# Start interpolation (use interpolate from luscale)
message("Disaggregation")
land_hr <- luscale::interpolate2(x     = land_lr,
                                 x_ini = land_ini,
                                 map   = map_file)
land_hr  <- land_hr[,-1,]

### Land Transitions

# read lr land transitions
land_trans_lr <- readGDX(gdx,"ov10_lu_transitions",select = list(type="level"),react = "silent")
if(is.null(land_trans_lr)) stop("No land transitions available in GDX file")
# create hr land transitions object
land_trans_ini <- new.magpie(getCells(land_ini),NULL,getNames(land_trans_lr),fill = 0)
# fill states of hr land transitions object based on land_ini
for (i in getNames(land_trans_lr,dim=1)) {
  land_trans_ini[,,paste(i,i,sep=".")] <- land_ini[,,i]  
}

# Interpolate Transitions
print("Disaggregation Land Transitions")
land_trans_hr <- interpolate2(x          = land_trans_lr,
                              x_ini      = land_trans_ini,
                              map   = map_file)
land_trans_hr  <- land_trans_hr[,-1,]

# Test
test <- dimSums(land_trans_hr,dim=3.1) - land_hr
if(max(test)>0.2||min(test)< -0.2) warning("Sum over land transitions and land stock differ, but should be equal!")
#dimSums(land_hr[1,,],dim=c(1))[,,"crop"]
#dimSums(land_trans_hr[1,,],dim=c(1,3.1))[,,"crop"]


# Write outputs


.tmpwrite <- function(x,file,comment,message) {
  write.magpie(x, file, comment=comment)
  write.magpie(x, sub(".mz",".nc",file), comment=comment, verbose=FALSE)
}

.tmpwrite(land_hr, land_hr_out_file, comment="unit: Mha per grid-cell",
          message="Write outputs cell.land")
.tmpwrite(land_hr/dimSums(land_hr,dim=3), land_trans_hr_share_out_file,
          comment="unit: grid-cell land area fraction",
          message="Write outputs cell.land_share")

.tmpwrite(land_trans_hr, land_trans_hr_out_file, comment="unit: Mha per grid-cell",
          message="Write outputs cell.land")
.tmpwrite(land_trans_hr/dimSums(land_trans_hr,dim=3), land_trans_hr_share_out_file,
          comment="unit: grid-cell land area fraction",
          message="Write outputs cell.land_share")
