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

if (file.exists("output/prod_cross.csv")) file.rename("output/prod_cross.csv","output/prod_cross.bak")
if (file.exists("output/prod_own.csv")) file.rename("output/prod_own.csv","output/prod_own.bak")
if (file.exists("output/price_cross.csv")) file.rename("output/price_cross.csv","output/price_cross.bak")
if (file.exists("output/price_own.csv")) file.rename("output/price_own.csv","output/price_own.bak")
if (file.exists("output/price_elasiticty_supply_cross.csv")) file.rename("output/price_elasiticty_supply_cross.csv","output/price_elasiticty_supply_cross.bak")
if (file.exists("output/price_elasiticty_supply_own.csv")) file.rename("output/price_elasiticty_supply_own.csv","output/price_elasiticty_supply_own.bak")

PriceElasticitiesSupply <- function(gdx,scen="SSP2", file=FALSE) {
  p21_prod_cross <- readGDX(gdx,"p21_prod_cross")[,,c("0","5","10","20")]
  p21_price_cross <- readGDX(gdx,"p21_price_cross")[,,c("0","5","10","20")]
  p21_cost_cross <- readGDX(gdx,"p21_cost_cross")[,,c("0","5","10","20")]

  p21_prod_own <- readGDX(gdx,"p21_prod_own")
  p21_price_own <- readGDX(gdx,"p21_price_own")
  p21_cost_own <- readGDX(gdx,"p21_cost_own")
  
#Filter negative and zero prices
  p21_price_cross[p21_price_cross<=0] <- NA
  p21_price_own[p21_price_own<=0] <- NA
  
  prod_change_own <- p21_prod_own/collapseNames(p21_prod_own[,,"0"])-1
  price_change_own <- p21_price_own/collapseNames(p21_price_own[,,"0"])-1
  
  own_price_elasiticty_supply <- prod_change_own/price_change_own
  own_price_elasiticty_supply <- own_price_elasiticty_supply#[,,"0",invert=T]

  prod_change_cross <- p21_prod_cross/collapseNames(p21_prod_cross[,,"0"])-1
  price_change_cross <- p21_price_cross/collapseNames(p21_price_cross[,,"0"])-1
  
  cross_price_elasiticty_supply <- prod_change_cross/price_change_cross
  cross_price_elasiticty_supply <- cross_price_elasiticty_supply#[,,"0",invert=T]
  # 
  #   
  # print(own_price_elasiticty_supply["EUR",,"tece"])
  # print(cross_price_elasiticty_supply["EUR",,"tece"])
  # 
  # print(cross_price_elasiticty_supply["EUR",,"livst_milk"])
  # print(cross_price_elasiticty_supply[,,"livst_milk"])
  # 
  # print(cross_price_elasiticty_supply["SSA",,"soybean"])
  # print(own_price_elasiticty_supply["SSA",,"soybean"])
  # print(prod_change_cross["SSA",,"soybean"])
  # print(prod_change_own["SSA",,"soybean"])
  # print(p21_prod_cross["SSA",,"soybean"])
  # print(p21_price_cross["SSA",,"soybean"])
  # print(price_change_cross["SSA",,"soybean"])
  # print(prod_change_cross["SSA",,"soybean"])
  # 
  # own_price_elasiticty_supply["USA",1,"livst_pig"]
  # cross_price_elasiticty_supply["USA",1,"livst_pig"]
  # p21_price_cross["USA",1,"livst_pig"]
  # price_change_cross["USA",1,"livst_pig"]
  # p21_prod_cross["USA",1,"livst_pig"]
  # 
  # 
  # 3810.018
  # 3175.015
  # 
  # print(p21_cost_cross["SSA",,])
  # 
  # price_change_own[,,"maiz"][,,"20"]
  # 
  # print(p21_cost_own["SSA",1:9,"soybean"]/collapseNames(p21_cost_own["SSA",1:9,"soybean"][,,"0"])-1)
  # print(price_change_own["SSA",1:9,"soybean"])
  # print(p21_price_own["SSA",1:9,"soybean"])
  # print(p21_price_cross["SSA",1:9,"soybean"])
  
  if(file) {
    for (shock in getNames(p21_prod_cross,dim=2)) {
      write.report(collapseNames(p21_prod_cross[,,shock]),"output/prod_cross.csv",append = TRUE,model = "MAgPIE",scenario = paste(scen,shock,sep="_"),unit = "mio tDM per year")
      write.report(collapseNames(p21_price_cross[,,shock]),"output/price_cross.csv",append = TRUE,model = "MAgPIE",scenario = paste(scen,shock,sep="_"),unit = "USD05MER per tDM")
      write.report(collapseNames(cross_price_elasiticty_supply[,,shock]),"output/price_elasiticty_supply_cross.csv",append = TRUE,model = "MAgPIE",scenario = paste(scen,shock,sep="_"),unit = "%")
    }
    for (shock in getNames(p21_prod_own,dim=2)) {
      write.report(collapseNames(p21_prod_own[,,shock]),"output/prod_own.csv",append = TRUE,model = "MAgPIE",scenario = paste(scen,shock,sep="_"),unit = "mio tDM per year")
      write.report(collapseNames(p21_price_own[,,shock]),"output/price_own.csv",append = TRUE,model = "MAgPIE",scenario = paste(scen,shock,sep="_"),unit = "USD05MER per tDM")
      write.report(collapseNames(own_price_elasiticty_supply[,,shock]),"output/price_elasiticty_supply_own.csv",append = TRUE,model = "MAgPIE",scenario = paste(scen,shock,sep="_"),unit = "%")
    }
  } else return(own_price_elasiticty_supply)
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
