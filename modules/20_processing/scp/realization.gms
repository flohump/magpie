*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*####################### R SECTION START (PHASES) ##############################
$Ifi "%phase%" == "sets" $include "./modules/20_processing/scp/sets.gms"
$Ifi "%phase%" == "declarations" $include "./modules/20_processing/scp/declarations.gms"
$Ifi "%phase%" == "input" $include "./modules/20_processing/scp/input.gms"
$Ifi "%phase%" == "equations" $include "./modules/20_processing/scp/equations.gms"
$Ifi "%phase%" == "scaling" $include "./modules/20_processing/scp/scaling.gms"
$Ifi "%phase%" == "presolve" $include "./modules/20_processing/scp/presolve.gms"
$Ifi "%phase%" == "postsolve" $include "./modules/20_processing/scp/postsolve.gms"
*######################## R SECTION END (PHASES) ###############################
