*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*save production, prices and costs before shock
p21_prod_cross(t,i,kall,"0") = vm_prod_reg.l(i,kall);
p21_price_cross(t,i,kall,"0") = q21_notrade.m(i,kall);
p21_cost_cross(t,i,"0") = v11_cost_reg.l(i);

p21_prod_own(t,i,kall,"0") = vm_prod_reg.l(i,kall);
p21_price_own(t,i,kall,"0") = q21_notrade.m(i,kall);
p21_cost_own(t,i,kall,"0") = v11_cost_reg.l(i);

*save production patterns from initial run
i21_prod_reg(t,i,kall) = vm_prod_reg.l(i,kall);
*save production patterns from initial run
i21_supply_reg(t,i,kall) = vm_supply.l(i,kall);

vm_supply.fx(i,kall) = vm_supply.l(i,kall)

*simultaneous shock for all regions and products for deriving cross-price elasticity 
display "run model with simultaneous shock and save price response" ;
loop(s21_shock_sub, 
 display "simultaneous shock";
 display s21_shock_sub;
 p21_supply_shock(i,k) = 1+p21_shock_scen(s21_shock_sub);
 solve magpie USING nlp MINIMIZING vm_cost_glo;
*save production, prices and costs after shock
 p21_prod_cross(t,i,kall,s21_shock_sub) = vm_prod_reg.l(i,kall);
 p21_price_cross(t,i,kall,s21_shock_sub) = q21_notrade.m(i,kall);
 p21_cost_cross(t,i,s21_shock_sub) = v11_cost_reg.l(i);
);

*reset prod shock
p21_supply_shock(i,kall) = 1;

display "run model with individual shocks and save price response" ;
*individual shock for all regions and products for deriving own elasticity 
loop ((kall2,s21_shock_sub),
 display "individual shock"; 
 display kall2;
 display s21_shock_sub;
 p21_supply_shock(i,kall2) = 1+p21_shock_scen(s21_shock_sub);
 solve magpie USING nlp MINIMIZING vm_cost_glo;
*save production, prices and costs after shock
 p21_prod_own(t,i,kall2,s21_shock_sub) = vm_prod_reg.l(i,kall2);
 p21_price_own(t,i,kall2,s21_shock_sub) = q21_notrade.m(i,kall2);
 p21_cost_own(t,i,kall2,s21_shock_sub) = v11_cost_reg.l(i);
*reset prod shock
 p21_supply_shock(i,kall2) = 1;
);


