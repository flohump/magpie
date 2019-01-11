*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

 q58_peatland_area(j2) ..
	sum((status58,land58), v58_peatland_man(j2,status58,land58)) + v58_peatland_intact(j2) =e= 
	sum((status58,land58), pc58_peatland_man(j2,status58,land58)) + pc58_peatland_intact(j2);

 q58_peatland_degrad(j2,land58) ..
	v58_peatland_man(j2,"degrad",land58) + v58_peatland_missing(j2) =e=
	pc58_peatland_man(j2,"degrad",land58)$(s58_before_2015=1)
  + (vm_land(j2,land58)*sum(ct, p58_peatland_ratio(ct,j2,land58)))$(s58_before_2015=0);

 q58_peatland_transition(j2,land58) ..
	sum(status58, v58_peatland_man_diff(j2,status58,land58)) =g= 0;
 
 q58_peatland_man_diff(j2,status58,land58) ..
	v58_peatland_man_diff(j2,status58,land58) =e= 
	v58_peatland_man(j2,status58,land58)-pc58_peatland_man(j2,status58,land58);

 q58_peatland_cost(j2) ..
	vm_peatland_cost(j2) =e= v58_peatland_missing(j2)*1000000 + v58_peatland_cost_annuity(j2) + pc58_peatland_cost_past(j2)
							+ sum(land58, v58_peatland_man(j2,"rewet",land58) * s58_rewet_cost_recur);
	
 q58_peatland_cost_annuity(j2) ..
	v58_peatland_cost_annuity(j2) =g=
    sum(land58, v58_peatland_man_diff(j2,"rewet",land58) * s58_rewet_cost_onetime)
	* sum(cell(i2,j2),pm_interest(i2)/(1+pm_interest(i2)));

 q58_peatland_emis_detail(j2,climate58,status58,land58,emis58) ..
	v58_peatland_emis(j2,climate58,status58,land58,emis58) =e=
	v58_peatland_man(j2,status58,land58) * p58_ipcc_wetland_ef(climate58,land58,emis58,status58) *
                 p58_mapping_cell_climate(j2,climate58);

 q58_peatland_emis(j2) ..
	vm_peatland_emis(j2) =e=
	sum((climate58,status58,land58,emis58), v58_peatland_emis(j2,climate58,status58,land58,emis58));

 q58_peatland_ghgsaving(j2) ..
	vm_peatland_ghgsaving(j2) =e=
	(sum((climate58,land58,emis58), 
	(p58_ipcc_wetland_ef(climate58,land58,emis58,"degrad")-p58_ipcc_wetland_ef(climate58,land58,emis58,"rewet"))
	* v58_peatland_man(j2,"rewet",land58)
	* p58_mapping_cell_climate(j2,climate58))
  + sum((climate58,emis58), 
	p58_ipcc_wetland_ef(climate58,"crop",emis58,"degrad")
	* v58_peatland_intact(j2)
	* p58_mapping_cell_climate(j2,climate58)))
	* s58_peatland_policy_horizon;
