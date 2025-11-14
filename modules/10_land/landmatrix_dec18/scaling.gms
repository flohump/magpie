*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

* Core land use variable - Range: 0.001 to 28 Mio. ha
* Scale factor 100 brings: 0.001→0.1, 0.003→0.3, 28→2,800 (well-conditioned)
*vm_land.scale(j,land) = 100;
* should be aligned with scaling of vm_land
*vm_landdiff.scale = 100;

* Range: 0.001 to ~10 Mio. ha
*vm_landexpansion.scale(j,land) = 100;
*vm_landreduction.scale(j,land) = 100;

* Land use transitions matrix
*vm_lu_transitions.scale(j,land_from,land_to) = 100;

* Land conversion costs - must match land scaling for consistency
*vm_cost_landcon.scale(j,land) = 100;
