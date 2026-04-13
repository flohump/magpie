*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @equations

***CROP YIELD CALCULATIONS**********************************************

*' Crop yields scale the calibrated biophysical input yields
*' `i14_yields_calib` by the ratio of the current agricultural intensity
*' `vm_tau(j,"crop")` to its 1995 baseline `fm_tau1995(h)`.
*'
*' Optional switch `s14_adoption_on` multiplies the tau uplift by a
*' cell-level adoption share `i14_adoption(j) ∈ [s14_adoption_floor, 1]`
*' that captures spatial heterogeneity in the absorption of regional
*' R&D investment. The share is computed in `presolve.gms` from JRC
*' travel-time accessibility (`f40_distance` from module 40_transport)
*' and the World Bank governance indicator (`im_governance_indicator`
*' from module 09_drivers) and is gated at `sm_fix_SSP2` via
*' `p14_adoption_on_active` so historical calibration is preserved.
*' With the switch off the equation reduces to the baseline
*' `i14_yields_calib · vm_tau/fm_tau1995` form.

q14_yield_crop(j2,kcr,w) ..
 vm_yld(j2,kcr,w) =e= sum(ct,i14_yields_calib(ct,j2,kcr,w))
   * ( 1
       + (p14_adoption_on_active * i14_adoption(j2) + (1 - p14_adoption_on_active))
         * ( vm_tau(j2,"crop")
             / sum((cell(i2,j2), supreg(h2,i2)), fm_tau1995(h2))
             - 1 ) );

*' For the current time step of the optimization, cellular yields of irrigated
*' and rainfed crops are calculated by multiplying calibrated input yields from
*' LPJmL with the intensification rate relative to the initial time step 1995.

***PASTURE YIELD CALCULATIONS*******************************************

*' In the case of pasture yields, technological change cannot be fully
*' translated into yield increases, to address that, an exogenous pasture management
*' factor `pm_past_mngmnt_factor` is used to scale pasture yields based on the
*' number of cattle reared to fulfill the domestic demand for ruminant livestock
*' products in module 70.
*'
*' Additionally, the parameter `s14_yld_past_switch` can be used to capture a
*' certain magnitude of spillovers of the yield increase due to technological
*' change from the time step before. It can range from 0 (no spillover) to 1
*' (full spillover).

q14_yield_past(j2,w) ..
 vm_yld(j2,"pasture",w) =e=
 sum(ct,(i14_yields_calib(ct,j2,"pasture",w))
 * sum(cell(i2,j2),pm_past_mngmnt_factor(ct,i2)))
 * (1 + s14_yld_past_switch*(sum((cell(i2,j2), supreg(h2,i2)), pcm_tau(j2, "crop")/fm_tau1995(h2)) - 1));
