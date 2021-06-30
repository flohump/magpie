*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

i37_labor_prod_cc(t,j) = f37_labor_prod_cc(t,j,"CTL_ISO_400_ensmean");

i37_labor_prod_cc(t,j)$(i37_labor_prod_cc(t,j) = 0) = 1;

i37_labor_prod_cc(t,j) = i37_labor_prod_cc(t,j)*0.5;

$ifthen "%c37_labour_switch%" == "nocc"
loop(t,
 if(m_year(t) >= sm_fix_SSP2,
i37_labor_prod_cc(t,j) = i37_labor_prod_cc("y2020",j);
 );
);
$endif

vm_labor_prod.lo(j) = 0.0001;
vm_labor_prod.l(j) = i37_labor_prod_cc("y1995",j);
vm_labor_prod.up(j) = 1;
v37_adapt_irr.lo(j) = -1;
v37_adapt_irr.up(j) = 1;
v37_adapt_fore.lo(j) = -1;
v37_adapt_fore.up(j) = 1;
v37_adapt_harv.lo(j) = -1;
v37_adapt_harv.up(j) = 1;

*display f37_labor_prod_cc;
