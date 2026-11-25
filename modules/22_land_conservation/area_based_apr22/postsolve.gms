*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

if(s22_reconversion = 1 AND m_year(t) > sm_fix_SSP2,
* Reconversion counted = min of natural vegetation growth and agricultural decline, split by the net growth
* of each receiving pool (stock changes from transitions: pcm_land is already updated)
  p22_reconv_booked(j) = max(0, min(
        sum((land,land_natveg), vm_lu_transitions.l(j,land,land_natveg) - vm_lu_transitions.l(j,land_natveg,land)),
        sum((land_ag,land), vm_lu_transitions.l(j,land_ag,land) - vm_lu_transitions.l(j,land,land_ag))));
  p22_reconv_grow(j,land_reconv22) = max(0, sum(land, vm_lu_transitions.l(j,land,land_reconv22) - vm_lu_transitions.l(j,land_reconv22,land)));
  p22_reconv_done(j,land_reconv22)$(sum(land_reconv22_2, p22_reconv_grow(j,land_reconv22_2)) > 0) =
        p22_reconv_done(j,land_reconv22)
        + p22_reconv_booked(j) * p22_reconv_grow(j,land_reconv22) / sum(land_reconv22_2, p22_reconv_grow(j,land_reconv22_2));
* Only reconversion up to the target (incl. moved targets) is protected; abandonment beyond it stays unprotected
  pm_land_reconv(j) = sum(land_reconv22, p22_reconv_done(j,land_reconv22));
  p22_reconv_done(j,land_reconv22)$(pm_land_reconv(j) > i22_reconv_target(t,j,"ag") + p22_reconv_ag_add(j)) =
        p22_reconv_done(j,land_reconv22) * (i22_reconv_target(t,j,"ag") + p22_reconv_ag_add(j)) / pm_land_reconv(j);
  pm_land_reconv(j) = min(pm_land_reconv(j), i22_reconv_target(t,j,"ag") + p22_reconv_ag_add(j));
* Regional remainder, reported in the clusters that miss their own target
  p22_ag_short(j) = max(0, i22_reconv_target(t,j,"ag") - pm_land_reconv(j));
  p22_ag_short_reg(i) = sum(cell(i,j), p22_ag_short(j));
  p22_ag_over_reg(i) = sum(cell(i,j), max(0, pm_land_reconv(j) - i22_reconv_target(t,j,"ag")));
  p22_reconv_shortfall(t,j,"ag") = sum(cell(i,j)$(p22_ag_short_reg(i) > 0),
        p22_ag_short(j) * max(0, p22_ag_short_reg(i) - p22_ag_over_reg(i)) / p22_ag_short_reg(i));
);

*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 oq22_reconversion(t,j,"marginal") = q22_reconversion.m(j);
 oq22_reconversion(t,j,"level")    = q22_reconversion.l(j);
 oq22_reconversion(t,j,"upper")    = q22_reconversion.up(j);
 oq22_reconversion(t,j,"lower")    = q22_reconversion.lo(j);
 oq22_reconversion_ag(t,j,"marginal") = q22_reconversion_ag.m(j);
 oq22_reconversion_ag(t,j,"level")    = q22_reconversion_ag.l(j);
 oq22_reconversion_ag(t,j,"upper")    = q22_reconversion_ag.up(j);
 oq22_reconversion_ag(t,j,"lower")    = q22_reconversion_ag.lo(j);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################
