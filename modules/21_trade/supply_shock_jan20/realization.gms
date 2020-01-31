*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @description  This realization aggregates agricultural production from
*' cluster level `j` to regional level `i`. Currently, cluster level production
*' is available only for plant commodities, i.e for crops and pastures.
*' Cluster level production of different crops and pasture is calculated in
*' module [30_crop] and [31_past] respectively.

*' @limitations For the time being, this approach is not applied to livestock
*' products.

*####################### R SECTION START (PHASES) ##############################
$Ifi "%phase%" == "sets" $include "./modules/21_trade/supply_shock_jan20/sets.gms"
$Ifi "%phase%" == "declarations" $include "./modules/21_trade/supply_shock_jan20/declarations.gms"
$Ifi "%phase%" == "equations" $include "./modules/21_trade/supply_shock_jan20/equations.gms"
$Ifi "%phase%" == "preloop" $include "./modules/21_trade/supply_shock_jan20/preloop.gms"
$Ifi "%phase%" == "intersolve" $include "./modules/21_trade/supply_shock_jan20/intersolve.gms"
$Ifi "%phase%" == "postsolve" $include "./modules/21_trade/supply_shock_jan20/postsolve.gms"
*######################## R SECTION END (PHASES) ###############################
