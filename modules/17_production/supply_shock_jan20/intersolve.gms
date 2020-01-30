*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*save production, prices and costs before shock
p17_prod(t,i,k,"0") = vm_prod_reg.l(i,k);

p17_price_cross(t,i,k_notrade,"0") = q21_notrade.m(i,k_notrade);
p17_price_cross(t,i,k_trade,"0") = q21_trade_glo.m(k_trade);
p17_cost_cross(t,i,"0") = v11_cost_reg.l(i);

p17_price_own(t,i,k_notrade,"0") = q21_notrade.m(i,k_notrade);
p17_price_own(t,i,k_trade,"0") = q21_trade_glo.m(k_trade);
p17_cost_own(t,i,k,"0") = v11_cost_reg.l(i);


*simultaneous shock for all regions and products for deriving cross-price elasticity 
loop(s17_shock_sub, 
 pm_prod_shock(i,k) = 1+p17_shock_scen(s17_shock_sub);
 solve magpie USING nlp MINIMIZING vm_cost_glo;
*save production, prices and costs after shock
 p17_prod(t,i,k,s17_shock_sub) = vm_prod_reg.l(i,k) * pm_prod_shock(i,k);
 p17_price_cross(t,i,k_notrade,s17_shock_sub) = q21_notrade.m(i,k_notrade);
 p17_price_cross(t,i,k_trade,s17_shock_sub) = q21_trade_glo.m(k_trade);
 p17_cost_cross(t,i,s17_shock_sub) = v11_cost_reg.l(i);
);

*reset prod shock
pm_prod_shock(i,k) = 1;

*individual shock for all regions and products for deriving own elasticity 
loop ((i,k2,s17_shock_sub),
 pm_prod_shock(i,k2) = 1+p17_shock_scen(s17_shock_sub);
 solve magpie USING nlp MINIMIZING vm_cost_glo;
*save prices and costs after shock, production is the same as for the simultaneous shock
 p17_price_own(t,i,k2,s17_shock_sub) = sum(k_notrade$sameas(k_notrade,k2), q21_notrade.m(i,k_notrade)) + sum(k_trade$sameas(k_trade,k2), q21_trade_glo.m(k_trade));
 p17_cost_own(t,i,k2,s17_shock_sub) = v11_cost_reg.l(i);
*reset prod shock
 pm_prod_shock(i,k2) = 1; 
);


