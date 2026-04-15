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

*** TIME-GATED EFFECTIVE SWITCH VALUE (Switch C) ***
*' s14_adoption_on is a scalar without a time dimension, so it would
*' otherwise apply to every timestep. To preserve historical calibration the
*' effective switch is zero until m_year(t) > sm_fix_SSP2 and takes the
*' user-configured value thereafter. The yield equation uses
*' p14_adoption_on_active instead of the raw scalar.
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

*** SWITCH G — overshoot damage state update ***
*' p14_damage(h) is a super-region-level state variable that accumulates
*' when the previous period's tau growth rate exceeds s14_damage_threshold_rate
*' and decays over time at s14_damage_recovery per year. It is capped at
*' s14_damage_max. The growth-rate signal comes from pc13_tcguess(h,"crop")
*' which 13_tc postsolve computes as (v13_tau_core.l / pc13_tau)^(1/dt) - 1
*' for the period that just ended. Damage enters q14_yield_crop as a
*' multiplicative (1 - p14_damage) factor, so yields decline in super-regions
*' that have been pushing tau too hard even when the current period's rate
*' slows. Gated at sm_fix_SSP2 so historical calibration is preserved.
*' Anchored in Borrelli 2017 / Sanderman 2017 (recovery magnitudes) and
*' Grassini 2013 (plateau regions overshoot evidence).
p14_damage_on_active = s14_damage_on$(m_year(t) > sm_fix_SSP2);

if (s14_damage_on = 1 AND m_year(t) > sm_fix_SSP2,
  p14_damage(h) = min(s14_damage_max,
                       p14_damage(h) * max(0, 1 - s14_damage_recovery * m_yeardiff(t))
                     + max(0, pc13_tcguess(h,"crop") - s14_damage_threshold_rate)
                         * s14_damage_accumulation * m_yeardiff(t));
);
