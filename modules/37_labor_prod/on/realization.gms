*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @description This realization accounts for climate change impacts on 
*' labour productivity, based on ESM experiments from the LAMACLIMA project <https://climateanalytics.org/projects/lamaclima/>.
*' In addition, land management (irrigation, afforestation, wood harvesting)
*' can be employed as adaptation measure to minimize negative impacts
*' on labour productivity.
*'
*' @limitations no known limitations


*####################### R SECTION START (PHASES) ##############################
$Ifi "%phase%" == "sets" $include "./modules/37_labor_prod/on/sets.gms"
$Ifi "%phase%" == "declarations" $include "./modules/37_labor_prod/on/declarations.gms"
$Ifi "%phase%" == "input" $include "./modules/37_labor_prod/on/input.gms"
$Ifi "%phase%" == "equations" $include "./modules/37_labor_prod/on/equations.gms"
$Ifi "%phase%" == "preloop" $include "./modules/37_labor_prod/on/preloop.gms"
$Ifi "%phase%" == "presolve" $include "./modules/37_labor_prod/on/presolve.gms"
$Ifi "%phase%" == "postsolve" $include "./modules/37_labor_prod/on/postsolve.gms"
*######################## R SECTION END (PHASES) ###############################
