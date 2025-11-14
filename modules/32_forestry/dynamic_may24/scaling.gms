*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

v32_cost_establishment.scale(i) = 10e4;
v32_cost_recur.scale(i) = 10e4;
vm_cost_fore.scale(i) = 10e5;
v32_cost_hvarea.scale(i)$(s32_hvarea = 1 OR s32_hvarea = 2) = 10e4;

* Main forestry land pools by type and age class
v32_land.scale(j,type32,ac) = 100;

* Forestry land dynamics
v32_land_expansion.scale(j,type32) = 100;
v32_land_reduction.scale(j,type32,ac) = 100;
v32_land_missing.scale(j) = 100;
v32_land_replant.scale(j) = 100;

* Harvested area from forestry - smaller values need higher scaling
v32_hvarea_forestry.scale(j,ac) = 1000;

* Forestry land difference and interface variables
vm_landdiff_forestry.scale = 100;
vm_landexpansion_forestry.scale(j,type32) = 100;
vm_landreduction_forestry.scale(j,type32) = 100;
vm_land_forestry.scale(j,type32) = 100;
