*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

positive variables
 vm_peatland_emis(j) 							GHG emissions from managed peatland (t CO2eq per year)
 vm_peatland_ghgsaving(j) 						Peatland policy GHG emission saving (t CO2eq per year)
 vm_peatland_cost(j)							One-time and recurring cost of managed peatland (mio. USD05MER per yr)
;


*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 ov_peatland_emis(t,j,type)      GHG emissions from managed peatland (t CO2eq per year)
 ov_peatland_ghgsaving(t,j,type) Peatland policy GHG emission saving (t CO2eq per year)
 ov_peatland_cost(t,j,type)      One-time and recurring cost of managed peatland (mio. USD05MER per yr)
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################

