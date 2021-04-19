*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de



*K * i + L * w =e= C ; 
 q38_costfun(j2,kcr,w) ..
	v38_capital(j2,kcr,w) * sum((ct,cell(i2,j2)), pm_interest(ct,i2)) + v38_labour(j2,kcr,w) * s38_wage 
	=e= v38_fac_req(j2,kcr,w); 

$ontext




*A * [K**alpha * (cc * L)**beta] =e= 1 ;
 q38_cd_prodfun(j2,kcr,w)..		
  p38_scale(j2,kcr,w) * 
  [v38_capital(j2,kcr,w)**s38_alpha * (pc38_labour_impact(j2) * v38_labour(j2,kcr,w))**s38_beta] 
  =n= 1 ;
$offtext

*A * [sh*K**(-ep) + (1 - sh)*(cc * L)**(-ep)]**(-1/ep) =e= 1 ;
 q38_ces_prodfun(j2,kcr,w) ..
  pc38_scale(j2,kcr,w) * 
  [pc38_sh(j2,kcr,w)*v38_capital(j2,kcr,w)**(-s38_ep) + 
  (1 - pc38_sh(j2,kcr,w))*(vm_labor_prod(j2) * v38_labour(j2,kcr,w))**(-s38_ep)]**(-1/s38_ep) 
  =e= 1 ;

q38_scale(j2,kcr,w) ..
v38_scale(j2,kcr,w) =n= 1/([pc38_sh(j2,kcr,w) * p38_capital_ini(j2,kcr,w)**(-s38_ep) + (1 - pc38_sh(j2,kcr,w)) * vm_labor_prod(j2) * p38_labour_ini(j2,kcr,w)**(-s38_ep)]**(-1/s38_ep));


*' @equations

 q38_cost_prod_crop(i2,kcr) ..
  vm_cost_prod(i2,kcr) =e= sum((cell(i2,j2), w), (vm_area(j2,kcr,w) + 0.0001)*f38_region_yield(i2,kcr)
                            *vm_tau(i2)/fm_tau1995(i2)*v38_fac_req(j2,kcr,w));


*' The equation above shows that factor requirement costs `vm_cost_prod` mainly
*' depend on area harvested `vm_area` and average regional land-use intensity
*' levels `vm_tau`. Multiplying the land-use intensity increase increases
*' since 1995 with average regional yields `f38_region_yield` gives the
*' average regional yield. Multiplied with the area under production it gives
*' the production of this location assuming an average yield. Multiplied with
*' estimated factor requirement costs per volume `p38_fac_req` returns the
*' total factor costs.
*'
*' The crop-and-water specific factor costs per volume of crop production
*' `p38_fac_req` are obtained from @narayanan_gtap7_2008. Splitting factors
*' costs into costs under irrigation and under rainfed production was performed
*' based on the methodology described in @Calzadilla2011GTAP.
*'
*' In this realization, regardless of the cellular productivity, the factor
*' costs per area are identical for all cells within a region. This implicitly
*' gives an incentive to allocate and concentrate production to highly
*' productive cells.
