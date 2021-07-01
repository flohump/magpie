*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 ov_cost_prod(t,i,kall,"marginal")       = vm_cost_prod.m(i,kall);
 ov_cost_inv(t,i,"marginal")             = vm_cost_inv.m(i);
 ov38_capital(t,j,kcr,w,"marginal")      = v38_capital.m(j,kcr,w);
 ov38_labour(t,j,kcr,w,"marginal")       = v38_labour.m(j,kcr,w);
 ov38_fac_req(t,j,kcr,w,"marginal")      = v38_fac_req.m(j,kcr,w);
 ov38_scale(t,j,kcr,w,"marginal")        = v38_scale.m(j,kcr,w);
 oq38_cost_prod_crop(t,i,kcr,"marginal") = q38_cost_prod_crop.m(i,kcr);
 oq38_costfun(t,j,kcr,w,"marginal")      = q38_costfun.m(j,kcr,w);
 oq38_ces_prodfun(t,j,kcr,w,"marginal")  = q38_ces_prodfun.m(j,kcr,w);
 oq38_scale(t,j,kcr,w,"marginal")        = q38_scale.m(j,kcr,w);
 ov_cost_prod(t,i,kall,"level")          = vm_cost_prod.l(i,kall);
 ov_cost_inv(t,i,"level")                = vm_cost_inv.l(i);
 ov38_capital(t,j,kcr,w,"level")         = v38_capital.l(j,kcr,w);
 ov38_labour(t,j,kcr,w,"level")          = v38_labour.l(j,kcr,w);
 ov38_fac_req(t,j,kcr,w,"level")         = v38_fac_req.l(j,kcr,w);
 ov38_scale(t,j,kcr,w,"level")           = v38_scale.l(j,kcr,w);
 oq38_cost_prod_crop(t,i,kcr,"level")    = q38_cost_prod_crop.l(i,kcr);
 oq38_costfun(t,j,kcr,w,"level")         = q38_costfun.l(j,kcr,w);
 oq38_ces_prodfun(t,j,kcr,w,"level")     = q38_ces_prodfun.l(j,kcr,w);
 oq38_scale(t,j,kcr,w,"level")           = q38_scale.l(j,kcr,w);
 ov_cost_prod(t,i,kall,"upper")          = vm_cost_prod.up(i,kall);
 ov_cost_inv(t,i,"upper")                = vm_cost_inv.up(i);
 ov38_capital(t,j,kcr,w,"upper")         = v38_capital.up(j,kcr,w);
 ov38_labour(t,j,kcr,w,"upper")          = v38_labour.up(j,kcr,w);
 ov38_fac_req(t,j,kcr,w,"upper")         = v38_fac_req.up(j,kcr,w);
 ov38_scale(t,j,kcr,w,"upper")           = v38_scale.up(j,kcr,w);
 oq38_cost_prod_crop(t,i,kcr,"upper")    = q38_cost_prod_crop.up(i,kcr);
 oq38_costfun(t,j,kcr,w,"upper")         = q38_costfun.up(j,kcr,w);
 oq38_ces_prodfun(t,j,kcr,w,"upper")     = q38_ces_prodfun.up(j,kcr,w);
 oq38_scale(t,j,kcr,w,"upper")           = q38_scale.up(j,kcr,w);
 ov_cost_prod(t,i,kall,"lower")          = vm_cost_prod.lo(i,kall);
 ov_cost_inv(t,i,"lower")                = vm_cost_inv.lo(i);
 ov38_capital(t,j,kcr,w,"lower")         = v38_capital.lo(j,kcr,w);
 ov38_labour(t,j,kcr,w,"lower")          = v38_labour.lo(j,kcr,w);
 ov38_fac_req(t,j,kcr,w,"lower")         = v38_fac_req.lo(j,kcr,w);
 ov38_scale(t,j,kcr,w,"lower")           = v38_scale.lo(j,kcr,w);
 oq38_cost_prod_crop(t,i,kcr,"lower")    = q38_cost_prod_crop.lo(i,kcr);
 oq38_costfun(t,j,kcr,w,"lower")         = q38_costfun.lo(j,kcr,w);
 oq38_ces_prodfun(t,j,kcr,w,"lower")     = q38_ces_prodfun.lo(j,kcr,w);
 oq38_scale(t,j,kcr,w,"lower")           = q38_scale.lo(j,kcr,w);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################
