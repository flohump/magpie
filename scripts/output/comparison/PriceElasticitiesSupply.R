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

if (file.exists("output/prod_change.csv")) file.rename("output/prod_change.csv","output/prod_change.bak")
if (file.exists("output/price_change.csv")) file.rename("output/price_change.csv","output/price_change.bak")
if (file.exists("output/price_elasiticty_supply.csv")) file.rename("output/price_elasiticty_supply.csv","output/price_elasiticty_supply.bak")

PriceElasticitiesSupply <- function(gdx,scen="SSP2", file=FALSE) {
  p15_prod_total_before <- readGDX(gdx,"p15_prod_total_before")
  p15_prod_total_after <- readGDX(gdx,"p15_prod_total_after")
  p15_demand_kcal_pc_before <- readGDX(gdx,"p15_demand_kcal_pc_before")
  p15_demand_kcal_pc_after <- readGDX(gdx,"p15_demand_kcal_pc_after")
  
  p15_prices_kcal_pc_before <- readGDX(gdx,"p15_prices_kcal_pc_before")
  p15_prices_kcal_pc_after <- readGDX(gdx,"p15_prices_kcal_pc_after")

  #prices reg+glo production
  p15_prices_prod_before <- readGDX(gdx,"p15_prices_prod_before")
  p15_prices_prod_after <- readGDX(gdx,"p15_prices_prod_after")
  
  p15_prices_glo_prod_before <- readGDX(gdx,"p15_prices_glo_prod_before")
  p15_prices_glo_prod_after <- readGDX(gdx,"p15_prices_glo_prod_after")
  
  p15_prices_prod_before <- p15_prices_prod_before+p15_prices_glo_prod_before
  p15_prices_prod_after <- p15_prices_prod_after+p15_prices_glo_prod_after
  
  # a <- (p15_prod_total_after[,,"tece"]/p15_prod_total_before[,,"tece"]-1)/(p15_prices_prod_after[,,"tece"]/p15_prices_prod_before[,,"tece"]-1)
  # b <- (p15_demand_kcal_pc_after[,,"tece"]/p15_demand_kcal_pc_before[,,"tece"]-1)/(p15_prices_kcal_pc_after[,,"tece"]/p15_prices_kcal_pc_before[,,"tece"]-1)
  # 
  # a <- (p15_prod_total_after[,,"livst_rum"]/p15_prod_total_before[,,"livst_rum"]-1)/(p15_prices_prod_after[,,"livst_rum"]/p15_prices_prod_before[,,"livst_rum"]-1)
  # b <- (p15_demand_kcal_pc_after[,,"livst_rum"]/p15_demand_kcal_pc_before[,,"livst_rum"]-1)/(p15_prices_kcal_pc_after[,,"livst_rum"]/p15_prices_kcal_pc_before[,,"livst_rum"]-1)
  
  prod_change <- p15_prod_total_after/p15_prod_total_before-1
  price_change <- p15_prices_prod_after/p15_prices_prod_before-1

  price_elasiticty_supply <- prod_change/price_change
  
  if(file) {
    write.report(p15_prod_total_before,"output/prod_before.csv",append = TRUE,model = "MAgPIE",scenario = scen,unit = "mio tDM per year")
    write.report(p15_prod_total_after,"output/prod_after.csv",append = TRUE,model = "MAgPIE",scenario = scen,unit = "mio tDM per year")
    write.report(p15_prices_prod_before,"output/prices_before.csv",append = TRUE,model = "MAgPIE",scenario = scen,unit = "USD05MER per tDM")
    write.report(p15_prices_prod_after,"output/prices_after.csv",append = TRUE,model = "MAgPIE",scenario = scen,unit = "USD05MER per tDM")
    write.report(prod_change,"output/prod_change.csv",append = TRUE,model = "MAgPIE",scenario = scen,unit = "%")
    write.report(prod_change,"output/prod_change.csv",append = TRUE,model = "MAgPIE",scenario = scen,unit = "%")
    write.report(price_change,"output/price_change.csv",append = TRUE,model = "MAgPIE",scenario = scen,unit = "%")
    write.report(price_elasiticty_supply,"output/price_elasiticty_supply.csv",append = TRUE,model = "MAgPIE",scenario = scen,unit = "unitless")
  } else return(price_elasiticty_supply)
}

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
    PriceElasticitiesSupply(gdx,scen=scen,file = TRUE)
  } else missing <- c(missing,outputdirs[i])
}
if (!is.null(missing)) {
  cat("\nList of folders with missing fulldata.gdx\n")
  print(missing)
}
