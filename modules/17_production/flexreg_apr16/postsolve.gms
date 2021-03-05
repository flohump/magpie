*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de



*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 ov_prod(t,j,k,"marginal")              = vm_prod.m(j,k);
 ov_prod_reg(t,i,kall,"marginal")       = vm_prod_reg.m(i,kall);
 ov_prod_missing(t,i,k,"marginal")      = vm_prod_missing.m(i,k);
 ov_prod_cost_missing(t,i,"marginal")   = vm_prod_cost_missing.m(i);
 oq17_prod_cost_missing(t,i,"marginal") = q17_prod_cost_missing.m(i);
 oq17_prod_reg(t,i,k,"marginal")        = q17_prod_reg.m(i,k);
 ov_prod(t,j,k,"level")                 = vm_prod.l(j,k);
 ov_prod_reg(t,i,kall,"level")          = vm_prod_reg.l(i,kall);
 ov_prod_missing(t,i,k,"level")         = vm_prod_missing.l(i,k);
 ov_prod_cost_missing(t,i,"level")      = vm_prod_cost_missing.l(i);
 oq17_prod_cost_missing(t,i,"level")    = q17_prod_cost_missing.l(i);
 oq17_prod_reg(t,i,k,"level")           = q17_prod_reg.l(i,k);
 ov_prod(t,j,k,"upper")                 = vm_prod.up(j,k);
 ov_prod_reg(t,i,kall,"upper")          = vm_prod_reg.up(i,kall);
 ov_prod_missing(t,i,k,"upper")         = vm_prod_missing.up(i,k);
 ov_prod_cost_missing(t,i,"upper")      = vm_prod_cost_missing.up(i);
 oq17_prod_cost_missing(t,i,"upper")    = q17_prod_cost_missing.up(i);
 oq17_prod_reg(t,i,k,"upper")           = q17_prod_reg.up(i,k);
 ov_prod(t,j,k,"lower")                 = vm_prod.lo(j,k);
 ov_prod_reg(t,i,kall,"lower")          = vm_prod_reg.lo(i,kall);
 ov_prod_missing(t,i,k,"lower")         = vm_prod_missing.lo(i,k);
 ov_prod_cost_missing(t,i,"lower")      = vm_prod_cost_missing.lo(i);
 oq17_prod_cost_missing(t,i,"lower")    = q17_prod_cost_missing.lo(i);
 oq17_prod_reg(t,i,k,"lower")           = q17_prod_reg.lo(i,k);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################

