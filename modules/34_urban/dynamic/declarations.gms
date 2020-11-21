*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

equations
 q34_urban(j)       		              urban land (mio. ha)
;

parameters
 p34_pop_growth(t,i) population growth factor between time steps (1)
;

*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 oq34_urban(t,j,type) urban land (mio. ha)
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################
