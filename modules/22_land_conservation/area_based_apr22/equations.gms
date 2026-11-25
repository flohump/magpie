*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @equations
*' Natural vegetation must grow and cropland plus pasture shrink by at least the reconversion due
*' in the current time step (abandonment counts). Stock changes, since land transitions are not unique.

 q22_reconversion(j2)$(sum(ct, p22_reconv(ct,j2)) > 0) ..
          sum(land_natveg, vm_land(j2,land_natveg) - pcm_land(j2,land_natveg))
          =g=
          sum(ct, p22_reconv(ct,j2));

 q22_reconversion_ag(j2)$(sum(ct, p22_reconv(ct,j2)) > 0) ..
          sum(land_ag, pcm_land(j2,land_ag) - vm_land(j2,land_ag))
          =g=
          sum(ct, p22_reconv(ct,j2));
