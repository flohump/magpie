*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' Growing stock calibration of secdforest and plantation growth curves.
*' For each region, find k (growth rate in Chapman-Richards equation) such that
*' the area-weighted growing stock matches FRA targets.
*'   - Secdforest: uses GFAD age distribution (im_forest_ageclass from module 28)
*'   - Plantations: assumes uniform age distribution across all age classes
*'
*' This runs in preloop (after module 28 preloop has populated im_forest_ageclass).
*'
*' Conversion chain: C_density (tC/ha) -> GS (m3/ha):
*'   GS = C_density / carbon_fraction * aboveground_fraction / BEF / D
*' where D = basic wood density (tDM/m3), BEF = biomass expansion factor

if(s52_growingstock_calib = 1,

* Compute regional averages for conversion factors
  p52_carbon_fraction = 0.5;
  p52_aboveground_fraction = 0.80;
  p52_aboveground_fraction_plant = 0.85;
  pm_vol_conv(i) = sum((cell(i,j), clcl), pm_climate_class(j,clcl) * f52_volumetric_conversion(clcl)) / sum(cell(i,j), 1);
  p52_bef_avg(i) = sum((cell(i,j), clcl), pm_climate_class(j,clcl) * pm_bef(clcl)) / sum(cell(i,j), 1);

* Compute region-average m - kept fixed during calibration
  p52_m_avg_natveg(i) = sum((cell(i,j), clcl), pm_climate_class(j,clcl) * f52_growth_par(clcl,"m","natveg")) / sum(cell(i,j), 1);
  p52_m_avg_plant(i) = sum((cell(i,j), clcl), pm_climate_class(j,clcl) * f52_growth_par(clcl,"m","plantations")) / sum(cell(i,j), 1);

* ==========================================
* Secdforest k calibration (bisection)
*
* The FRA NRF target is for all naturally regenerating forest (primary + secondary).
* In MAgPIE, primforest is at static C_max (no growth curve), while secdforest
* uses a Chapman-Richards curve with calibrated k. To correctly decompose the
* FRA target, we:
*   1. Subtract primforest from GFAD acx (same logic as module 35 preloop)
*   2. Compute primforest GS from C_max using the model's conversion chain
*   3. Derive the secdforest-only GS target from the combined FRA NRF target
*   4. Calibrate k to match the secdforest target
* ==========================================

* Subtract primforest from GFAD acx (mirrors module 35 logic)
  p52_secdf_ageclass(j,ac) = im_forest_ageclass(j,ac);
  p52_secdf_ageclass(j,"acx") = im_forest_ageclass(j,"acx") - pcm_land(j,"primforest");
  p52_secdf_ageclass(j,"acx")$(p52_secdf_ageclass(j,"acx") < 0) = 0;

* Compute primforest GS (m3/ha) from C_max using model's conversion chain
  p52_prim_area(i) = sum(cell(i,j), pcm_land(j,"primforest"));
  p52_gs_prim(i)$(p52_prim_area(i) > 0) =
    sum(cell(i,j),
      pcm_land(j,"primforest")
      * fm_carbon_density("y2000",j,"primforest","vegc")
    )
    / p52_prim_area(i)
    / p52_carbon_fraction
    * p52_aboveground_fraction
    / p52_bef_avg(i)
    / pm_vol_conv(i)
  ;

* Compute secdforest area from GFAD (with primforest subtracted)
  p52_secdf_area(i) = sum((cell(i,j), ac), p52_secdf_ageclass(j,ac));

* Derive secdforest-only GS target from FRA NRF
* FRA_NRF = (prim_area * GS_prim + secdf_area * GS_secdf) / (prim_area + secdf_area)
* => GS_secdf = (FRA_NRF * (prim_area + secdf_area) - prim_area * GS_prim) / secdf_area
  p52_fra_secdf_target(i)$(p52_secdf_area(i) > 0) =
    (f52_fra_nrf_gs(i) * (p52_prim_area(i) + p52_secdf_area(i))
     - p52_prim_area(i) * p52_gs_prim(i))
    / p52_secdf_area(i)
  ;
* Ensure non-negative target (if primforest GS exceeds FRA NRF, secdforest target = 0)
  p52_fra_secdf_target(i)$(p52_fra_secdf_target(i) < 0) = 0;

* Initialize bisection bounds
  p52_k_low(i) = 0.001;
  p52_k_high(i) = 0.3;

  loop(iter52,
    p52_k_calib_secdf(i) = (p52_k_low(i) + p52_k_high(i)) / 2;

*   Area-weighted growing stock (m3/ha) for secdforest only with trial k
    p52_gs_current(i)$(p52_secdf_area(i) > 0) =
      sum((cell(i,j), ac),
        p52_secdf_ageclass(j,ac)
        * fm_carbon_density("y2000",j,"secdforest","vegc")
        * (1 - exp(-p52_k_calib_secdf(i) * (ord(ac)-1) * 5))**p52_m_avg_natveg(i)
      )
      / p52_secdf_area(i)
      / p52_carbon_fraction
      * p52_aboveground_fraction
      / p52_bef_avg(i)
      / pm_vol_conv(i)
    ;

    p52_k_low(i)$(p52_gs_current(i) < p52_fra_secdf_target(i)) = p52_k_calib_secdf(i);
    p52_k_high(i)$(p52_gs_current(i) >= p52_fra_secdf_target(i)) = p52_k_calib_secdf(i);
  );

* Recompute secdforest carbon density with calibrated k
  pm_carbon_density_secdforest_ac(t_all,j,ac,"vegc") =
    fm_carbon_density(t_all,j,"secdforest","vegc")
    * (1 - exp(-sum(cell(i,j), p52_k_calib_secdf(i)) * (ord(ac)-1) * 5))**sum(cell(i,j), p52_m_avg_natveg(i));

* ==========================================
* Plantation k calibration (bisection)
* Uses actual plantation age distribution from module 32 (pc32_land)
* ==========================================

* Initialize bisection bounds
  p52_k_low(i) = 0.001;
  p52_k_high(i) = 0.3;

  loop(iter52,
    p52_k_calib_plant(i) = (p52_k_low(i) + p52_k_high(i)) / 2;

*   Area-weighted growing stock (m3/ha) at y2000 with trial k
    p52_gs_current_plant(i)$(sum((cell(i,j),ac), pm_land_plantation(j,ac)) > 0) =
      sum((cell(i,j), ac),
        pm_land_plantation(j,ac)
        * fm_carbon_density("y2000",j,"secdforest","vegc")
        * (1 - exp(-p52_k_calib_plant(i) * (ord(ac)-1) * 5))**p52_m_avg_plant(i)
      )
      / sum((cell(i,j), ac), pm_land_plantation(j,ac))
      / p52_carbon_fraction
      * p52_aboveground_fraction_plant
      / p52_bef_avg(i)
      / pm_vol_conv(i)
    ;

    p52_k_low(i)$(p52_gs_current_plant(i) < f52_fra_pla_gs(i)) = p52_k_calib_plant(i);
    p52_k_high(i)$(p52_gs_current_plant(i) >= f52_fra_pla_gs(i)) = p52_k_calib_plant(i);
  );

* Recompute plantation carbon density with calibrated k
  pm_carbon_density_plantation_ac(t_all,j,ac,"vegc") =
    fm_carbon_density(t_all,j,"secdforest","vegc")
    * (1 - exp(-sum(cell(i,j), p52_k_calib_plant(i)) * (ord(ac)-1) * 5))**sum(cell(i,j), p52_m_avg_plant(i));

);
