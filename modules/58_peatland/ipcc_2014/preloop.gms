*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

*p58_peatland_ratio(j,land58)$(pcm_land(j,land58) > 0) = 
*pc58_peatland_man(j,"degrad",land58)/pcm_land(j,land58);

p58_mapping_cell_climate(j,climate58) = sum(clcl_climate58(clcl,climate58),pm_climate_class(j,clcl));

p58_ipcc_wetland_ef(climate58,land58,emis58,ef58) = f58_ipcc_wetland_ef(climate58,land58,emis58,ef58);
p58_ipcc_wetland_ef(climate58,land58,emis58,"unused") = f58_ipcc_wetland_ef(climate58,land58,emis58,"degrad");
p58_ipcc_wetland_ef(climate58,land58,"ch4",status58) = p58_ipcc_wetland_ef(climate58,land58,"ch4",status58)/34*28;
p58_ipcc_wetland_ef(climate58,land58,"n2o",status58) = p58_ipcc_wetland_ef(climate58,land58,"n2o",status58)/298*265;

$ontext
p58_emis_factor("boreal","degrad","crop") = 33.4;
p58_emis_factor("boreal","degrad","past") = 24.3;
p58_emis_factor("boreal","degrad","forestry") = 2.9;
*p58_emis_factor("polar","degrad","crop") = 33.4;
*p58_emis_factor("polar","degrad","past") = 24.3;
*p58_emis_factor("polar","degrad","forestry") = 2.9;
p58_emis_factor("temperate","degrad","crop") = 33.4;
p58_emis_factor("temperate","degrad","past") = 20.7;
p58_emis_factor("temperate","degrad","forestry") = 11;
p58_emis_factor("tropical","degrad","crop") = 52.1;
p58_emis_factor("tropical","degrad","past") = 42.7;
p58_emis_factor("tropical","degrad","forestry") = 60.6;

p58_emis_factor("boreal","rewet","crop") = 33.4-33.4;
p58_emis_factor("boreal","rewet","past") = 24.3-24.3;
p58_emis_factor("boreal","rewet","forestry") = 2.9-2;
p58_emis_factor("boreal","rewet","crop") = 33.4-33.4;
p58_emis_factor("boreal","rewet","past") = 24.3-24.3;
p58_emis_factor("boreal","rewet","forestry") = 2.9-2;
p58_emis_factor("temperate","rewet","crop") = 33.4-28;
p58_emis_factor("temperate","rewet","past") = 20.7-20;
p58_emis_factor("temperate","rewet","forestry") = 11-6;
p58_emis_factor("tropical","rewet","crop") = 52.1;
p58_emis_factor("tropical","rewet","past") = 42.7;
p58_emis_factor("tropical","rewet","forestry") = 60.6;
$offtext

p58_excess_peatland(t,j,land58) = 0;

p58_peatland_cost_past(t,j) = 0;
