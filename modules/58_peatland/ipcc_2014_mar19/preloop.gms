*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

p58_mapping_cell_climate(j,climate58) = sum(clcl_climate58(clcl,climate58),pm_climate_class(j,clcl));

p58_ipcc_wetland_ef(climate58,land58,emis58,ef58) = f58_ipcc_wetland_ef(climate58,land58,emis58,ef58);
p58_ipcc_wetland_ef(climate58,land58,emis58,"unused") = f58_ipcc_wetland_ef(climate58,land58,emis58,"degrad");
p58_ipcc_wetland_ef(climate58,land58,"ch4",man58) = p58_ipcc_wetland_ef(climate58,land58,"ch4",man58)/34*28;
p58_ipcc_wetland_ef(climate58,land58,"n2o",man58) = p58_ipcc_wetland_ef(climate58,land58,"n2o",man58)/298*265;

p58_peatland_cost_past(t,j) = 0;
