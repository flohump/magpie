*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

i17_prod_reg(t,i,kall) = f17_prod_reg(t,i,kall,"%c17_prod_scen%");
pm_prod_shock(i,k) = 1;
*define shock scenarios
p17_shock_scen("0") = 0;
p17_shock_scen("5") = 0.05;
p17_shock_scen("10") = 0.1;
p17_shock_scen("20") = 0.2;
p17_shock_scen("40") = 0.4;
p17_shock_scen("80") = 0.8;
