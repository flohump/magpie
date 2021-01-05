*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @equations
*' Land establishment costs apply on expansion of cropland, pasture and forestry.
*' Land clearing costs apply on reduction of carbon stock in primary forest, secondary forest
*' and other natural land.
*' The sum of land establishment and land clearing costs in the current time step
*' is multiplied with an annuity factor to distribute these costs over time.

q39_cost_landcon(j2) .. vm_cost_landcon(j2,"crop") =e=
(
sum((natveg_from39,managed_to39), v10_lu_transitions(j2,natveg_from39,managed_to39) * i39_cost_transition(natveg_from39,managed_to39) * sum((ct,cell(i2,j2)), im_development_state(ct,i2)**2))
+
sum((managed_from39,managed_to39), v10_lu_transitions(j2,managed_from39,managed_to39)$(not sameas(managed_from39,managed_to39)) * i39_cost_transition(managed_from39,managed_to39) * sum((ct,cell(i2,j2)), im_development_state(ct,i2)**2))
*	+ sum(land, vm_carbon_stock_reduction(j2,land,"vegc")*5))
	+ sum((land,c_pools), vm_carbon_stock_reduction(j2,land,c_pools)*5))
 	* sum((cell(i2,j2),ct),pm_interest(ct,i2)/(1+pm_interest(ct,i2)));
