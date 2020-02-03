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
*save supply patterns from initial run
i21_prod(t,j,k) = vm_prod.l(j,k);

option savepoint  = 0;

*simultaneous shock for all regions and products for deriving cross-price elasticity 
display "run model with simultaneous shock and save price response" ;
loop(s21_shock_cross, 
 display "simultaneous shock";
 display s21_shock_cross;
 p21_supply_shock(i,kall) = 1+p21_shock_scen(s21_shock_cross);
*reset all variables and constraint 
display "reset variables and constraints";
display vm_cost_glo.l;
execute_loadpoint 'magpie_p';
display vm_cost_glo.l;
vm_tau.fx(i) = vm_tau.l(i);
*set lower bound of cellular production to level of production from initial run 
* vm_prod_reg.lo(i,kall) = vm_prod_reg.l(i,kall)* p21_supply_shock(i,kall);
 solve magpie USING nlp MINIMIZING vm_cost_glo;
*save production, prices and costs after shock
 p21_prod_cross(t,i,kall,s21_shock_cross) = vm_prod_reg.l(i,kall);
 p21_price_cross(t,i,kall,s21_shock_cross) = q21_notrade.m(i,kall);
 p21_cost_cross(t,i,s21_shock_cross) = v11_cost_reg.l(i);
);

*reset prod shock
p21_supply_shock(i,kall) = 1;

display "run model with individual shocks and save price response" ;
*individual shock for all regions and products for deriving own elasticity 
loop ((kall2,s21_shock_own),
 display "individual shock"; 
 display kall2;
 display s21_shock_own;
 p21_supply_shock(i,kall2) = 1+p21_shock_scen(s21_shock_own);
*reset all variables and constraint 
display "reset variables and constraints";
display vm_cost_glo.l;
execute_loadpoint 'magpie_p';
display vm_cost_glo.l;
vm_tau.fx(i) = vm_tau.l(i);
 solve magpie USING nlp MINIMIZING vm_cost_glo;
*save production, prices and costs after shock
 p21_prod_own(t,i,kall2,s21_shock_own) = vm_prod_reg.l(i,kall2);
 p21_price_own(t,i,kall2,s21_shock_own) = q21_notrade.m(i,kall2);
 p21_cost_own(t,i,kall2,s21_shock_own) = v11_cost_reg.l(i);
*reset prod shock
 p21_supply_shock(i,kall2) = 1;
);

*reset all variables and constraint 
display "reset variables and constraints";
display vm_cost_glo.l;
display vm_tau.l
display vm_tau.lo;
display vm_tau.up;
$include "./core/load_gdx.gms"
display vm_cost_glo.l;
display vm_tau.l;
display vm_tau.lo;
display vm_tau.up;

option savepoint  = 1;
