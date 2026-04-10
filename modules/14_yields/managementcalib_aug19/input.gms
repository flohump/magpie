*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

$setglobal c14_yields_scenario  cc
*   options:  cc        (climate change)
*             nocc      (no climate change)
*             nocc_hist (no climate change after year defined by sm_fix_cc)


scalars
s14_limit_calib                    Relative managament calibration switch (1=limited 0=pure relative) / 1 /
s14_calib_ir2rf                    Switch to calibrate rainfed to irrigated yield ratios (1=calib 0=not calib) / 1 /
s14_degradation                    Switch to include yield impacts of land degradation(0=no degradation 1=with degradation) / 0 /
s14_use_yield_calib                Switch for using or not using yield calibration factors from the preprocessing (1=use facs 0=not use facs) / 0 /
s14_minimum_growing_stock          Minimum growing stock for timber harvest in natural vegetation (tDM per ha) / 5 /
s14_yld_past_switch                Spillover parameter for translating technological change in the crop sector into pasture yieldincreases  (1)     / 0.25 /
s14_yld_reduction_soil_loss        Decline of land productivity in areas with severe soil loss (1)     / 0.08 /
sm_carbon_fraction                 Carbon fraction of dry matter (tC per tDM) / 0.5 /
s14_tau_exponent_on                Switch for concave tau yield response (0=linear 1=apply exponent) gated at sm_fix_SSP2 (1) / 0 /
s14_tau_exponent                   Concave exponent beta on (vm_tau divided by fm_tau1995) (1)                                / 1 /
s14_adoption_on                    Switch for cell-level tau adoption dampener (0=off 1=on) gated at sm_fix_SSP2 (1)          / 0 /
s14_tau_degradation_on             Switch for overshoot-triggered tau degradation (0=off 1=on) gated at sm_fix_SSP2 (1)       / 0 /
s14_tau_degr_rate                  Tau-overshoot degradation accumulation rate per unit overshoot per yr (1)                 / 0.02 /
s14_tau_rec_rate                   Tau-degradation recovery rate per yr when no overshoot (1)                                / 0.001 /
s14_tau_degr_max                   Maximum accumulated tau-degradation fraction (1)                                          / 0.30 /
s14_adoption_uniform_default       Uniform adoption share used to fill f14_adoption when the input file is absent (1)        / 1 /
s14_tau_ceiling_uniform_default    Uniform tau ceiling used to fill f14_tau_ceiling when the input file is absent (1)        / 100 /
;


******* Calibration factor
$onEmpty
table f14_yld_calib(i,ltype14) Calibration factor for the LPJmL yields (1)
$ondelim
$if exist "./modules/14_yields/input/f14_yld_calib.csv" $include "./modules/14_yields/input/f14_yld_calib.csv"
$offdelim
;
$offEmpty

table f14_yields(t_all,j,kve,w) LPJmL potential yields per cell (rainfed and irrigated) (tDM per ha per yr)
$ondelim
$include "./modules/14_yields/input/lpj_yields.cs3"
$offdelim
;
* set values to 1995 if nocc scenario is used, or to sm_fix_cc after sm_fix_cc if nocc_hist is used
$if "%c14_yields_scenario%" == "nocc" f14_yields(t_all,j,kve,w) = f14_yields("y1995",j,kve,w);
$if "%c14_yields_scenario%" == "nocc_hist" f14_yields(t_all,j,kve,w)$(m_year(t_all) > sm_fix_cc) = f14_yields(t_all,j,kve,w)$(m_year(t_all) = sm_fix_cc);
m_fillmissingyears(f14_yields,"j,kve,w");

table f14_pyld_hist(t_all,i) Modelled regional pasture yields in the past (tDM per ha per yr)
$ondelim
$include "./modules/14_yields/input/f14_pasture_yields_hist.csv"
$offdelim;


table f14_fao_yields_hist(t_all,i,kcr) FAO yields per region (tDM per ha per yr)
$ondelim
$include "./modules/14_yields/managementcalib_aug19/input/f14_region_yields.cs3"
$offdelim
;
m_fillmissingyears(f14_fao_yields_hist,"i,kcr");

parameter f14_ir2rf_ratio(i) AQUASTAT ratio of irrigated to rainfed yields per region (1)
/
$ondelim
$include "./modules/14_yields/managementcalib_aug19/input/f14_ir2rf_ratio.cs4"
$offdelim
/
;

parameter fm_ipcc_bef(clcl) IPCC biomass expansion factor BEF (1)
/
$ondelim
$include "./modules/14_yields/input/f14_ipcc_bef.cs3"
$offdelim
/
;

parameter fm_aboveground_fraction(land_timber) Aboveground fraction of total biomass (1)
/
$ondelim
$include "./modules/14_yields/input/f14_aboveground_fraction.csv"
$offdelim
/
;

$onEmpty
table f14_yld_ncp_report(t_all,j,ncp_type14) Share of land with intact natures contributions to people (NCP) (1)
$ondelim
$if exist "./modules/14_yields/input/f14_yld_ncp_report.cs3" $include "./modules/14_yields/input/f14_yld_ncp_report.cs3"
$offdelim
;
$offEmpty

parameter f14_kcr_pollinator_dependence(kcr) Share of total yield dependent on biotic pollination (1)
/
$ondelim
$include "./modules/14_yields/input/f14_kcr_pollinator_dependence.csv"
$offdelim
/
;

*' Optional input for the cell-level tau adoption dampener (Switch C).
*' If the file is absent an empty table is declared and the preloop falls back
*' to a uniform value of 1 (i.e. dampener has no effect). Units are a share in
*' (0,1] giving the fraction of the regional tau uplift that materialises in a
*' given cell and water regime.
$onEmpty
table f14_adoption(j,w) Cell-level tau adoption share (1)
$ondelim
$if exist "./modules/14_yields/input/f14_adoption.cs3" $include "./modules/14_yields/input/f14_adoption.cs3"
$offdelim
;
$offEmpty

*' Optional input for the sustainable τ ceiling per cell (Switch D). If the file
*' is absent the preloop falls back to a uniform ceiling of 2.5. The ceiling is
*' a unitless ratio compared against `vm_tau(j,"crop") / fm_tau1995(h)`.
$onEmpty
table f14_tau_ceiling(j,w) Sustainable tau ceiling per cell and water regime (1)
$ondelim
$if exist "./modules/14_yields/input/f14_tau_ceiling.cs3" $include "./modules/14_yields/input/f14_tau_ceiling.cs3"
$offdelim
;
$offEmpty
