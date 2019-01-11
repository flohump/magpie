*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

scalars
  s58_rewetting_switch Peatland rewetting on (1) or off (0) (binary) / 0 /
  s58_rewet_cost_onetime One-time costs for peatland rewetting (USD05MER per ha) / 850 /
  s58_rewet_cost_recur Recurring costs for peatland rewetting (USD05MER per ha) / 200 /
  s58_peatland_policy_horizon planing horizon for peatland protection and restoration (years) / 30 /
  s58_before_2015 helper to inform the model when peatland area should be initialized (binary) / 1 /
;

parameters
f58_peatland_degrad(j) Degrading peatland area (mio. ha)
/
$ondelim
$include "./modules/58_peatland/input/f58_peatland_degrad.cs2"
$offdelim
/
;

parameters
f58_peatland_intact(j) Intact peatland area (mio. ha)
/
$ondelim
$include "./modules/58_peatland/input/f58_peatland_intact.cs2"
$offdelim
/
;

table f58_ipcc_wetland_ef(climate58,land58,emis58,ef58) Wetland GWP100 emission factors (t CO2eq per ha)
$ondelim
$include "./modules/58_peatland/input/f58_ipcc_wetland_ef.cs3"
$offdelim
;
