*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

if(s22_reconversion = 1 AND m_year(t) > sm_fix_SSP2,
  p22_reconv_done(j,land_reconv22) = p22_reconv_done(j,land_reconv22)
        + sum(land_ag, vm_lu_transitions.l(j,land_ag,land_reconv22));
);

*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 oq22_reconversion(t,j,"marginal") = q22_reconversion.m(j);
 oq22_reconversion(t,j,"level")    = q22_reconversion.l(j);
 oq22_reconversion(t,j,"upper")    = q22_reconversion.up(j);
 oq22_reconversion(t,j,"lower")    = q22_reconversion.lo(j);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################
