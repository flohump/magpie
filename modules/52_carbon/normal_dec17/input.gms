*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

$setglobal c52_carbon_scenario  cc
*   options:  cc        (climate change)
*             nocc      (no climate change)
*             nocc_hist (no climate change after year defined by sm_fix_cc)

$setglobal c52_land_carbon_sink_rcp  RCPBU
*   options:  RCP19, RCP26, RCP34, RCP45, RCP60, RCPBU

table fm_carbon_density(t_all,j,land,c_pools) LPJmL carbon density for land and carbon pools (tC per ha)
$ondelim
$include "./modules/52_carbon/input/lpj_carbon_stocks.cs3"
$offdelim
;

$if "%c52_carbon_scenario%" == "nocc" fm_carbon_density(t_all,j,land,c_pools) = fm_carbon_density("y1995",j,land,c_pools);
$if "%c52_carbon_scenario%" == "nocc_hist" fm_carbon_density(t_all,j,land,c_pools)$(m_year(t_all) > sm_fix_cc) = fm_carbon_density(t_all,j,land,c_pools)$(m_year(t_all) = sm_fix_cc);
m_fillmissingyears(fm_carbon_density,"j,land,c_pools");

* Where no forest carbon density is reported, because the potential
* forest area is zero, use the carbon density of other land instead.
* This affects areas, where the land use intialisation reports some
* forest, although the forest potential is zero. Forest expansion in
* these cells is constrained by f35_pot_forest_area.
fm_carbon_density(t_all,j,land_forest,c_pools)$(fm_carbon_density(t_all,j,land_forest,c_pools) = 0) = fm_carbon_density(t_all,j,"other",c_pools);

* Fix urban area soilc to natural land soilc as long as preprocessed
* fm_carbon_density does not provide meaningful numbers for urban.
fm_carbon_density(t_all,j,"urban","soilc") = fm_carbon_density(t_all,j,"other","soilc")

*' The forest growth-curve (Chapman-Richards k,m) parameters are read per forest type. With
*' c52_growth_par_source = refit (default) they come from f52_growth_par_3curve.csv: naturally
*' regenerating forest ("natveg", Robinson et al 2025), other planted forest ("other_planted", an
*' intermediate curve between naturally regenerating forest and plantations) and plantations
*' ("plantations", Bukoski et al 2022, m=0.67; no establishment lag, uses the external rotation
*' f32_plant_rotation). With c52_growth_par_source = braakhekke the legacy curves (Braakhekke et al
*' 2019) are used instead; they have no other_planted curve, so other_planted falls back to natveg.

$setglobal c52_growth_par_source  refit
* options: refit (default), braakhekke

parameter f52_growth_par(clcl,chap_par,forest_type) Parameters for chapman-richards equation (1)
/
$ondelim
$ifthen "%c52_growth_par_source%" == "braakhekke"
$include "./modules/52_carbon/input/f52_growth_par.csv"
$else
$include "./modules/52_carbon/input/f52_growth_par_3curve.csv"
$endif
$offdelim
/
;

* legacy Braakhekke curves carry no other_planted type -> fall back to naturally regenerating forest
$ifthen "%c52_growth_par_source%" == "braakhekke"
f52_growth_par(clcl,chap_par,"other_planted") = f52_growth_par(clcl,chap_par,"natveg");
$endif

scalars
  s52_growingstock_calib Switch for growing stock wood-multiplier (lambda) calibration to FRA - secdforest and plantations 1=on 0=off (1) / 1 /
  s52_gs_niche_floor     Niche floor on mature secdforest veg carbon for the WOOD conversion only - lifts arid divide-by-near-zero cells 0=off (tC per ha) / 15 /
  s52_plant_asymp_anchor Anchor plantation carbon asymptote to observed managed plateau - 0=off (LPJmL natural) 1=tropical-only 2=all Bukoski biomes (1) / 1 /
;

* Tropical Koeppen classes used by the tropical-only plantation asymptote anchor (s52_plant_asymp_anchor=1)
set clcl_trop52(clcl) Tropical Koeppen classes for the plantation asymptote anchor / Af, Am, As, Aw /;

* Observed managed-plantation aboveground-carbon asymptote target by climate class, used to anchor the
* plantation carbon curve to the observed managed plateau (see the cs4 header for source and values).
parameter f52_plant_asymp_agc(clcl) Managed-plantation aboveground-C asymptote target - Bukoski 2022 (tC per ha)
/
$ondelim
$include "./modules/52_carbon/input/f52_plant_asymp_agc.cs4"
$offdelim
/
;

parameter f52_fra_nrf_gs(i) FRA growing stock target for naturally regenerating forests (m3 per ha)
/
$ondelim
$include "./modules/52_carbon/input/f52_fra_nrf_gs.cs4"
$offdelim
/
;

parameter f52_fra_pla_gs(i) FRA growing stock target for plantations (m3 per ha)
/
$ondelim
$include "./modules/52_carbon/input/f52_fra_pla_gs.cs4"
$offdelim
/
;

parameter f52_volumetric_conversion(clcl) Basic wood density by climate class (tDM per m3)
/
$ondelim
$include "./modules/52_carbon/input/f52_volumetric_conversion.csv"
$offdelim
/
;

* Note: Land carbon sink adjustment factors from Grassie et al 2021 (DOI 10.1038/s41558-021-01033-6)
* are needed in the post-processing in https://github.com/pik-piam/magpie4/blob/master/R/reportEmissions.R
* To facilitate the choice of the corresponding RCP, the adjustment factors are read-in here and
* stored in i52_land_carbon_sink for use in the R post-processing.
* Land carbon sink adjustment factors are NOT used within MAgPIE.
$onEmpty
table f52_land_carbon_sink(t_all,i,rcp52) Land carbon sink adjustment factors from Grassi et al 2021 (GtCO2 per year)
$ondelim
$if exist "./modules/52_carbon/input/f52_land_carbon_sink_adjust_grassi.cs3" $include "./modules/52_carbon/input/f52_land_carbon_sink_adjust_grassi.cs3"
$offdelim
;
$offEmpty

$ifthen "%c52_land_carbon_sink_rcp%" == "nocc"
  i52_land_carbon_sink(t_all,i) = f52_land_carbon_sink("y1995",i,"RCPBU");
$elseif "%c52_land_carbon_sink_rcp%" == "nocc_hist"
  i52_land_carbon_sink(t_all,i) = f52_land_carbon_sink(t_all,i,"RCPBU");
  i52_land_carbon_sink(t_all,i)$(m_year(t_all) > sm_fix_cc) = f52_land_carbon_sink(t_all,i,"RCPBU")$(m_year(t_all) = sm_fix_cc);
$else
  i52_land_carbon_sink(t_all,i) = f52_land_carbon_sink(t_all,i,"%c52_land_carbon_sink_rcp%");
  i52_land_carbon_sink(t_all,i)$(m_year(t_all) <= sm_fix_cc) = f52_land_carbon_sink(t_all,i,"RCPBU")$(m_year(t_all) <= sm_fix_cc);
$endif
