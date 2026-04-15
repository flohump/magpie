*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

i14_yields_calib(t,j,kve,w)   = f14_yields(t,j,kve,w);

* Switch G (overshoot damage) initial state: zero damage at start of run.
* Decay and accumulation are applied each timestep in presolve based on
* pc13_tcguess(h,"crop") (previous period's tau growth rate). Gated at
* sm_fix_SSP2 via p14_damage_on_active so historical timesteps are
* bit-identical to develop when the switch is off.
p14_damage(h) = 0;
p14_damage_on_active = 0;

***YIELD CORRECTION FOR 2ND GENERATION BIOENERGY CROPS*************************************
i14_yields_calib(t,j,"begr",w) = f14_yields(t,j,"begr",w) * sum((supreg(h,i),cell(i,j)),fm_tau1995(h))/smax(h,fm_tau1995(h));
i14_yields_calib(t,j,"betr",w) = f14_yields(t,j,"betr",w) * sum((supreg(h,i),cell(i,j)),fm_tau1995(h))/smax(h,fm_tau1995(h));

***YIELD CORRECTION FOR PASTURE ACCOUNTING FOR REGIONAL DIFFERENCES IN MANAGEMENT***
p14_pyield_LPJ_reg(t,i) = (sum(cell(i,j),i14_yields_calib(t,j,"pasture","rainfed") * pm_land_start(j,"past")) /
                            sum(cell(i,j),pm_land_start(j,"past")) );

p14_pyield_corr(t,i) = (f14_pyld_hist(t,i)/p14_pyield_LPJ_reg(t,i))$(sum(sameas(t_past,t),1) = 1)
      + sum(t_past,(f14_pyld_hist(t_past,i)/(p14_pyield_LPJ_reg(t_past,i)+0.000001))$(ord(t_past)=card(t_past)))$(sum(sameas(t_past,t),1) <> 1);
i14_yields_calib(t,j,"pasture",w) = i14_yields_calib(t,j,"pasture",w) * sum(cell(i,j),p14_pyield_corr(t,i));


***YIELD MANAGEMENT CALIBRATION************************************************************


*' @code

*' The following equations calibrate the cellular yield patterns (`f14_yields`) to match
*' FAO historical yields (`f14_fao_yields_hist`) by calculating a calibration term called
*' 'i14_managementcalib'. For most cases, 'i14_managementcalib' is the ratio of the historical
*' yields reported by FAO (`f14_fao_yields_hist`) and regional mean yields (`i14_modeled_yields_hist`)
*' given historic crop area patterns ('fm_croparea') and cellular yields coming from crop models
*' like LPJmL (`f14_yields`). In these cases, 'i14_managementcalib' represents a purely relative
*' calibration factor that depends only on the initial conditions of the starting year.
*'
*' However, when FAO yields are significantly higher than given by the cellular yield inputs
*' (underestimated baseline), the relative calibration terms can lead to unrealistically large
*' yields in the case of future yield increases within the cellular yield patterns.
*'
*' To address this issue, the factor `i14_lambda_yields` determines the degree
*' to which the baseline (FAO) is under- or overestimated and therefore controls
*' whether the calibration factor is applied as an absolute or relative change.
*' For overestimated FAO yields, `i14_lambda_yields` is 1, which is equivalent
*' to an entirely relative calibration. For underestimated yields, `i14_lambda_yields`
*' is calculated as the squared root of the ratio between LPJmL yields and FAO historical
*' yields, and as `i14_lambda_yields`  approaches 0, it reduces the applied relative change
*' resulting in a mean change increasingly similar to an additive term (@Heinke.2013).

*' This concept is referred to as limited calibration, as it limits the calibration
*' to an additive term in case of a strongly underestimated baseline. The scalar
*' `s14_limit_calib` can be used to switch limited calibration on (1) and off (0).

i14_croparea_total(t_all,w,j) = sum(kcr, fm_croparea(t_all,j,w,kcr));

*' Historic crop area patterns (`fm_croprea`) are used to calculate regional yields
*' (`i14_modeled_yields_hist`) from the given cellular input pattern. In rare cases where
*' a region has no crop area reported for a given crop type, the total crop area is
*' used to calculate a proxy yield for the calibration, given by the following equation:

i14_modeled_yields_hist(t_past,i,knbe14)
   = (sum((cell(i,j),w), fm_croparea(t_past,j,w,knbe14) * f14_yields(t_past,j,knbe14,w)) /
      sum((cell(i,j),w), fm_croparea(t_past,j,w,knbe14)))$(sum((cell(i,j),w), fm_croparea(t_past,j,w,knbe14)) > 0.00001 AND
                                                           sum((cell(i,j),w), fm_croparea(t_past,j,w,knbe14) * f14_yields(t_past,j,knbe14,w)) > 0.00001)
   + (sum((cell(i,j),w), i14_croparea_total(t_past,w,j) * f14_yields(t_past,j,knbe14,w)) /
      sum((cell(i,j),w), i14_croparea_total(t_past,w,j)))$(sum((cell(i,j),w), fm_croparea(t_past,j,w,knbe14)) <= 0.00001 OR
                                                           sum((cell(i,j),w), fm_croparea(t_past,j,w,knbe14) * f14_yields(t_past,j,knbe14,w)) <= 0.00001);


*' The factor `i14_lambda_yields` is calculated for the initial time step depending
*' on the setting `s14_limit_calib` and is then held constant for all other time steps.
*' The regional FAO yield and regional yield of the crop model input of the initial
*' time step is kept constant in the two parameters `i14_fao_yields_hist` and
*' `i14_modeled_yields_hist`:

loop(t,
     if(sum(sameas(t,"y1995"),1)=1,

          if    ((s14_limit_calib = 0),
               i14_lambda_yields(t,i,knbe14) = 1;

          Elseif (s14_limit_calib =1 ),
               i14_lambda_yields(t,i,knbe14) =
                    1$(f14_fao_yields_hist(t,i,knbe14) <= i14_modeled_yields_hist(t,i,knbe14))
                    + sqrt(i14_modeled_yields_hist(t,i,knbe14)/f14_fao_yields_hist(t,i,knbe14))$
                    (f14_fao_yields_hist(t,i,knbe14) > i14_modeled_yields_hist(t,i,knbe14));
          );

          i14_fao_yields_hist(t,i,knbe14) = f14_fao_yields_hist(t,i,knbe14);

     Else
          i14_modeled_yields_hist(t,i,knbe14) = i14_modeled_yields_hist(t-1,i,knbe14);
          i14_FAO_yields_hist(t,i,knbe14)  = i14_fao_yields_hist(t-1,i,knbe14);
          i14_lambda_yields(t,i,knbe14)   = i14_lambda_yields(t-1,i,knbe14);
     );
);

*' The calibrated cellular yield `i14_yields_calib` is calculated for each time step depending
*' on the constant values `i14_modeled_yields_hist`, `i14_fao_yields_hist`, `i14_lambda_yields`
*' and the uncalibrated, cellular yield `f14_yields` following the idea of eq. (9) in [@Heinke.2013]:

i14_managementcalib(t,j,knbe14,w) =
  1 + (sum(cell(i,j), i14_fao_yields_hist(t,i,knbe14) - i14_modeled_yields_hist(t,i,knbe14)) /
                             f14_yields(t,j,knbe14,w) *
      (f14_yields(t,j,knbe14,w) / (sum(cell(i,j),i14_modeled_yields_hist(t,i,knbe14))+10**(-8))) **
                             sum(cell(i,j),i14_lambda_yields(t,i,knbe14)))$(f14_yields(t,j,knbe14,w)>0);


i14_yields_calib(t,j,knbe14,w)    = i14_managementcalib(t,j,knbe14,w) * f14_yields(t,j,knbe14,w);
pm_yields_semi_calib(j,knbe14,w)  = i14_yields_calib("y1995",j,knbe14,w);

*' Note that the calculation is split into two parts for better readability.

*' Irrigated yields are calibrated to meet the country-level
*' ratio between irrigated and rainfed yields reported by Aquastat.
*' This can be de-activated with the switch `s14_calib_ir2rf`.
if ((s14_calib_ir2rf = 1),

* Weighted yields
  i14_calib_yields_hist(i,w)
     = sum((cell(i,j), knbe14), fm_croparea("y1995",j,"irrigated",knbe14) * i14_yields_calib("y1995",j,knbe14,w)) /
       sum((cell(i,j), knbe14), fm_croparea("y1995",j,"irrigated",knbe14));

* Use irrigated-rainfed ratio of Aquastat if larger than our calculated ratio
  i14_calib_yields_ratio(i) = i14_calib_yields_hist(i,"irrigated") / i14_calib_yields_hist(i,"rainfed");
  i14_target_ratio(i) = max(i14_calib_yields_ratio(i), f14_ir2rf_ratio(i));
  i14_yields_calib(t,j,knbe14,"irrigated") = sum((cell(i,j)), i14_target_ratio(i) / i14_calib_yields_ratio(i)) *
                                               i14_yields_calib(t,j,knbe14,"irrigated");

* Calibrate newly calibrated yields to FAO yields
  i14_modeled_yields_hist2(i,knbe14)
   = (sum((cell(i,j),w), fm_croparea("y1995",j,w,knbe14) * i14_yields_calib("y1995",j,knbe14,w)) /
      sum((cell(i,j),w), fm_croparea("y1995",j,w,knbe14)))$(sum((cell(i,j),w), fm_croparea("y1995",j,w,knbe14)) > 0.00001 AND
                                                            sum((cell(i,j),w), fm_croparea("y1995",j,w,knbe14) * i14_yields_calib("y1995",j,knbe14,w)) > 0.00001)
   + (sum((cell(i,j),w), i14_croparea_total("y1995",w,j) * i14_yields_calib("y1995",j,knbe14,w)) /
      sum((cell(i,j),w), i14_croparea_total("y1995",w,j)))$(sum((cell(i,j),w), fm_croparea("y1995",j,w,knbe14)) <= 0.00001 OR
                                                                 sum((cell(i,j),w), fm_croparea("y1995",j,w,knbe14) * i14_yields_calib("y1995",j,knbe14,w)) <= 0.00001);

  i14_yields_calib(t,j,knbe14,w) = sum((cell(i,j)), i14_fao_yields_hist("y1995",i,knbe14) /
                                                      i14_modeled_yields_hist2(i,knbe14)) *
                                   i14_yields_calib(t,j,knbe14,w);

  pm_yields_semi_calib(j,knbe14,w)  = i14_yields_calib("y1995",j,knbe14,w);
);

*' @stop


***YIELD CALIBRATION***********************************************************************

*' @code
*' Calibrated yields can additionally be adjusted by calibration factors 'f14_yld_calib'
*' determined in a calibration run. As MAgPIE optimizes yield patterns and FAO regional
*' yields are outlier corrected, historical production and croparea can in some cases
*' be better represented with this additional correction:

* set yield calib factors to 1 in case of no use of yield calibration factors (s14_use_yield_calib = 0)
* or missing input file
if(s14_use_yield_calib = 0 OR sum((i,ltype14),f14_yld_calib(i,ltype14)) = 0,
  f14_yld_calib(i,ltype14) = 1;
);


i14_yields_calib(t,j,kcr,w)       = i14_yields_calib(t,j,kcr,w)
                                    * sum(cell(i,j),f14_yld_calib(i,"crop"));
i14_yields_calib(t,j,"pasture",w) = i14_yields_calib(t,j,"pasture",w)
                                    * sum(cell(i,j),f14_yld_calib(i,"past"));

*' @stop

*' @code
*' Land degradation can negatively affect yields. Soil loss for example can
*' notably affect land productivity. Similarly, the yield of pollinator-dependent crops
*' is reduced when there is a lack of pollinators. To account for the impacts of degradation,
*' calibrated yields are multiplied by the share of land with intact NCP in each cell and specific
*' yield reduction coefficients that represent yield loss due to soil erosion and pollination
*' deficiency on non-intact land.

* set default values in case of missing input file.
if(sum((t,j,ncp_type14),f14_yld_ncp_report(t,j,ncp_type14)) = 0,
  f14_yld_ncp_report(t,j,ncp_type14) = 1;
);

if ((s14_degradation = 1),
  i14_yields_calib(t,j,kcr,w) = i14_yields_calib(t,j,kcr,w) * (1 - s14_yld_reduction_soil_loss)
                                + i14_yields_calib(t,j,kcr,w) * s14_yld_reduction_soil_loss * f14_yld_ncp_report(t,j,"soil_intact");
  i14_yields_calib(t,j,kcr,w) = i14_yields_calib(t,j,kcr,w) * (1 - f14_kcr_pollinator_dependence(kcr))
                                + i14_yields_calib(t,j,kcr,w) * f14_kcr_pollinator_dependence(kcr) * f14_yld_ncp_report(t,j,"poll_suff");
);

*' @stop

***SWITCH C / D INITIALISATION************************************************

*' Switch C — cell-level adoption dampener.
*' Two complementary indicators capture the structural barriers to
*' agricultural-technology adoption that MAgPIE does not otherwise model:
*'
*'   1. JRC travel-time accessibility (Weiss et al. 2018, downscaled to
*'      MAgPIE clusters by module 40_transport via `f40_distance(j)`).
*'      Cells next to urban centres are at full adoption; cells far from
*'      cities cannot rely on extension, markets and input supply.
*'      Mapped log-linearly to a [0, 1] penalty between `s14_adoption_d_lo`
*'      and `s14_adoption_d_hi` (defaults 10 min and 2000 min).
*'
*'   2. Governance quality (`im_governance_indicator`, sourced from World
*'      Bank Worldwide Governance Indicators via mrcommons). Captures
*'      institutional capacity, rule of law, regulatory quality and
*'      government effectiveness — the things that determine whether
*'      agricultural research, extension, credit and tenure security
*'      actually reach farmers. Region-level, time-varying, SSP-dependent.
*'
*' The two are combined via weights (`s14_adoption_w_dist`,
*' `s14_adoption_w_gov`, default 0.4 / 0.6) and mapped linearly to the
*' adoption share `i14_adoption(j)` in [`s14_adoption_floor`, 1].
*'
*' The distance term is static and computed here in preloop. The governance
*' term is time-varying and combined into `i14_adoption(j)` each timestep
*' in `presolve.gms`. The cost equation in 13_tc is blind to `i14_adoption`,
*' so the solver cannot compensate for the dampener by over-investing in τ.

p14_adoption_dist_term(j) =
  max(0, min(1,
    (log10(max(1, f40_distance(j))) - log10(s14_adoption_d_lo))
    / (log10(s14_adoption_d_hi) - log10(s14_adoption_d_lo))));

i14_adoption(j) = 1;
