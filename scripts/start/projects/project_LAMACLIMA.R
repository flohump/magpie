# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: LAMACLIMA WP4 runs
# ----------------------------------------------------------

######################################
#### Script to start a MAgPIE run ####
######################################

oecd_countries <- "ABW,AFG,AGO,AIA,ALA,ALB,AND,ARE,ARG,ARM,
                          ASM,ATA,ATF,ATG,AUS,AUT,AZE,BDI,BEL,BEN,
                          BES,BFA,BGD,BGR,BHR,BHS,BIH,BLM,BLR,BLZ,
                          BMU,BOL,BRA,BRB,BRN,BTN,BVT,BWA,CAF,CAN,
                          CCK,CHN,CHE,CHL,CIV,CMR,COD,COG,COK,COL,
                          COM,CPV,CRI,CUB,CUW,CXR,CYM,CYP,CZE,DEU,
                          DJI,DMA,DNK,DOM,DZA,ECU,EGY,ERI,ESH,ESP,
                          EST,ETH,FIN,FJI,FLK,FRA,FRO,FSM,GAB,GBR,
                          GEO,GGY,GHA,GIB,GIN,GLP,GMB,GNB,GNQ,GRC,
                          GRD,GRL,GTM,GUF,GUM,GUY,HKG,HMD,HND,HRV,
                          HTI,HUN,IDN,IMN,IND,IOT,IRL,IRN,IRQ,ISL,
                          ISR,ITA,JAM,JEY,JOR,JPN,KAZ,KEN,KGZ,KHM,
                          KIR,KNA,KOR,KWT,LAO,LBN,LBR,LBY,LCA,LIE,
                          LKA,LSO,LTU,LUX,LVA,MAC,MAF,MAR,MCO,MDA,
                          MDG,MDV,MEX,MHL,MKD,MLI,MLT,MMR,MNE,MNG,
                          MNP,MOZ,MRT,MSR,MTQ,MUS,MWI,MYS,MYT,NAM,
                          NCL,NER,NFK,NGA,NIC,NIU,NLD,NOR,NPL,NRU,
                          NZL,OMN,PAK,PAN,PCN,PER,PHL,PLW,PNG,POL,
                          PRI,PRK,PRT,PRY,PSE,PYF,QAT,REU,ROU,RUS,
                          RWA,SAU,SDN,SEN,SGP,SGS,SHN,SJM,SLB,SLE,
                          SLV,SMR,SOM,SPM,SRB,SSD,STP,SUR,SVK,SVN,
                          SWE,SWZ,SXM,SYC,SYR,TCA,TCD,TGO,THA,TJK,
                          TKL,TKM,TLS,TON,TTO,TUN,TUR,TUV,TWN,TZA,
                          UGA,UKR,UMI,URY,USA,UZB,VAT,VCT,VEN,VGB,
                          VIR,VNM,VUT,WLF,WSM,YEM,ZAF,ZMB,ZWE"


library(gms)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

#cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"
cfg$output <- c("rds_report","disaggregation","disaggregation_transitions")

prefix <- "LAMA01"
cfg$gms$s80_optfile <- 1
cfg$gms$s80_maxiter <- 5

cfg$gms$s15_elastic_demand <- 0

#https://miro.com/app/board/o9J_lVys8js=/

#Scenario 1, based on SDP
cfg$title <- paste(prefix,"SSP1-1p5deg",sep="_")
cfg <- setScenario(cfg,c("SDP","NDC","ForestryEndo"))
cfg$gms$s35_secdf_distribution <- 0
#1.5 degree policy
cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-Budg600"
cfg$gms$c56_pollutant_prices_noselect <- "R2M41-SSP2-NPi"
cfg$gms$policy_countries56  <- all_iso_countries
cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-Budg600"
#default food scenario
cfg$gms$c15_food_scenario <- "SSP1"
cfg$gms$c15_food_scenario_noselect <- "SSP1"
#exo diet and waste
cfg$gms$c15_exo_scen_targetyear <- "y2050"
cfg$gms$s15_exo_diet <- 1
cfg$gms$c15_EAT_scen <- "FLX"
cfg$gms$c15_kcal_scen <- "healthy_BMI"
cfg$gms$s15_exo_waste <- 1
cfg$gms$s15_waste_scen <- 1.2
cfg$gms$scen_countries15  <- all_iso_countries
#AFF
cfg$gms$s32_planing_horizon <- 80
cfg$gms$s32_aff_plantation <- 0
#EFP
cfg$gms$c42_env_flow_policy <- "on"
cfg$gms$EFP_countries  <- all_iso_countries
start_run(cfg,codeCheck=FALSE)

#Scenario 2, based on SSP4
cfg$title <- paste(prefix,"SSP4-1p5deg",sep="_")
cfg <- setScenario(cfg,c("SSP4","NDC","ForestryEndo"))
cfg$gms$s35_secdf_distribution <- 0
#1.5 degree policy
cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-Budg600"
cfg$gms$c56_pollutant_prices_noselect <- "R2M41-SSP2-NPi"
cfg$gms$policy_countries56  <- oecd_countries #todo
cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-Budg600"
#default food scenario
cfg$gms$c15_food_scenario <- "SSP4"
cfg$gms$c15_food_scenario_noselect <- "SSP4"
#exo diet and waste
cfg$gms$c15_exo_scen_targetyear <- "y2050"
cfg$gms$s15_exo_diet <- 1
cfg$gms$c15_EAT_scen <- "FLX"
cfg$gms$c15_kcal_scen <- "healthy_BMI"
cfg$gms$s15_exo_waste <- 1
cfg$gms$s15_waste_scen <- 1.2
cfg$gms$scen_countries15  <- oecd_countries #todo
#AFF
cfg$gms$s32_planing_horizon <- 80
cfg$gms$s32_aff_plantation <- 1
#EFP
cfg$gms$c42_env_flow_policy <- "on"
cfg$gms$EFP_countries  <- oecd_countries #todo
#start_run(cfg,codeCheck=FALSE)

