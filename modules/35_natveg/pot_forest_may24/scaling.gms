*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

vm_cost_hvarea_natveg.scale(i)$(s35_hvarea = 1 OR s35_hvarea = 2) = 10e4;

* Secondary forest dynamics
v35_secdforest.scale(j,ac) = 100;
v35_secdforest_expansion.scale(j) = 100;
v35_secdforest_reduction.scale(j,ac) = 100;
v35_primforest_reduction.scale(j) = 100;

* Other land dynamics
vm_land_other.scale(j,othertype35,ac) = 100;
v35_other_expansion.scale(j,othertype35) = 100;
v35_other_reduction.scale(j,othertype35,ac) = 100;

* Harvested area from natural vegetation - smaller values
v35_hvarea_secdforest.scale(j,ac) = 100;
v35_hvarea_other.scale(j,othertype35,ac) = 100;
v35_hvarea_primforest.scale(j) = 100;

* Natural vegetation land difference
vm_landdiff_natveg.scale = 100;
vm_natforest_reduction.scale(j) = 100;
