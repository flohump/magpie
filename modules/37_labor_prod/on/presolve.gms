*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

if(m_year(t) <= sm_fix_SSP2,
 s37_adapt_irr2 = 0;
 s37_adapt_fore2 = 0;
 s37_adapt_harv2 = 0;
else
 s37_adapt_irr2 = s37_adapt_irr;
 s37_adapt_fore2 = s37_adapt_fore;
 s37_adapt_harv2 = s37_adapt_harv;
);

vm_labor_prod.l(j) = f37_labor_prod_cc(t,j);
