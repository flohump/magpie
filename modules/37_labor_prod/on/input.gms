*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

$setglobal c37_labour_switch  cc

scalars
s37_adapt_irr blub / 1 /
s37_adapt_fore blub / 1 /
s37_adapt_harv blub / 1 /
;

parameter f37_labor_prod_cc(t_all,j) LAMACLIMA yield reduction
/
$ondelim
$include "./modules/37_labor_prod/on/input/f38_labour_impact.cs2"
$offdelim
/;
