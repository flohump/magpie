*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

*' @description In the off realization, GHG emissions from degrading peatlands are assumed zero.

*' @limitations GHG emissions from degrading peatlands are assumed zero

*####################### R SECTION START (PHASES) ##############################
$Ifi "%phase%" == "declarations" $include "./modules/58_peatland/off/declarations.gms"
$Ifi "%phase%" == "preloop" $include "./modules/58_peatland/off/preloop.gms"
$Ifi "%phase%" == "postsolve" $include "./modules/58_peatland/off/postsolve.gms"
*######################## R SECTION END (PHASES) ###############################
