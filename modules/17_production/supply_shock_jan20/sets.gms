*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

sets
   s17_shock production shock scenario
       / 0, 5, 10, 20 /
       
   s17_shock_sub(s17_shock) production shock scenario sub
       / 5, 10, 20 /

   s17_scen  ssp scenario
       / SSP1, SSP2, SSP3, SSP4, SSP5 /       
;

alias(k,k2);
