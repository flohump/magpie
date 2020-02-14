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

options(error=function()traceback(2))

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdirs <- path("output/",list.dirs("output/", full.names = FALSE, recursive = FALSE))
  #Define arguments that can be read from command line
  readArgs("outputdirs")
}
###############################################################################
cat("\nStarting output generation\n")

forestry <- NULL
missing <- NULL
all <- NULL

for (i in 1:length(outputdirs)) {
  print(paste("Processing",outputdirs[i]))
  #gdx file
  gdx<-path(outputdirs[i],"fulldata.gdx")
  if(file.exists(gdx)) {
    #get scenario name
    load(path(outputdirs[i],"config.Rdata"))
    scen <- cfg$title
    #read-in reporting file
    x <- collapseNames(land(gdx,level="glo")[,,"forestry"])
    x <- x-setYears(x[,1,],NULL)
    forestry <- mbind(forestry,setNames(x,scen))
    
    tmp <- strsplit(scen,"_")[[1]]
    co2_price <- tmp[2]
    variable <- tmp[3]
    label <- tmp[4]
    x <- as.data.table(as.quitte(x))
    x <- x[,.(region,period,value)]
    if (variable!="default") {
      all <- rbind(all,cbind(co2_price,variable,label,x))
    }
  } else missing <- c(missing,outputdirs[i])
}
if (!is.null(missing)) {
  cat("\nList of folders with missing fulldata.gdx\n")
  print(missing)
}

write.csv(all,"output/data_aff.csv",row.names = F)
#a <- data.table(read.csv("data.csv"))
#ggplot(all,aes(x=period,y=value,color=variable,label=label,group=label)) + geom_line()+geom_label_repel(data = subset(all, period == max(period)),direction = "x",show.legend = F) + facet_wrap(vars(co2_price),nrow = 1)

# p <- magpie2ggplot2(forestry,scenario = 1,ylab = "Mha",title = "Afforestation",legend_position = "bottom",group = NULL,legend_ncol = 1)
# ggsave(plot = p,filename = "output/aff_area.pdf",width = 8,height = 7)
