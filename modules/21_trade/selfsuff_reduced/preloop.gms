*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de


*' Trade liberalization i.e. shift from self-sufficiency fixed pool to free pool begins
*' with sm_fix_SSP2 to keep values matching historical data until then.
loop(t_all,
 if(m_year(t_all) <= sm_fix_SSP2,
 i21_trade_bal_reduction(t_all,k_trade)=f21_trade_bal_reduction(t_all,"easytrade","l909090r808080");
 i21_trade_bal_reduction(t_all,k_hardtrade21)=f21_trade_bal_reduction(t_all,"hardtrade","l909090r808080");
 else
 i21_trade_bal_reduction(t_all,k_trade)=f21_trade_bal_reduction(t_all,"easytrade","%c21_trade_liberalization%");
i21_trade_bal_reduction(t_all,k_hardtrade21)=f21_trade_bal_reduction(t_all,"hardtrade","%c21_trade_liberalization%");
 );
);

i21_exports(t_all,h,k_trade) =  ((f21_self_suff(t_all,h,k_trade) * f21_dom_supply(t_all,h,k_trade)) - f21_dom_supply(t_all,h,k_trade))$(f21_self_suff(t_all,h,k_trade) > 1);
i21_exp_glo(t_all,k_trade) = sum(h, i21_exports(t_all,h,k_trade));
i21_exp_shr(t_all,h,k_trade) = i21_exports(t_all,h,k_trade) / (i21_exp_glo(t_all,k_trade) +  0.001$(i21_exp_glo(t_all,k_trade) = 0));

i21_trade_margin(h,k_trade) = f21_trade_margin(h,k_trade);

if ((s21_trade_tariff=1),
    i21_trade_tariff(h,k_trade) = f21_trade_tariff(h,k_trade);
elseif (s21_trade_tariff=0),
    i21_trade_tariff(h,k_trade) = 0;
);

i21_trade_margin(h,"wood")$(i21_trade_margin(h,"wood") < s21_min_trade_margin_forestry) = s21_min_trade_margin_forestry;
i21_trade_margin(h,"woodfuel")$(i21_trade_margin(h,"woodfuel") < s21_min_trade_margin_forestry) = s21_min_trade_margin_forestry;

v21_import_for_feasibility.fx(h,k_trade) = 0;
v21_import_for_feasibility.lo(h,k_import21) = 0;
v21_import_for_feasibility.up(h,k_import21) = Inf;
