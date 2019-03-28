*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

*' @title Peatland
*'
*' @description The peatland module calculates GHG emissions from degrading/drained peatlands.
*'
*' @authors Florian Humpenöder

*###################### R SECTION START (MODULETYPES) ##########################
$Ifi "%peatland%" == "ipcc_2014" $include "./modules/58_peatland/ipcc_2014.gms"
$Ifi "%peatland%" == "ipcc_2014_mar19" $include "./modules/58_peatland/ipcc_2014_mar19.gms"
$Ifi "%peatland%" == "off" $include "./modules/58_peatland/off.gms"
*###################### R SECTION END (MODULETYPES) ############################
