*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

parameters
 i37_labor_prod_cc(t,j) blub
;

equations
 q37_labor_prod(j)			blub
 q37_adapt_irr(j)			blub
 q37_adapt_fore(j)			blub
 q37_adapt_harv(j)			blub
;

positive variables
 vm_labor_prod(j)             	Labor prod (index)
;

scalars
s37_adapt_irr2 blub
s37_adapt_fore2 blub
s37_adapt_harv2 blub
;

variables
 v37_adapt_irr(j)				blub
 v37_adapt_fore(j)				blub
 v37_adapt_harv(j)				blub
;

*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 ov_labor_prod(t,j,type)   Labor prod (index)
 ov37_adapt_irr(t,j,type)  blub
 ov37_adapt_fore(t,j,type) blub
 ov37_adapt_harv(t,j,type) blub
 oq37_labor_prod(t,j,type) blub
 oq37_adapt_irr(t,j,type)  blub
 oq37_adapt_fore(t,j,type) blub
 oq37_adapt_harv(t,j,type) blub
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################
