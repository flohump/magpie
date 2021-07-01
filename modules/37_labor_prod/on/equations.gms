*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de


*' @equations

*labor productivity used in factor costs
*f37_labor_prod_cc: CC impacts on labor prod from Anton, based on ISIMIP data
*v37_adapt_irr, v37_adapt_fore, v37_adapt_harv: impacts of LCLM on labor productivity 
*vm_labor_prod has an upper bound of 1. Does that make sense? That is the reason why for the =l= instead of =e=.
* Otherwise the model woud have an incentive to increase vm_labor_prod beyond 1. 
* And irrigation might be stopped if vm_labor_prod=1, in places that would be irrigated in the absence of q37_labor_prod.

 q37_labor_prod(j2) ..
  vm_labor_prod(j2) =e= sum(ct, i37_labor_prod_cc(ct,j2)) + v37_adapt_irr(j2) + v37_adapt_fore(j2) + v37_adapt_harv(j2);

*labour prod impacts of irrigation; depends on irrigated cropland; irrigation == cooling
*Dummy numbers (1-0.7) assume that irrigation has a beneficial effect on labor prod.
*1 = labor prod from ESM IRR scen; full irrigated cropland in all cells
*0.7 = labor prod from ESM CROP scen; full rainfed cropland in all cells
*The difference 1-0.7 gives the labor prod effect of full irrigation vs. no irrigation of the complete grid cell.
*Therefore, the effect is scaled by the ratio of irrigated area in MAgPIE and total land area. 
*Since vm_area is a variable, irrigated area can be expanded endogenously to increase labor productivity.
*Note that this effect depends on the stock of irrigated area, i.e. if the irrigated area remains unchanged there is a beneficial effect. Does that make senese?
 q37_adapt_irr(j2) ..
 v37_adapt_irr(j2) =e= (1-0.7)/sum(land, pcm_land(j2,land)) * sum(kcr, vm_area(j2,kcr,"irrigated")) * s37_adapt_irr2;

*labour prod impacts of forest land cover; forest == cooling
*Same logic as for irr
*Dummy numbers (1-0.7) assume that forest cover has a beneficial effect on labor prod.
*1 = labor prod from ESM FRST scen; full forest in all cells
*0.7 = labor prod from ESM CROP scen; full cropland in all cells
*Afforestation increases vm_labor_prod, deforestation reduces vm_labor_prod
*Note that this effect depends on the stock of forest, i.e. if the forest cover remains unchanged there is a beneficial effect. Does that make senese?
 q37_adapt_fore(j2) ..
 v37_adapt_fore(j2) =e= (1-0.7)/sum(land, pcm_land(j2,land)) * sum(land_fore37, vm_land(j2,land_fore37)) * s37_adapt_fore2;

*labour prod impacts of wood harvesting; wood harvesting == temporary warming; e.g. ac50 -> to ac0; not accounted for in forest cover.
*Dummy numbers (0.7-1) assume that harvested forest has a detrimental effect on labor prod.
*0.7 = labor prod from ESM HARV scen; full harvested forest in all cells
*1 = labor prod from ESM FRST scen; full forest in all cells
*The expected adaptation effect is that the model will optimize the harvesting patterns such that v37_adapt_harv is maximized. 
*In contrast to irr and fore, this effect depends on the harvested area, which is a flow variable. I.e. if there is no harvest, there is no detrimental effect.
 q37_adapt_harv(j2) ..
 v37_adapt_harv(j2) =e= 0;
* (0.7-1)/sum(land, pcm_land(j2,land)) * (sum(ac_sub, vm_hvarea_forestry(j2,ac_sub) + vm_hvarea_secdforest(j2,ac_sub) + vm_hvarea_other(j2, ac_sub)) + vm_hvarea_primforest(j2)) * s37_adapt_harv2;
