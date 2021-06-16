*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @description The main goal of this realization is to improve crop patterns at different spatial
*' scales. Specifically, the goal is reached by reducing capital relocation flexibility between
*' crop types. In the "sticky" realization, the factor costs are separated into labour and
*' capital investment costs. Then, capital is furtherly divided into immobile and mobile, where
*' mobility is defined between crops. In this way, changes in cropland are favored in locations
*' with existing capital stocks. This realization includes a CES production function, which   
*' accounts for labour productivity from the labour productivity module [37_labor_prod].

*' @limitations This realization assumes that factor costs, within a region,
*' purely depend on the production and are independent of the area under cultivation.
*' By implication, cases in which the harvested area could significantly influence
*' factors costs are hardly accounted in this realization.


*####################### R SECTION START (PHASES) ##############################
$Ifi "%phase%" == "sets" $include "./modules/38_factor_costs/sticky_labour_jun21/sets.gms"
$Ifi "%phase%" == "declarations" $include "./modules/38_factor_costs/sticky_labour_jun21/declarations.gms"
$Ifi "%phase%" == "input" $include "./modules/38_factor_costs/sticky_labour_jun21/input.gms"
$Ifi "%phase%" == "equations" $include "./modules/38_factor_costs/sticky_labour_jun21/equations.gms"
$Ifi "%phase%" == "scaling" $include "./modules/38_factor_costs/sticky_labour_jun21/scaling.gms"
$Ifi "%phase%" == "preloop" $include "./modules/38_factor_costs/sticky_labour_jun21/preloop.gms"
$Ifi "%phase%" == "presolve" $include "./modules/38_factor_costs/sticky_labour_jun21/presolve.gms"
$Ifi "%phase%" == "postsolve" $include "./modules/38_factor_costs/sticky_labour_jun21/postsolve.gms"
*######################## R SECTION END (PHASES) ###############################
