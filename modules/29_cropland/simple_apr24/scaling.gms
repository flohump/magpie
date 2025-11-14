*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

* Cropland treecover variables - Range: 0.000 to 0.101 Mio. ha
* Scale factor 1000 brings: 0.001→1.0, 0.003→3.0, 0.1→100 (optimal for solver)
vm_treecover.scale(j) = 100;
v29_treecover.scale(j,ac) = 100;
v29_treecover_missing.scale(j) = 100;

* Fallow land variables - Similar range to treecover
vm_fallow.scale(j) = 100;
v29_fallow_missing.scale(j) = 100;
