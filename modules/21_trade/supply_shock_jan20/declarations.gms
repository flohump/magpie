*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

parameters
 p21_supply_shock(i,kall)		supply shock (percentage)
 p21_shock_scen(s21_shock)		supply shock scenario (percentage)
 i21_prod_reg(t,i,kall)		production (mio. tDM per yr)
 i21_prod(t,j,k)			production (mio. tDM per yr)
 p21_prod_cross(t,i,kall,s21_shock)	production cross (mio. tDM per yr)
 p21_prod_own(t,i,kall,s21_shock)		production own (mio. tDM per yr)
 p21_price_cross(t,i,kall,s21_shock) prices cross (USD05MER per tDM)
 p21_cost_cross(t,i,s21_shock) 	cost cross (mio. USD05MER per yr)
 p21_price_own(t,i,kall,s21_shock) prices own (USD05MER per tDM)
 p21_cost_own(t,i,kall,s21_shock) 	cost own (mio. USD05MER per yr)
;

positive variables
 vm_cost_trade(i)                            Regional  trade costs (mio. USD05MER per yr)
;

equations
 q21_notrade(i,kall)        Regional production constraint of non-tradable commodities (mio. tDM per yr)
;

*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 ov_cost_trade(t,i,type)     Regional  trade costs (mio. USD05MER per yr)
 oq21_notrade(t,i,kall,type) Regional production constraint of non-tradable commodities (mio. tDM per yr)
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################

