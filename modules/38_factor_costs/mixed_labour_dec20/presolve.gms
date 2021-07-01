*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*update CES parameters
pc38_sh(j,kcr,w) = (sum(cell(i,j), pm_interest(t,i)) * p38_capital_ini(j,kcr,w)**(1 + s38_ep)) / (sum(cell(i,j), pm_interest(t,i)) * p38_capital_ini(j,kcr,w)**(1 + s38_ep)  + s38_wage * p38_labour_ini(j,kcr,w)**(1 + s38_ep)) ; 
p38_sh(t,j,kcr,w) = pc38_sh(j,kcr,w);
*pc38_scale(j,kcr,w) = 1/([pc38_sh(j,kcr,w) * p38_capital_ini(j,kcr,w)**(-s38_ep) + (1 - pc38_sh(j,kcr,w)) * vm_labor_prod.l(j) * p38_labour_ini(j,kcr,w)**(-s38_ep)]**(-1/s38_ep));
pc38_scale(j,kcr,w) = 1/([pc38_sh(j,kcr,w) * p38_capital_ini(j,kcr,w)**(-s38_ep) + (1 - pc38_sh(j,kcr,w)) * p38_labour_ini(j,kcr,w)**(-s38_ep)]**(-1/s38_ep));

v38_scale.fx(j,kcr,w) = 0;
