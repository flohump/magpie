*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de


 q58_transition_matrix(j2) ..
	sum((from58,to58), v58_lu_transitions(j2,from58,to58)) =e= 
	p58_peatland_area(j2);

 q58_transition_to(j2,to58) ..
	sum(from58, v58_lu_transitions(j2,from58,to58)) =e= 
	v58_peatland_man(j2,"degrad","crop")$(sameas(to58,"degrad_crop"))
	+ v58_peatland_man(j2,"degrad","past")$(sameas(to58,"degrad_past"))
	+ v58_peatland_man(j2,"degrad","forestry")$(sameas(to58,"degrad_forestry"))
	+ v58_peatland_man(j2,"unused","crop")$(sameas(to58,"unused_crop"))
	+ v58_peatland_man(j2,"unused","past")$(sameas(to58,"unused_past"))
	+ v58_peatland_man(j2,"unused","forestry")$(sameas(to58,"unused_forestry"))
	+ v58_peatland_man(j2,"rewet","crop")$(sameas(to58,"rewet_crop"))
	+ v58_peatland_man(j2,"rewet","past")$(sameas(to58,"rewet_past"))
	+ v58_peatland_man(j2,"rewet","forestry")$(sameas(to58,"rewet_forestry"))
	+ v58_peatland_intact(j2)$(sameas(to58,"intact"));

 q58_transition_from(j2,from58) ..
	sum(to58, v58_lu_transitions(j2,from58,to58)) =e= 
	pc58_peatland_man(j2,"degrad","crop")$(sameas(from58,"degrad_crop"))
	+ pc58_peatland_man(j2,"degrad","past")$(sameas(from58,"degrad_past"))
	+ pc58_peatland_man(j2,"degrad","forestry")$(sameas(from58,"degrad_forestry"))
	+ pc58_peatland_man(j2,"unused","crop")$(sameas(from58,"unused_crop"))
	+ pc58_peatland_man(j2,"unused","past")$(sameas(from58,"unused_past"))
	+ pc58_peatland_man(j2,"unused","forestry")$(sameas(from58,"unused_forestry"))
	+ pc58_peatland_man(j2,"rewet","crop")$(sameas(from58,"rewet_crop"))
	+ pc58_peatland_man(j2,"rewet","past")$(sameas(from58,"rewet_past"))
	+ pc58_peatland_man(j2,"rewet","forestry")$(sameas(from58,"rewet_forestry"))
	+ pc58_peatland_intact(j2)$(sameas(from58,"intact"));


*' The following two equations calculate land expansion and land contraction based
*' on the above land transition matrix.

 q58_expansion(j2,to58) ..
        v58_expansion(j2,to58) =e= 
        sum(from58$(not sameas(from58,to58)), 
        v58_lu_transitions(j2,from58,to58));

 q58_reduction(j2,from58) ..
        v58_reduction(j2,from58) =e= 
        sum(to58$(not sameas(from58,to58)), 
        v58_lu_transitions(j2,from58,to58));

*future peatland degradation scales proportionally with changes of managed land
*Example: if 5% of the area in a cell is converted to cropland, 5% of the total peatland area is degraded
*Scaled with ratio of peatland area and cell area. Proportional change. 
 q58_peatland_degrad(j2,land58) ..
	v58_peatland_man(j2,"degrad",land58) + v58_peatland_missing(j2,land58) =g=
	pc58_peatland_man(j2,"degrad",land58)
  + ((vm_land(j2,land58) - pcm_land(j2,land58))*p58_scaling_factor(j2))$(s58_before_2015=0);

*' Small costs of 1 $ per ha on gross land-use change avoid unrealistic patterns in the land transition matrix

 q58_peatland_cost(j2) ..
	vm_peatland_cost(j2) =e= sum(land58, v58_peatland_missing(j2,land58))*1000000 + v58_peatland_cost_annuity(j2) + pc58_peatland_cost_past(j2)
							+ sum(land58, v58_peatland_man(j2,"rewet",land58) * s58_rewet_cost_recur)
							+ sum(stat58, v58_expansion(j2,stat58) + v58_reduction(j2,stat58)) * 1;
	
 q58_peatland_cost_annuity(j2) ..
	v58_peatland_cost_annuity(j2) =g=
    sum((from58,stat_rewet58), v58_lu_transitions(j2,from58,stat_rewet58) * s58_rewet_cost_onetime)
	* sum(cell(i2,j2),pm_interest(i2)/(1+pm_interest(i2)));

 q58_peatland_emis_detail(j2,climate58,emis58) ..
	v58_peatland_emis(j2,climate58,emis58) =e=
	sum((man58,land58), v58_peatland_man(j2,man58,land58) * p58_ipcc_wetland_ef(climate58,land58,emis58,man58) *
                 p58_mapping_cell_climate(j2,climate58));

 q58_peatland_emis(j2) ..
	vm_peatland_emis(j2) =e=
	sum((climate58,emis58), v58_peatland_emis(j2,climate58,emis58));

 q58_peatland_ghgsaving(j2) ..
	vm_peatland_ghgsaving(j2) =e=
   sum((climate58,emis58), 
	(sum(land58, 
	(p58_ipcc_wetland_ef(climate58,land58,emis58,"degrad")-p58_ipcc_wetland_ef(climate58,land58,emis58,"rewet")) * v58_peatland_man(j2,"rewet",land58))
	+ p58_ipcc_wetland_ef(climate58,"crop",emis58,"degrad") * v58_peatland_intact(j2))
	* p58_mapping_cell_climate(j2,climate58))
	* s58_peatland_policy_horizon;
