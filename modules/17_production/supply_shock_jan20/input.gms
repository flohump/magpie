*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

$setglobal c17_prod_scen	SSP2
*   options are SSP1-5

table f17_prod_reg(t_all,i,kall,s17_scen) production pattern (mio. tDM per yr)
$ondelim
$include "./modules/17_production/input/f17_prod_reg.cs3"
$offdelim;
