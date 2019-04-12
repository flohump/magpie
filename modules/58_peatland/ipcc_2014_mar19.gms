*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

*' @description In the ipcc_2014 realization GHG emissions from degrading/drained peatlands
*' are calculated based on GHG emission factors from the 
*' "2013 Supplement to the 2006 IPCC Guidelines for National Greenhouse Gas Inventories: Wetlands".
*' Also rewetting of drained peatlands as mitigation option is available. 
*' @stop


*'
*' @limitations Organic carbon stocks in peatlands are not accounted for. 

*####################### R SECTION START (PHASES) ##############################
$Ifi "%phase%" == "sets" $include "./modules/58_peatland/ipcc_2014_mar19/sets.gms"
$Ifi "%phase%" == "declarations" $include "./modules/58_peatland/ipcc_2014_mar19/declarations.gms"
$Ifi "%phase%" == "input" $include "./modules/58_peatland/ipcc_2014_mar19/input.gms"
$Ifi "%phase%" == "equations" $include "./modules/58_peatland/ipcc_2014_mar19/equations.gms"
$Ifi "%phase%" == "scaling" $include "./modules/58_peatland/ipcc_2014_mar19/scaling.gms"
$Ifi "%phase%" == "preloop" $include "./modules/58_peatland/ipcc_2014_mar19/preloop.gms"
$Ifi "%phase%" == "presolve" $include "./modules/58_peatland/ipcc_2014_mar19/presolve.gms"
$Ifi "%phase%" == "postsolve" $include "./modules/58_peatland/ipcc_2014_mar19/postsolve.gms"
*######################## R SECTION END (PHASES) ###############################
