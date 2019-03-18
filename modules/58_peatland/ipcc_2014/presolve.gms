*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

if(m_year(t) < 2015,
	pc58_peatland_man(j,status58,land58) = 0;
	v58_peatland_man.fx(j,status58,land58) = 0;
	pc58_peatland_intact(j) = 0;
	v58_peatland_intact.fx(j) = 0;
	s58_before_2015 = 1;
else
	if(s58_before_2015 = 1,
	pc58_man_land(j) = sum(land58, pcm_land(j,land58));
	pc58_man_land_shr(j,land58)$(pc58_man_land(j)>0) = pcm_land(j,land58)/pc58_man_land(j);
	pc58_man_land_shr(j,land58)$(pc58_man_land(j)=0) = 1/card(land58);
	p58_excess_peatland(t,j,land58) = f58_peatland_degrad(j)*pc58_man_land_shr(j,land58) - pcm_land(j,land58);
    p58_excess_peatland(t,j,land58)$(p58_excess_peatland(t,j,land58) < 0) = 0;
	pc58_peatland_man(j,"degrad",land58) = f58_peatland_degrad(j)*pc58_man_land_shr(j,land58) - p58_excess_peatland(t,j,land58);
	pc58_peatland_man(j,"unused",land58) = p58_excess_peatland(t,j,land58);
	pc58_peatland_man(j,"rewet",land58) = 0;
	pc58_peatland_intact(j) = f58_peatland_intact(j);
	v58_peatland_man.fx(j,status58,land58) = pc58_peatland_man(j,status58,land58);
	v58_peatland_intact.fx(j) = pc58_peatland_intact(j);
	p58_peatland_ratio(t,j,land58) = 0;
	else
	v58_peatland_man.lo(j,status58,land58) = 0;
	v58_peatland_man.up(j,"degrad",land58) = Inf;
	v58_peatland_man.up(j,"unused",land58) = Inf;
*	v58_peatland_man.up(j,"rewet",land58) = sum(status58, pc58_peatland_man(j,status58,land58))*s58_rewetting_switch;
	v58_peatland_man.up(j,"rewet",land58) = s58_rewetting_switch;
	v58_peatland_man.l(j,status58,land58) = pc58_peatland_man(j,status58,land58);
	v58_peatland_intact.lo(j) = 0;
	v58_peatland_intact.up(j) = pc58_peatland_intact(j);
	v58_peatland_intact.l(j) = pc58_peatland_intact(j);
		
	p58_peatland_cell_shr(t,j) = (sum((status58,land58), pc58_peatland_man(j,status58,land58)) + pc58_peatland_intact(j))/sum(land, pcm_land(j,land));
*	p58_peatland_ratio(t,j,land58) = p58_peatland_cell_shr(t,j);
	p58_peatland_ratio(t,j,land58)$(pc58_peatland_man(j,"degrad",land58)>0 AND pcm_land(j,land58)>0) = pc58_peatland_man(j,"degrad",land58)/pcm_land(j,land58);
*	p58_excess_peatland(t,j,land58)$(p58_peatland_ratio(t,j,land58)>1) = (p58_peatland_ratio(t,j,land58)-1)*pcm_land(j,land58);
*	p58_peatland_ratio(t,j,land58)$(p58_peatland_ratio(t,j,land58)>1) = 1;
	);
);

pc58_peatland_cost_past(j) = p58_peatland_cost_past(t,j);
