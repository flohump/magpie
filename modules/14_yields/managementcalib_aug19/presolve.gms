*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*** EOF presolve.gms ***

* calculate carbon density

*** HARVESTABLE GROWING STOCK

*' `pm_carbon_density_plantation_ac` for vegetation carbon is above- and belowground
*' carbon density. We convert Carbon density in tC/ha to tDM/ha by using carbon
*' fraction of `sm_carbon_fraction` in tC/tDM. For assessing wood harvesting
*' we need only aboveground biomass information, therefore we multiply with
*' aboveground `fm_aboveground_fraction`. Additionally, we divide aboveground
*' tree biomass by the Biomass Expansion Factor (BEF, dimensionless) to get
*' stem biomass in tDM/ha. BEF = AGB (aboveground biomass) / stem_biomass (always > 1).

*' @code

im_growing_stock(t,j,ac,"forestry") =
    (
     pm_carbon_density_plantation_ac(t,j,ac,"vegc")
     / sm_carbon_fraction
     * fm_aboveground_fraction("forestry")
     / sum(clcl, pm_climate_class(j,clcl) * fm_ipcc_bef(clcl))
    )
    ;

im_growing_stock(t,j,ac,"primforest") =
    (
     fm_carbon_density(t,j,"primforest","vegc")
     / sm_carbon_fraction
     * fm_aboveground_fraction("primforest")
     / sum(clcl, pm_climate_class(j,clcl) * fm_ipcc_bef(clcl))
    )
    ;

im_growing_stock(t,j,ac,"secdforest") =
    (
     pm_carbon_density_secdforest_ac(t,j,ac,"vegc")
     / sm_carbon_fraction
     * fm_aboveground_fraction("secdforest")
     / sum(clcl, pm_climate_class(j,clcl) * fm_ipcc_bef(clcl))
    )
    ;

im_growing_stock(t,j,ac,"other") =
    (
     pm_carbon_density_other_ac(t,j,ac,"vegc")
     / sm_carbon_fraction
     * fm_aboveground_fraction("other")
     / sum(clcl, pm_climate_class(j,clcl) * fm_ipcc_bef(clcl))
    )
    ;

*' @stop

** Hard constraint to always have a positive number in im_growing_stock
im_growing_stock(t,j,ac,land_timber) = im_growing_stock(t,j,ac,land_timber)$(im_growing_stock(t,j,ac,land_timber) > 0) + 0.0001$(im_growing_stock(t,j,ac,land_timber) = 0);
** Set growing stock to 0 where it does not exceed a minimum for harvest
im_growing_stock(t,j,ac,land_natveg)$(im_growing_stock(t,j,ac,land_natveg) < s14_minimum_growing_stock) = 0;

*** TIME-GATED EFFECTIVE SWITCH VALUES (Switches B and C) ***
*' Switches s14_tau_exponent_on and s14_adoption_on are scalars without a
*' time dimension, so they would otherwise apply to every timestep. To
*' preserve historical calibration these effective switches are zero until
*' m_year(t) > sm_fix_SSP2 and take the user-configured value thereafter.
*' The yield equation then uses p14_tau_exp_on_active and
*' p14_adoption_on_active instead of the raw scalars.
p14_tau_exp_on_active  = s14_tau_exponent_on$(m_year(t) > sm_fix_SSP2);
p14_adoption_on_active = s14_adoption_on$(m_year(t) > sm_fix_SSP2);

*** SWITCH C — i14_adoption(j) UPDATE (governance + travel-time) ***
*' Recompute the adoption share each timestep so the governance term
*' (which is time-varying via `im_governance_indicator(t,i)`) is picked up.
*' The distance term is static and was set in preloop. Combined penalty in
*' [0, 1] is mapped linearly to alpha in [s14_adoption_floor, 1].
i14_adoption(j) = max(s14_adoption_floor, min(1.0,
  1.0 - (1 - s14_adoption_floor) * (
      s14_adoption_w_dist * p14_adoption_dist_term(j)
    + s14_adoption_w_gov  * sum(cell(i,j), 1 - im_governance_indicator(t,i))
  )));

*** SWITCH D2 — SOM-coupled yield-loss factor ***
*' Capture the 1995 cropland SOC density as baseline at the first timestep.
*' This must happen in presolve (not preloop) because 59_som's own preloop
*' runs after 14_yields' preloop, so pcm_carbon_density is empty during
*' 14_yields preloop.
if (ord(t) = 1,
  p14_som_baseline_density(j) = pcm_carbon_density(j,"crop");
);

*' Compares the current cropland SOC density (carried forward by 59_som
*' via the new cross-module `pcm_carbon_density(j,"crop")`) to the 1995
*' baseline density captured above.
*' If current density falls below baseline, the yield-loss factor scales
*' linearly up to `s14_som_max_yld_loss` (default 0.30 = 30 % max penalty).
*' If current density meets or exceeds baseline, the penalty is zero.
*'
*' This closes the missing SOM → yield feedback loop. MAgPIE's optimiser
*' chooses management practices in 18_residues, 50_nr_soil_budget, 55_awms
*' and the 59_som SCM/fallow/treecover decisions, all of which feed into
*' the SOC pool. Adding a yield consequence gives the optimiser a
*' productivity reason to invest in soil conservation when intensification
*' would otherwise mine the SOC stock.
*'
*' Gated at `sm_fix_SSP2` and behind `s14_som_yld_loss_on`. The SOC
*' density is read from `pcm_carbon_density` which is set in 59_som's
*' postsolve at the end of each timestep — so 14_yields presolve in
*' timestep t reads the SOC pool from timestep t-1, giving the correct
*' lagged feedback.
p14_som_yld_loss(j) = 0;
if ((s14_som_yld_loss_on = 1) AND (m_year(t) > sm_fix_SSP2),
  p14_som_yld_loss(j)$(p14_som_baseline_density(j) > 1e-10) =
    max(0, min(s14_som_max_yld_loss,
      s14_som_max_yld_loss * (1 - pcm_carbon_density(j,"crop")
                                 / p14_som_baseline_density(j))));
);
