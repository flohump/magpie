*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

* Initialise K, L and C
p38_fac_req_ini(j,kcr) = f38_fac_req(kcr);
s38_beta  = 1 - s38_alpha ; 
*alpha = (K.l * i)/C.l ;  
p38_capital_ini(j,kcr) = (s38_alpha*p38_fac_req_ini(j,kcr))/sum(cell(i,j), pm_interest("y1995",i));
p38_labour_ini(j,kcr) = (s38_beta*p38_fac_req_ini(j,kcr)) / s38_wage * (1-s38_mi_start);


*' Estimate capital stock based on capital remuneration
p38_capital_immobile(t,j,kcr)   = sum(cell(i,j), p38_capital_ini(j,kcr)*s38_immobile*pm_croparea_start(j,kcr)*f38_region_yield(i,kcr)* fm_tau1995(i));
p38_capital_mobile(t,j)   = sum((cell(i,j),kcr), p38_capital_ini(j,kcr)*(1-s38_immobile)*pm_croparea_start(j,kcr)*f38_region_yield(i,kcr)* fm_tau1995(i));

v38_capital.lo(j,kcr) = 0.0001;
v38_capital.l(j,kcr) = p38_capital_ini(j,kcr);
v38_capital.up(j,kcr) = 10 * p38_capital_ini(j,kcr);

v38_labour.lo(j,kcr) = 0.0001;
v38_labour.l(j,kcr) = p38_labour_ini(j,kcr);
v38_labour.up(j,kcr) = 10 * p38_labour_ini(j,kcr);

vm_prod.l(j,kcr)=sum(cell(i,j),pm_croparea_start(j,kcr)*f38_region_yield(i,kcr)* fm_tau1995(i));
v38_investment_immobile.l(j,kcr) = vm_prod.l(j,kcr)*v38_capital.l(j,kcr)*s38_immobile
                                 - sum(ct,p38_capital_immobile(ct,j,kcr));
v38_investment_mobile.l(j) = sum(kcr, vm_prod.l(j,kcr)*v38_capital.l(j,kcr))*(1-s38_immobile)
                             -sum(ct,p38_capital_mobile(ct,j));

* 	Calibrate the CES function:
s38_ep = (1/s38_es) - 1 ;
