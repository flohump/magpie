*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

* Lower bound on vm_tau for t_past results in very low land expansion. 
* Lower costs for land conversion in t_past based on im_development_state
*' aim for a better balance of land expansion and intensification. 

if (sum(sameas(t_past,t),1) = 1,
	i39_cost_clearing(t,i,land_clearing39) = s39_cost_clearing_hist;
	i39_cost_establish(t,i,"crop") = s39_cost_establish_crop * im_development_state(t,i);
	i39_cost_establish(t,i,"past") = s39_cost_establish_past * im_development_state(t,i);
	i39_cost_establish(t,i,"forestry") = s39_cost_establish_forestry * im_development_state(t,i);
	i39_cost_establish(t,i,"urban") = s39_cost_establish_urban * im_development_state(t,i);
else
	i39_cost_clearing(t,i,land_clearing39) = s39_cost_clearing_future;
	i39_cost_establish(t,i,"crop") = s39_cost_establish_crop;
	i39_cost_establish(t,i,"past") = s39_cost_establish_past;
	i39_cost_establish(t,i,"forestry") = s39_cost_establish_forestry;
	i39_cost_establish(t,i,"urban") = s39_cost_establish_urban;
);
