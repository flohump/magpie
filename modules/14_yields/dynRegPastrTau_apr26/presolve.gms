*** |  (C) 2008-2026 Potsdam Institute for Climate Impact Research (PIK)
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

** Wood-only niche floor (module 52): lift arid low-asymptote cells' harvestable growing stock
** consistently with the m52 lambda denominator so lambda stays FRA-exact; carbon untouched. 0=off.
im_growing_stock(t,j,ac,"forestry")   = im_growing_stock(t,j,ac,"forestry")   * pm_gs_niche_fac(j);
im_growing_stock(t,j,ac,"secdforest") = im_growing_stock(t,j,ac,"secdforest") * pm_gs_niche_fac(j);

** Wood-only FRA calibration: scale the harvestable growing stock by the per-region
** multiplier from module 52 so that reported wood matches the FRA target. Carbon density
** is NOT touched here. Applied BEFORE the floors below so they act on calibrated wood.
** forestry uses the plantation multiplier, secdforest the natural-forest multiplier;
** primforest and other are deliberately left unscaled (never FRA-calibrated).
im_growing_stock(t,j,ac,"forestry")   = im_growing_stock(t,j,ac,"forestry")   * sum(cell(i,j), pm_lambda_pla(i));
im_growing_stock(t,j,ac,"secdforest") = im_growing_stock(t,j,ac,"secdforest") * sum(cell(i,j), pm_lambda_nrf(i));

** Other-planted forest wood: the secdforest (natveg) conversion chain on the other_planted carbon curve,
** sharing pm_lambda_nrf (no FRA other-planted GS target); own param because other_planted is not a land_timber element.
im_growing_stock_oplant(t,j,ac) =
    ( pm_carbon_density_other_planted_ac(t,j,ac,"vegc")
     / sm_carbon_fraction
     * fm_aboveground_fraction("secdforest")
     / sum(clcl, pm_climate_class(j,clcl) * fm_ipcc_bef(clcl)) )
    * pm_gs_niche_fac(j)
    * sum(cell(i,j), pm_lambda_nrf(i));
** other_planted growing stock needs no positive floor (only a multiplier in q32_prod_forestry; GS=0 harmless).

** Hard constraint to always have a positive number in im_growing_stock
im_growing_stock(t,j,ac,land_timber) = im_growing_stock(t,j,ac,land_timber)$(im_growing_stock(t,j,ac,land_timber) > 0) + 0.0001$(im_growing_stock(t,j,ac,land_timber) = 0);
** Set growing stock to 0 where it does not exceed a minimum for harvest
im_growing_stock(t,j,ac,land_natveg)$(im_growing_stock(t,j,ac,land_natveg) < s14_minimum_growing_stock) = 0;
