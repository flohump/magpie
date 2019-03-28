*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

vm_cost_glo.scale = 10e7;
v11_cost_reg.scale(i) = 10e6;
vm_tech_cost.scale(i) = 10e5;
vm_secondary_overproduction.scale(i,kall,kpr) = 10e-3;
vm_cost_processing.scale(i) = 10e5;
vm_processing_substitution_cost.scale(i) = 10e4;
vm_cost_trade.scale(i) = 10e4;
vm_cost_fore.scale(i) = 10e3;
vm_cost_prod.scale(i,k) = 10e4;
vm_cost_landcon.scale(j,land) = 10e3;
vm_cost_AEI.scale(i) = 10e4;
vm_nr_inorg_fert_costs.scale(i) = 10e4;
vm_emission_costs.scale(i) = 10e4;
vm_maccs_costs.scale(i) = 10e4;
