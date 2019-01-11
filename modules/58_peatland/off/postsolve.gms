*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 ov_peatland_emis(t,j,"marginal")      = vm_peatland_emis.m(j);
 ov_peatland_ghgsaving(t,j,"marginal") = vm_peatland_ghgsaving.m(j);
 ov_peatland_cost(t,j,"marginal")      = vm_peatland_cost.m(j);
 ov_peatland_emis(t,j,"level")         = vm_peatland_emis.l(j);
 ov_peatland_ghgsaving(t,j,"level")    = vm_peatland_ghgsaving.l(j);
 ov_peatland_cost(t,j,"level")         = vm_peatland_cost.l(j);
 ov_peatland_emis(t,j,"upper")         = vm_peatland_emis.up(j);
 ov_peatland_ghgsaving(t,j,"upper")    = vm_peatland_ghgsaving.up(j);
 ov_peatland_cost(t,j,"upper")         = vm_peatland_cost.up(j);
 ov_peatland_emis(t,j,"lower")         = vm_peatland_emis.lo(j);
 ov_peatland_ghgsaving(t,j,"lower")    = vm_peatland_ghgsaving.lo(j);
 ov_peatland_cost(t,j,"lower")         = vm_peatland_cost.lo(j);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################

