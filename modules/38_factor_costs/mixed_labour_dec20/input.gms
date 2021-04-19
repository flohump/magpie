*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

$setglobal c38_labour_switch  nocc

scalars 
s38_alpha blub / 0.3 /
s38_wage blub / 1 /
s38_es blub / 0.3 /
s38_ces blub / 0 /
;

table f38_fac_req(kcr,w) Factor requirement costs (USD05MER per tDM)
$ondelim
$include "./modules/38_factor_costs/input/f38_fac_req.csv"
$offdelim;

table f38_region_yield(i,kcr) Regional crop yields (tDM per ha)
$ondelim
$include "./modules/38_factor_costs/mixed_labour_okt20/input/f38_region_yield.csv"
$offdelim;

parameter f38_labour_impact(t_all,j) LAMACLIMA yield reduction
/
$ondelim
$include "./modules/38_factor_costs/mixed_labour_okt20/input/f38_labour_impact.cs2"
$offdelim
/;
