*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

if(m_year(t) < 2015,
	pc58_peatland_man(j,man58,land58) = 0;
	v58_peatland_man.fx(j,man58,land58) = 0;
	pc58_peatland_intact(j) = 0;
	v58_peatland_intact.fx(j) = 0;
	v58_lu_transitions.fx(j2,from58,to58)$(not sameas(from58,to58)) = 0;
	s58_before_2015 = 1;
else
	if(s58_before_2015 = 1,
	pc58_helper(j,land_ini58) = vm_land.l(j,land_ini58) - vm_land.lo(j,land_ini58);
	pc58_man_land(j) = sum(land_ini58, pc58_helper(j,land_ini58));
	pc58_man_land_shr(j,land_ini58)$(pc58_man_land(j)>0) = pc58_helper(j,land_ini58)/pc58_man_land(j);
	pc58_man_land_shr(j,land_ini58)$(pc58_man_land(j)=0) = 1/card(land_ini58);
	p58_excess_peatland(t,j,land_ini58) = f58_peatland_degrad(j)*pc58_man_land_shr(j,land_ini58) - pcm_land(j,land_ini58);
    p58_excess_peatland(t,j,land_ini58)$(p58_excess_peatland(t,j,land_ini58) < 0) = 0;
	pc58_peatland_man(j,man58,land58) = 0;
	pc58_peatland_man(j,"degrad",land_ini58) = f58_peatland_degrad(j)*pc58_man_land_shr(j,land_ini58) - p58_excess_peatland(t,j,land_ini58);
	pc58_peatland_man(j,"unused",land_ini58) = p58_excess_peatland(t,j,land_ini58);
	pc58_peatland_intact(j) = f58_peatland_intact(j);
	v58_peatland_man.fx(j,man58,land58) = pc58_peatland_man(j,man58,land58);
	v58_peatland_intact.fx(j) = pc58_peatland_intact(j);
	p58_peatland_ratio(t,j,land58) = 0;
	v58_lu_transitions.fx(j2,from58,to58)$(not sameas(from58,to58)) = 0;
	else
	v58_peatland_man.lo(j,man58,land58) = 0;
	v58_peatland_man.up(j,"degrad",land58) = Inf;
	v58_peatland_man.up(j,"unused",land58) = Inf;
	v58_peatland_man.up(j,"rewet",land58) = s58_rewetting_switch;
	v58_peatland_man.l(j,man58,land58) = pc58_peatland_man(j,man58,land58);
	v58_peatland_intact.lo(j) = 0;
	v58_peatland_intact.up(j) = pc58_peatland_intact(j);
	v58_peatland_intact.l(j) = pc58_peatland_intact(j);
	
	v58_lu_transitions.fx(j2,from58,to58)$(not sameas(from58,to58)) = 0;
	v58_lu_transitions.up(j2,"intact","degrad_crop") = Inf;
	v58_lu_transitions.up(j2,"intact","degrad_past") = Inf;
	v58_lu_transitions.up(j2,"intact","degrad_forestry") = Inf;
	v58_lu_transitions.up(j2,"degrad_crop","unused_crop") = Inf;
	v58_lu_transitions.up(j2,"degrad_past","unused_past") = Inf;
	v58_lu_transitions.up(j2,"degrad_forestry","unused_forestry") = Inf;
	v58_lu_transitions.up(j2,"degrad_crop","rewet_crop") = Inf;
	v58_lu_transitions.up(j2,"degrad_past","rewet_past") = Inf;
	v58_lu_transitions.up(j2,"degrad_forestry","rewet_forestry") = Inf;
	v58_lu_transitions.up(j2,"unused_crop","rewet_crop") = Inf;
	v58_lu_transitions.up(j2,"unused_past","rewet_past") = Inf;
	v58_lu_transitions.up(j2,"unused_forestry","rewet_forestry") = Inf;
	v58_lu_transitions.up(j2,"unused_crop","degrad_crop") = Inf;
	v58_lu_transitions.up(j2,"unused_crop","degrad_past") = Inf;
	v58_lu_transitions.up(j2,"unused_crop","degrad_forestry") = Inf;
	v58_lu_transitions.up(j2,"unused_past","degrad_crop") = Inf;
	v58_lu_transitions.up(j2,"unused_past","degrad_past") = Inf;
	v58_lu_transitions.up(j2,"unused_past","degrad_forestry") = Inf;
	v58_lu_transitions.up(j2,"unused_forestry","degrad_crop") = Inf;
	v58_lu_transitions.up(j2,"unused_forestry","degrad_past") = Inf;
	v58_lu_transitions.up(j2,"unused_forestry","degrad_forestry") = Inf;
			
	p58_peatland_cell_shr(t,j) = (sum((man58,land58), pc58_peatland_man(j,man58,land58)) + pc58_peatland_intact(j))/sum(land, pcm_land(j,land));
*	p58_peatland_ratio(t,j,land58) = p58_peatland_cell_shr(t,j);
	p58_peatland_ratio(t,j,land58)$(pc58_peatland_man(j,"degrad",land58)>0 AND pcm_land(j,land58)>0) = pc58_peatland_man(j,"degrad",land58)/pcm_land(j,land58);
*	p58_excess_peatland(t,j,land58)$(p58_peatland_ratio(t,j,land58)>1) = (p58_peatland_ratio(t,j,land58)-1)*pcm_land(j,land58);
*	p58_peatland_ratio(t,j,land58)$(p58_peatland_ratio(t,j,land58)>1) = 1;
	);
);

p58_peatland_area(j) = sum((man58,land58), pc58_peatland_man(j,man58,land58)) + pc58_peatland_intact(j);
p58_land_area(j) = sum(land, pcm_land(j,land));

pc58_peatland_cost_past(j) = p58_peatland_cost_past(t,j);
