*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' Sticky natveg harvest-capacity cost (see input.gms / equations.gms).

*' Capital required per unit of natveg timber production: the natveg per-tDM harvest cost,
*' scaled by the intensity switch and capitalized by dividing by (interest + depreciation),
*' analogously to 38_factor_costs sticky_feb18.
p73_hvcapital_need(t,i) = s73_hvcapital_intensity * i73_timber_prod_cost_natveg(i,"wood")
                          / (pm_interest(t,i) + s73_hvcapital_depreciation);

*' The mechanism is only active after the SSP2 fix year, and only when switched on. Before that
*' (and when off) p73_sticky_active is zero, which zeroes the investment and the sticky cost, so
*' the base model is reproduced bit-for-bit.
p73_sticky_active(t) = s73_sticky_harvest$(m_year(t) > sm_fix_SSP2);

*' Depreciate the capital stock carried from the previous timestep (the stock at ord(t)=1 is zero).
if (ord(t) > 1,
  p73_hvcapital(t,j,land_natveg) = p73_hvcapital(t,j,land_natveg)
                                   * (1-s73_hvcapital_depreciation)**(m_timestep_length);
);
