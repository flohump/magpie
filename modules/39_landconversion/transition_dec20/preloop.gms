*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

vm_cost_landcon.fx(j,land) = 0;
vm_cost_landcon.lo(j,"crop") = 0;
vm_cost_landcon.up(j,"crop") = Inf;

i39_cost_transition(land_from10,land_to10) = 0;
i39_cost_transition(natveg_from39,"crop") = 10000;
i39_cost_transition(natveg_from39,"past") = 10000;
i39_cost_transition(natveg_from39,"forestry") = 1000;
i39_cost_transition(managed_from39,managed_to39) = 2000;
