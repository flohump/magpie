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

*** TAU-OVERSHOOT DEGRADATION STATE UPDATE (Switch D) ***
*' Overshoot-triggered tau degradation accumulates a cell- and water-regime-
*' specific state variable that penalises realised yields. Overshoot is measured
*' against `pcm_tau`, i.e. the τ solved in the previous timestep, since the
*' penalty reflects a delayed response to prior over-application. The 13_tc
*' postsolve writes `pcm_tau = vm_tau.l` at the end of every timestep and
*' modules run in numerical order, so 14_yields presolve in timestep t reads
*' the τ from timestep t−1. The penalty then applies via `q14_yield_crop`
*' during the solve of timestep t. Recovery is slow (`s14_tau_rec_rate`) and
*' independent of overshoot sign; with the default 0.001/yr it implies
*' decades-to-centuries recovery timescales consistent with SOM literature.
*' Gated at `sm_fix_SSP2` to preserve historical calibration.
if ((s14_tau_degradation_on = 1) AND (m_year(t) > sm_fix_SSP2),
  p14_tau_degradation(j,w) = min( s14_tau_degr_max,
    max( 0,
      p14_tau_degradation(j,w)
      + s14_tau_degr_rate * m_yeardiff(t)
        * max(0, sum((cell(i,j), supreg(h,i)),
                     pcm_tau(j,"crop") / fm_tau1995(h))
                 - f14_tau_ceiling(j,w))
      - s14_tau_rec_rate * m_yeardiff(t) ) );
);
