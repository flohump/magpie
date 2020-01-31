*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*set vm_cost_trade zero in order to avoid a free variable
vm_cost_trade.fx(i)               = 0;

p21_supply_shock(i,kall) = 1;
*define shock scenarios
p21_shock_scen("0") = 0;
p21_shock_scen("5") = 0.05;
p21_shock_scen("10") = 0.1;
p21_shock_scen("20") = 0.2;
