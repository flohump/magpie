*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

if (s21_walras_auction=0,
 v21_trade_flows.fx(i,k_trade) = 0;
 v21_cash_flows.fx(i) = 0;
 v21_costAdjNash.fx(i) = 0;
else
 v21_trade_flows.lo(i,k_trade) = -Inf;
 v21_trade_flows.up(i,k_trade) = Inf;
 v21_cash_flows.lo(i) = -Inf;
 v21_cash_flows.up(i) = Inf;
 v21_costAdjNash.lo(i) = 0;
 v21_costAdjNash.up(i) = Inf;
);
