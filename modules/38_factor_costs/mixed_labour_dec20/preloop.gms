*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

vm_cost_inv.fx(i)=0;

* Initialise K, L and C
p38_fac_req_ini(j,kcr,w) = f38_fac_req(kcr,w);
s38_beta  = 1 - s38_alpha ; 
*alpha = (K.l * i)/C.l ;  
p38_capital_ini(j,kcr,w) = (s38_alpha*p38_fac_req_ini(j,kcr,w))/sum(cell(i,j), pm_interest("y1995",i));
p38_labour_ini(j,kcr,w) = (s38_beta*p38_fac_req_ini(j,kcr,w))/s38_wage;

v38_fac_req.lo(j,kcr,w) = p38_fac_req_ini(j,kcr,w);
v38_fac_req.l(j,kcr,w) = p38_fac_req_ini(j,kcr,w);
v38_fac_req.up(j,kcr,w) = 10 * p38_fac_req_ini(j,kcr,w);

v38_capital.lo(j,kcr,w) = 0.0001;
v38_capital.l(j,kcr,w) = p38_capital_ini(j,kcr,w);
v38_capital.up(j,kcr,w) = 10 * p38_capital_ini(j,kcr,w);

v38_labour.lo(j,kcr,w) = 0.0001;
v38_labour.l(j,kcr,w) = p38_labour_ini(j,kcr,w);
v38_labour.up(j,kcr,w) = 10 * p38_labour_ini(j,kcr,w);

* 	Calibrate the CES function:
s38_ep = (1/s38_es) - 1 ;

vm_prod.l(j,kcr)=sum(cell(i,j),sum(w, fm_croparea("y1995",j,w,kcr))*f38_region_yield(i,kcr)* sum(supreg(h,i),fm_tau1995(h)));

