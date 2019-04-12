*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

if(m_year(t) < 2015,
*fix peatland area to zero
	pc58_peatland_man(j,man58,land58) = 0;
	v58_peatland_man.fx(j,man58,land58) = 0;
	pc58_peatland_intact(j) = 0;
	v58_peatland_intact.fx(j) = 0;
	v58_lu_transitions.fx(j2,from58,to58)$(not sameas(from58,to58)) = 0;
	s58_before_2015 = 1;
else
	p58_peatland_area(j) = f58_peatland_degrad(j) + f58_peatland_intact(j);
	p58_land_area(j) = sum(land, pcm_land(j,land));
	
	if(s58_before_2015 = 1,
*Initialize peatland area	
	pc58_peatland_man(j,man58,land58) = 0;
	p58_peatland_degrad_left(j) = f58_peatland_degrad(j);
*First, all degraded peatland is assigned to cropland, but pcm_land(j,"crop") is the upper limit.
	pc58_peatland_man(j,"degrad","crop") = min(p58_peatland_degrad_left(j),pcm_land(j,"crop")/p58_land_area(j)*p58_peatland_area(j));
	p58_peatland_degrad_left(j) = p58_peatland_degrad_left(j)-pc58_peatland_man(j,"degrad","crop");
*Second, the remaining undistributed degraded peatland is assigned to pasture but pcm_land(j,"past") is the upper limit.
	pc58_peatland_man(j,"degrad","past") = min(p58_peatland_degrad_left(j),pcm_land(j,"past")/p58_land_area(j)*p58_peatland_area(j));
	p58_peatland_degrad_left(j) = p58_peatland_degrad_left(j)-pc58_peatland_man(j,"degrad","past");
*Third, the remaining undistributed degraded peatland is assigned to forestry but pcm_land(j,"forestry") is the upper limit.
	pc58_peatland_man(j,"degrad","forestry") = min(p58_peatland_degrad_left(j),pcm_land(j,"forestry")/p58_land_area(j)*p58_peatland_area(j));
	p58_peatland_degrad_left(j) = p58_peatland_degrad_left(j)-pc58_peatland_man(j,"degrad","forestry");
*Finally, the remaining undistributed degraded peatland is equally distributed among crop, past and forestry.
	pc58_peatland_man(j,"unused",land58) = p58_peatland_degrad_left(j)/card(land58);

*fix peatland area to 2015 levels in 2015	
	pc58_peatland_intact(j) = f58_peatland_intact(j);
	v58_peatland_man.fx(j,man58,land58) = pc58_peatland_man(j,man58,land58);
	v58_peatland_intact.fx(j) = pc58_peatland_intact(j);
	v58_lu_transitions.fx(j2,from58,to58)$(not sameas(from58,to58)) = 0;
	else
*defne bound for peatland area after 2015
	v58_peatland_man.lo(j,man58,land58) = 0;
	v58_peatland_man.up(j,"degrad",land58) = Inf;
	v58_peatland_man.up(j,"unused",land58) = Inf;
	v58_peatland_man.up(j,"rewet",land58) = s58_rewetting_switch;
	v58_peatland_man.l(j,man58,land58) = pc58_peatland_man(j,man58,land58);
	v58_peatland_intact.lo(j) = 0;
	v58_peatland_intact.up(j) = pc58_peatland_intact(j);
	v58_peatland_intact.l(j) = pc58_peatland_intact(j);

*define allowed transitions within peatland area	
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
			
	);
);

pc58_peatland_cost_past(j) = p58_peatland_cost_past(t,j);
