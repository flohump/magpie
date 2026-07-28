*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' Growing-stock calibration of secdforest and plantation WOOD only (carbon is never bent).
*' For each region compute an analytic wood multiplier lambda = FRA growing-stock target /
*' area-weighted growing stock of the realistic curve, applied to im_growing_stock in module 14:
*'   - Secdforest (pm_lambda_nrf): weighted by the GFAD/GAMI age distribution (im_forest_ageclass, module 28)
*'   - Plantations (pm_lambda_pla): sampled at the cellular rotation age (pm_rotation_cellular_estb, module 32)
*'
*' This runs in preloop (after module 28 preloop has populated im_forest_ageclass).
*'
*' Conversion chain: C_density (tC/ha) -> GS (m3/ha):
*'   GS = C_density / carbon_fraction * aboveground_fraction / BEF / D
*' where D = basic wood density (tDM/m3), BEF = biomass expansion factor

* Compute regional wood density (always needed, also used in M73 for demand conversion and cost regionalization)
im_vol_conv(i) = sum((cell(i,j), clcl), pm_climate_class(j,clcl) * f52_volumetric_conversion(clcl)) / sum(cell(i,j), 1);

* Default: identity wood multiplier (no wood recalibration when growing-stock calib is off)
pm_lambda_nrf(i) = 1;
pm_lambda_pla(i) = 1;
pm_gs_niche_fac(j) = 1;

if(s52_growingstock_calib = 1,

* Compute regional averages for conversion factors
  i52_bef_avg(i) = sum((cell(i,j), clcl), pm_climate_class(j,clcl) * fm_ipcc_bef(clcl)) / sum(cell(i,j), 1);

* Wood-only niche floor (s52_gs_niche_floor, tC/ha): per-cell factor lifting arid low-asymptote cells' WOOD
* curve so mature stock >= the floor, applied identically to the lambda denominators (below) and the harvest
* base (module 14). Shape-preserving (scales the whole curve by one factor -> no young-class inflation), fires
* only where the LPJmL potential asymptote is implausibly low; carbon density is NEVER touched. 0 disables.
  pm_gs_niche_fac(j)$(s52_gs_niche_floor > 0 and fm_carbon_density("y2025",j,"secdforest","vegc") > 1e-6) =
    max(1, s52_gs_niche_floor / fm_carbon_density("y2025",j,"secdforest","vegc"));

* ==========================================
* Natural forest (NRF) wood multiplier (lambda)
* Per-region multiplier applied to WOOD ONLY (in module 14) so that the reported growing
* stock matches the FRA target. Carbon density (pm_carbon_density_secdforest_ac) is NEVER
* changed here. The reference growing stock (m3/ha) is the area-weighted mean over the
* forest age distribution (im_forest_ageclass) of the carbon curve converted to volume.
* ==========================================
  i52_gs_realistic_nrf(i)$(sum((cell(i,j),ac), im_forest_ageclass(j,ac)) > 0) =
    sum((cell(i,j), ac),
      im_forest_ageclass(j,ac)
      * pm_carbon_density_secdforest_ac("y2025",j,ac,"vegc")
      * pm_gs_niche_fac(j)
    )
    / sum((cell(i,j), ac), im_forest_ageclass(j,ac))
    / sm_carbon_fraction
    * fm_aboveground_fraction("secdforest")
    / i52_bef_avg(i)
    / im_vol_conv(i)
  ;

  pm_lambda_nrf(i)$(i52_gs_realistic_nrf(i) > 0) = f52_fra_nrf_gs(i) / i52_gs_realistic_nrf(i);

* ==========================================
* Plantation wood multiplier (lambda)
* Realistic plantation curve sampled at the cellular ROTATION age
* (pm_rotation_cellular_estb, module 32), area-weighted by plantation cell area.
* Rotation-age is the correct reference because harvest samples im_growing_stock(forestry)
* at exactly that age (32 presolve), so lambda*V(rot) = FRA by construction. Weighting by
* the plantation age SHAPE (pm_land_plantation) is wrong: that estate is curve-endogenous
* and collapses onto ac0 for a fast/no-lag curve, driving the reference to ~0 and lambda
* to non-physical values. Carbon density is never overwritten.
* ==========================================
  i52_gs_realistic_pla(i)$(sum(cell(i,j), sum(ac, pm_land_plantation(j,ac))) > 0) =
    sum(cell(i,j),
      sum(ac, pm_land_plantation(j,ac))
      * sum(ac2$(ac2.off = pm_rotation_cellular_estb("y2025",j)),
            pm_carbon_density_plantation_ac("y2025",j,ac2,"vegc"))
      * pm_gs_niche_fac(j)
    )
    / sum(cell(i,j), sum(ac, pm_land_plantation(j,ac)))
    / sm_carbon_fraction
    * fm_aboveground_fraction("forestry")
    / i52_bef_avg(i)
    / im_vol_conv(i)
  ;

  pm_lambda_pla(i)$(i52_gs_realistic_pla(i) > 0) = f52_fra_pla_gs(i) / i52_gs_realistic_pla(i);

* Log wood-multiplier (lambda) calibration to FRA 2025
  put_utility "log" / "Wood multiplier (lambda) calibration to FRA 2025 (m3/ha):";
  put_utility "log" / "         NRF (nat.forest)               plantation";
  put_utility "log" / "     target  realistic  lambda     target  realistic  lambda";
  loop(i,
    put_utility "log" / "  " i.tl:3 f52_fra_nrf_gs(i):8:1 i52_gs_realistic_nrf(i):8:1 pm_lambda_nrf(i):8:3 "  " f52_fra_pla_gs(i):8:1 i52_gs_realistic_pla(i):8:1 pm_lambda_pla(i):8:3;
  );

);
