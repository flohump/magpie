*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

sets
 
  man58 Peatland status managed
    / degrad, unused, rewet /
  
  ef58(man58) Peatland ef categories
    / degrad, rewet /

  land58(land) Managed land types
    / crop, past, forestry /

  land_ini58(land58) Managed land types for ini
    / crop, past, forestry /

  stat58 Peatland status
    / intact, 
    degrad_crop, degrad_past, degrad_forestry, 
    unused_crop, unused_past, unused_forestry, 
    rewet_crop, rewet_past, rewet_forestry /

  from58(stat58) Peatland status
    / intact, 
    degrad_crop, degrad_past, degrad_forestry, 
    unused_crop, unused_past, unused_forestry, 
    rewet_crop, rewet_past, rewet_forestry /

  to58(stat58) Peatland status
    / intact, 
    degrad_crop, degrad_past, degrad_forestry, 
    unused_crop, unused_past, unused_forestry, 
    rewet_crop, rewet_past, rewet_forestry /

  stat_rewet58(to58) Peatland status
    / rewet_crop, rewet_past, rewet_forestry /

  climate58 Climate classes
	/ tropical, temperate, boreal /

  emis58 Wetland emission types
	/ co2, doc, ch4, n2o /

  clcl_climate58(clcl,climate58) Climate classification types
           /
           Af .(tropical) "equatorial fully humid"
           Am .(tropical) "equatorial monsoonal"
           As .(tropical) "equatorial summer dry"
           Aw .(tropical) "equatorial winter dry"
           BSh .(tropical) "arid steppe hot arid"
           BSk .(tropical) "arid steppe cold arid"
           BWh .(tropical) "arid desert hot arid"
           BWk .(tropical) "arid desert cold arid"
           Cfa .(temperate) "warm temperate fully humid hot summer"
           Cfb .(temperate) "warm temperate fully humid warm summer"
           Cfc .(temperate) "warm temperate fully humid cool summer"
           Csa .(temperate) "warm temperate summer dry hot summer"
           Csb .(temperate) "warm temperate summer dry warm summer"
           Csc .(temperate) "warm temperate summer dry cool summer"
           Cwa .(temperate) "warm temperate winter dry hot summer"
           Cwb .(temperate) "warm temperate winter dry warm summer"
           Cwc .(temperate) "warm temperate winter dry cool summer"
           Dfa .(boreal) "snow fully humid hot summer"
           Dfb .(boreal) "snow fully humid warm summer"
           Dfc .(boreal) "snow fully humid cool summer"
           Dfd .(boreal) "snow fully humid extremely continental"
           Dsa .(boreal) "snow summer dry hot summer"
           Dsb .(boreal) "snow summer dry warm summer"
           Dsc .(boreal) "snow summer dry cool summer"
           Dsd .(boreal) "snow summer dry extremely continental"
           Dwa .(boreal) "snow winter dry hot summer"
           Dwb .(boreal) "snow winter dry warm summer"
           Dwc .(boreal) "snow winter dry cool summer"
           Dwd .(boreal) "snow winter dry extremely continental"
           EF .(boreal) "polar polar frost"
           ET .(boreal) "polar polar tundra"
           /

;
