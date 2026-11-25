*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

if(s22_reconversion = 1 AND m_year(t) > sm_fix_SSP2,
* Reconversion counts net of conversion of natural vegetation to agricultural land and at most the growth of natural vegetation
* (growth from transitions: pcm_land is already updated in module 10 postsolve)
  p22_reconv_net_shr(j) = sum((land_ag,land_reconv22), vm_lu_transitions.l(j,land_ag,land_reconv22));
  p22_reconv_net_shr(j)$(p22_reconv_net_shr(j) > 0) =
        max(0, min(p22_reconv_net_shr(j) - sum((land_natveg,land_ag), vm_lu_transitions.l(j,land_natveg,land_ag)),
                   sum((land,land_natveg), vm_lu_transitions.l(j,land,land_natveg) - vm_lu_transitions.l(j,land_natveg,land))))
        / p22_reconv_net_shr(j);
  p22_reconv_done(j,land_reconv22) = p22_reconv_done(j,land_reconv22)
        + sum(land_ag, vm_lu_transitions.l(j,land_ag,land_reconv22)) * p22_reconv_net_shr(j);
* Only reconversion up to the target is protected; abandonment beyond it stays unprotected
  pm_land_reconv(j) = sum(land_reconv22, p22_reconv_done(j,land_reconv22));
  p22_reconv_done(j,land_reconv22)$(pm_land_reconv(j) > i22_reconv_target(t,j,"ag")) =
        p22_reconv_done(j,land_reconv22) * i22_reconv_target(t,j,"ag") / pm_land_reconv(j);
  p22_reconv_shortfall(t,j,"ag") = max(0, i22_reconv_target(t,j,"ag") - pm_land_reconv(j));
  pm_land_reconv(j) = min(pm_land_reconv(j), i22_reconv_target(t,j,"ag"));
);

*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 oq22_reconversion(t,j,"marginal") = q22_reconversion.m(j);
 oq22_reconversion(t,j,"level")    = q22_reconversion.l(j);
 oq22_reconversion(t,j,"upper")    = q22_reconversion.up(j);
 oq22_reconversion(t,j,"lower")    = q22_reconversion.lo(j);
 oq22_reconversion_stock(t,j,"marginal") = q22_reconversion_stock.m(j);
 oq22_reconversion_stock(t,j,"level")    = q22_reconversion_stock.l(j);
 oq22_reconversion_stock(t,j,"upper")    = q22_reconversion_stock.up(j);
 oq22_reconversion_stock(t,j,"lower")    = q22_reconversion_stock.lo(j);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################
