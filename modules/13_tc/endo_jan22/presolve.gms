*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de


pc13_land(i,"pastr") = sum(cell(i,j),pcm_land(j,"past"));
pc13_land(i,"crop") = sum(cell(i,j),pcm_land(j,"crop"));

if (sum(sameas(t_past,t),1) = 1 AND s13_ignore_tau_historical = 0,
  v13_tau_core.lo(h,"pastr") =   f13_pastr_tau_hist(t,h);
  v13_tau_core.lo(h,"crop") =    f13_tau_historical(t,h);
else
  v13_tau_core.lo(h, tautype) =    pc13_tau(h, tautype);
);

  v13_tau_core.up(h,tautype) = 2 * pc13_tau(h,tautype);

* Switch F (R&D decay, tau-brainstorm branch): relax the v13_tau_core
* lower bound for crop tau to allow tau to DECLINE by up to
* s13_decay_rate per year if the solver finds the marginal benefit of
* maintaining tau below its maintenance cost (Switch A) or below the
* yield benefit (e.g., when Switch G's damage factor reduces the
* realized yield uplift from tau). Structurally converts tau from
* Dietrich 2014's "bought once, owned forever" asset into a depreciating
* capability whose continuous spending is required to stay in place.
* Anchored in Alston 2010 / Pardey 2013 R&D depreciation (2-4 %/yr);
* 0.5 %/yr is the conservative lower end. Gated at sm_fix_SSP2 so
* historical calibration is preserved. Must be combined with the
* q13_tech_cost =g= relaxation in equations.gms, otherwise the cost
* equation becomes infeasible when tau declines.
if (s13_decay_on = 1 AND m_year(t) > sm_fix_SSP2,
  v13_tau_core.lo(h,"crop") = pc13_tau(h,"crop")
                              * max(0, 1 - s13_decay_rate * m_yeardiff(t));
);

* Switch E (rate cap, tau-brainstorm branch): tighten the v13_tau_core upper bound
* to enforce a level-dependent annual growth rate cap on regional tau. Linear
* interpolation between a catch-up rate (s13_rate_catchup) at low tau and a
* frontier rate (s13_rate_frontier) at s13_tau_cap. Anchored in Fischer &
* Edmeades 2010 (frontier plateau ~1.5 %/yr) and Cassman & Grassini 2020 /
* Grassini et al. 2013 (catch-up regional envelope). Gated at sm_fix_SSP2
* so historical calibration is bit-identical to develop when off.
if (s13_rate_cap_on = 1 AND m_year(t) > sm_fix_SSP2,
  p13_rate_cap(h) = s13_rate_frontier
    + (s13_rate_catchup - s13_rate_frontier)
      * max(0, min(1, (s13_tau_cap - pc13_tau(h,"crop")) / (s13_tau_cap - 1)));
  v13_tau_core.up(h,"crop") = min(
    v13_tau_core.up(h,"crop"),
    pc13_tau(h,"crop") * (1 + p13_rate_cap(h) * m_yeardiff(t))
  );
);

* P0-freeze diagnostic: fix v13_tau_core at the previous timestep value from
* s13_tau_freeze_year onwards. Default 0 disables this block. Used to compute
* the lower envelope of yields achievable when τ is not allowed to grow further.
if (s13_tau_freeze_year > 0 AND m_year(t) >= s13_tau_freeze_year,
  v13_tau_core.fx(h, tautype) = pc13_tau(h, tautype);
);

if(m_year(t) > sm_fix_SSP2 AND s13_max_gdp_shr <> Inf,

* We constrain tech cost to a defined share of regional GDP to avoid unrealistically
* high endogenous tech investments
  vm_tech_cost.up(i) =
    sum((i_to_iso(i,iso),ct), im_gdp_pc_ppp_iso(ct,iso) * im_pop_iso(ct,iso)) * s13_max_gdp_shr;

* We set the initial solving basis for the tech cost to its upper bound to support the solver in finding
* a proper solution. Without such initial values, the model leave tech cost at 0 and as such ignore tau
* as an efficient part of the optimal solution.
  vm_tech_cost.l(i) = vm_tech_cost.up(i);

);

*** Share of cropland within conservation priority area
p13_cropland_consv_shr(t,j) = 0;

if(c13_croparea_consv = 1,
* the cropland area within conservation priority areas is provided by the interface `pm_land_conservation`
  p13_cropland_consv_shr(t,j)$(pcm_land(j,"crop") > 0) = sum(consv_type, pm_land_conservation(t,j,"crop",consv_type))/pcm_land(j,"crop");
  p13_cropland_consv_shr(t,j)$(p13_cropland_consv_shr(t,j) > 1) = 1;

* The following lines allow to freely chose a given share of the total cropland
* area that should be subject to conservation management with a lower land use intensity.
  if(s13_croparea_consv_shr > 0 AND m_year(t) >= s13_croparea_consv_start,
* Because MAgPIE is not run at country-level, but at region level, a region
* share is calculated that translates the countries' influence to regional level.
* Countries are weighted by available cropland area.
    p13_country_weight(i) = sum(i_to_iso(i,iso), p13_country_switch(iso) * pm_avl_cropland_iso(iso)) / sum(i_to_iso(i,iso), pm_avl_cropland_iso(iso));
    p13_cropland_consv_shr(t,j) = i13_croparea_consv_fader(t) *
    (s13_croparea_consv_shr * sum(cell(i,j), p13_country_weight(i))
    + s13_croparea_consv_shr_noselect * sum(cell(i,j), 1-p13_country_weight(i)));

  );

);

* ISO country weights are calculated based on the available cropland area in each country
p13_country_wght_supreg(h) = sum((i_to_iso(i,iso), supreg(h,i)), p13_country_switch(iso) * pm_avl_cropland_iso(iso)) / sum((i_to_iso(i,iso), supreg(h,i)), pm_avl_cropland_iso(iso));

* Country-weighted tau reduction factor for conservation land
p13_croparea_consv_tau_factor(h) = (s13_croparea_consv_tau_factor * p13_country_wght_supreg(h)
                            + s13_croparea_consv_tau_factor_noselect * (1-p13_country_wght_supreg(h)));

if (ord(t) = 1,
  pc13_tau_consv(h,tautype) = p13_croparea_consv_tau_factor(h) * pc13_tau(h,"crop");
elseif c13_croparea_consv_tau_increase = 0 AND m_year(t) >= s13_croparea_consv_start,
  v13_tau_consv.fx(h,tautype) = pc13_tau_consv(h,tautype);
);


* educated guess for tau levels:
if(ord(t) = 1,
  v13_tau_core.l(h,tautype) = pc13_tau(h,tautype);
  v13_tau_consv.l(h,tautype) = pc13_tau_consv(h,tautype);
  vm_tau.l(j,tautype) = sum((cell(i,j), supreg(h,i)),(1-p13_cropland_consv_shr(t,j)) * v13_tau_core.l(h,tautype) + p13_cropland_consv_shr(t,j) * v13_tau_consv.l(h,tautype));
  pcm_tau(j,tautype) = vm_tau.l(j,tautype);
else
  v13_tau_core.l(h,tautype) = pc13_tau(h,tautype)*(1+pc13_tcguess(h,tautype))**m_yeardiff(t);
  v13_tau_consv.l(h,tautype) = p13_croparea_consv_tau_factor(h) * v13_tau_core.l(h,tautype);
);
