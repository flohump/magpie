*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @equations
*' Gross transitions from cropland and pasture to secondary forest and other natural land
*' must at least match the reconversion due in the current time step (abandonment counts).

 q22_reconversion(j2)$(sum(ct, p22_reconv(ct,j2)) > 0) ..
          sum((land_ag,land_reconv22), vm_lu_transitions(j2,land_ag,land_reconv22))
          =g=
          sum(ct, p22_reconv(ct,j2));
