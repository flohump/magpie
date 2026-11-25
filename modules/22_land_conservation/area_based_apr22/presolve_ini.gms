*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

* ==================
* Land conservation
* ==================

* Define natural vegetation conservation options based on
* remaining natural vegation in current time step

* Include all remaining primary forest areas in IFL conservation target
p22_add_consv(t,j,"IFL","primforest") = pcm_land(j,"primforest") * p22_conservation_fader(t);
p22_add_consv(t,j,"BH_IFL","primforest") = pcm_land(j,"primforest") * p22_conservation_fader(t);


if(m_year(t) <= sm_fix_SSP2,
* from 1995 to 2020 land conservation is based on
* historic trends as derived from WDPA
 p22_conservation_area(t,j,land) = sum(cell(i,j),
      p22_wdpa_baseline(t,j,"%c22_base_protect%",land) * p22_country_weight(i)
      + p22_wdpa_baseline(t,j,"%c22_base_protect_noselect%",land) * (1-p22_country_weight(i))
      );

else

** Future land conservation
p22_conservation_area(t,j,land) = sum(cell(i,j),
      p22_wdpa_baseline(t,j,"%c22_base_protect%",land) * p22_country_weight(i)
      + p22_wdpa_baseline(t,j,"%c22_base_protect_noselect%",land) * (1-p22_country_weight(i))
      );
* future options for land conservation are added to the WDPA baseline
p22_conservation_area(t,j,land_consv) =
    sum(cell(i,j),
      p22_wdpa_baseline(t,j,"%c22_base_protect%",land_consv) * p22_country_weight(i)
      + p22_wdpa_baseline(t,j,"%c22_base_protect_noselect%",land_consv) * (1-p22_country_weight(i))
      )
    + sum(cell(i,j),
      p22_add_consv(t,j,"%c22_protect_scenario%",land_consv) * p22_country_weight(i)
      + p22_add_consv(t,j,"%c22_protect_scenario_noselect%",land_consv) * (1-p22_country_weight(i))
      );
);

* -----------------------
* Protect remaining land
* -----------------------

* Note: The prescribed conservation area for each land pool can be smaller, equal or 
* higher than the land pools of the previous time step. If the conservation area is 
* larger and s22_restore_land = 1, missing land will be restored.
pm_land_conservation(t,j,land,"protect") = p22_conservation_area(t,j,land);
pm_land_conservation(t,j,land,"protect")$(pm_land_conservation(t,j,land,"protect") > pcm_land(j,land)) = pcm_land(j,land);


* -------------------
* Land restoration
* -------------------

if(s22_restore_land = 1 OR m_year(t) <= sm_fix_SSP2,

** Calculate restoration targets
* Grassland
pm_land_conservation(t,j,"past","restore")$(p22_conservation_area(t,j,"past") > pcm_land(j,"past")) =
        p22_conservation_area(t,j,"past") - pcm_land(j,"past");
* Forest land
* Total forest restoration requirements are attributed to
* secdforest, as primforest cannot be restored by definition
pm_land_conservation(t,j,"secdforest","restore") =
        (p22_conservation_area(t,j,"primforest") + p22_conservation_area(t,j,"secdforest"))
        - (pcm_land(j,"primforest") + pcm_land(j,"secdforest"));
pm_land_conservation(t,j,"secdforest","restore")$(pm_land_conservation(t,j,"secdforest","restore") < 1e-6) = 0;
* Other land
pm_land_conservation(t,j,"other","restore")$(p22_conservation_area(t,j,"other") > pcm_land(j,"other")) =
        p22_conservation_area(t,j,"other") - pcm_land(j,"other");

* Adjust forest, grassland and other land restoration depending on given land available for restoration (restoration potential)

* Secondary forest restoration is limited by secondary forest restoration potential
p22_secdforest_restore_pot(t,j) = sum(land, pcm_land(j, land))
                - pcm_land(j, "urban")
                - sum(land_timber, pcm_land(j, land_timber))
                - pm_land_conservation(t,j,"past","protect")
                - vm_land.lo(j,"crop")
                - vm_treecover.l(j);
p22_secdforest_restore_pot(t,j)$(p22_secdforest_restore_pot(t,j) < 1e-6) = 0;
pm_land_conservation(t,j,"secdforest","restore")$(pm_land_conservation(t,j,"secdforest","restore") > p22_secdforest_restore_pot(t,j)) = p22_secdforest_restore_pot(t,j);

* Grassland restoration is limited by grassland restoration potential
p22_past_restore_pot(t,j) = sum(land, pcm_land(j, land))
              - pcm_land(j, "urban")
              - sum(land_timber, pcm_land(j, land_timber))
              - pm_land_conservation(t,j,"past","protect")
              - pm_land_conservation(t,j,"secdforest","restore")
              - vm_land.lo(j,"crop")
              - vm_treecover.l(j);
p22_past_restore_pot(t,j)$(p22_past_restore_pot(t,j) < 1e-6) = 0;
pm_land_conservation(t,j,"past","restore")$(pm_land_conservation(t,j,"past","restore") > p22_past_restore_pot(t,j)) = p22_past_restore_pot(t,j);

* Other land restoration is limited by other land restoration potential
p22_other_restore_pot(t,j) = sum(land, pcm_land(j, land))
               - pcm_land(j, "urban")
               - sum(land_timber, pcm_land(j, land_timber))
               - sum(consv_type, pm_land_conservation(t,j,"past",consv_type))
               - pm_land_conservation(t,j,"secdforest","restore")
               - vm_land.lo(j,"crop")
               - vm_treecover.l(j);
p22_other_restore_pot(t,j)$(p22_other_restore_pot(t,j) < 1e-6) = 0;
pm_land_conservation(t,j,"other","restore")$(pm_land_conservation(t,j,"other","restore") > p22_other_restore_pot(t,j)) = p22_other_restore_pot(t,j);

else

* set restoration to zero
pm_land_conservation(t,j,land,"restore") = 0;

);

* -------------------
* Reconversion
* -------------------
p22_reconv(t,j) = 0;
if(s22_reconversion = 1 AND m_year(t) > sm_fix_SSP2,
* Agricultural land still to be reconverted, limited by the agricultural land available.
* Targets above the available land of a cluster move to clusters of the same region; moved targets are kept.
p22_ag_cap(j) = max(0, pcm_land(j,"crop") - vm_land.lo(j,"crop") - vm_treecover.l(j) + pcm_land(j,"past") - pm_land_conservation(t,j,"past","protect"));
p22_ag_due(j) = i22_reconv_target(t,j,"ag") + p22_reconv_ag_add(j) - sum(land_reconv22, p22_reconv_done(j,land_reconv22));
p22_ag_gap(i) = max(0, sum(cell(i,j), i22_reconv_target(t,j,"ag") - sum(land_reconv22, p22_reconv_done(j,land_reconv22))
        - min(p22_ag_cap(j), p22_ag_due(j))));
p22_ag_spare(j) = max(0, p22_ag_cap(j) - p22_ag_due(j));
p22_ag_spare_reg(i) = sum(cell(i,j), p22_ag_spare(j));
p22_reconv_ag_add(j) = p22_reconv_ag_add(j) + p22_ag_spare(j)
        * sum(cell(i,j)$(p22_ag_spare_reg(i) > 0), min(1, p22_ag_gap(i) / p22_ag_spare_reg(i)));
p22_reconv(t,j) = min(p22_ag_cap(j), i22_reconv_target(t,j,"ag") + p22_reconv_ag_add(j) - sum(land_reconv22, p22_reconv_done(j,land_reconv22)));
p22_reconv(t,j)$(p22_reconv(t,j) < 1e-6) = 0;
* Reconverted other land that matured to secondary forest is tracked as secondary forest
p22_reconv_mature(j) = min(p22_reconv_done(j,"other"),
        max(0, pm_land_conservation(t,j,"other","protect") + p22_reconv_done(j,"other") - pcm_land(j,"other")));
p22_reconv_done(j,"other") = p22_reconv_done(j,"other") - p22_reconv_mature(j);
p22_reconv_done(j,"secdforest") = p22_reconv_done(j,"secdforest") + p22_reconv_mature(j);
* Reconverted land stays natural
pm_land_conservation(t,j,land_reconv22,"protect") =
        min(pcm_land(j,land_reconv22), pm_land_conservation(t,j,land_reconv22,"protect") + p22_reconv_done(j,land_reconv22));
* Managed forest is reconverted by protecting secondary forest, which excludes it from harvest.
* Targets above the unprotected secondary forest of a cluster move to clusters of the same region; moved targets are kept.
p22_forest_cap(j) = max(0, pcm_land(j,"secdforest") - pm_land_conservation(t,j,"secdforest","protect"));
p22_forest_gap(i) = max(0, sum(cell(i,j), i22_reconv_target(t,j,"forest")
        - min(p22_forest_cap(j), i22_reconv_target(t,j,"forest") + p22_reconv_forest_add(j))));
p22_forest_spare(j) = max(0, p22_forest_cap(j) - i22_reconv_target(t,j,"forest") - p22_reconv_forest_add(j));
p22_forest_spare_reg(i) = sum(cell(i,j), p22_forest_spare(j));
p22_reconv_forest_add(j) = p22_reconv_forest_add(j) + p22_forest_spare(j)
        * sum(cell(i,j)$(p22_forest_spare_reg(i) > 0), min(1, p22_forest_gap(i) / p22_forest_spare_reg(i)));
* Regional remainder, reported in the clusters that miss their own target
p22_forest_short(j) = max(0, i22_reconv_target(t,j,"forest") - p22_forest_cap(j));
p22_forest_short_reg(i) = sum(cell(i,j), p22_forest_short(j));
p22_reconv_shortfall(t,j,"forest") = p22_forest_short(j) * sum(cell(i,j)$(p22_forest_short_reg(i) > 0),
        max(0, p22_forest_gap(i) - p22_forest_spare_reg(i)) / p22_forest_short_reg(i));
p22_reconv_forest(t,j) = - pm_land_conservation(t,j,"secdforest","protect");
pm_land_conservation(t,j,"secdforest","protect") = min(pcm_land(j,"secdforest"),
        pm_land_conservation(t,j,"secdforest","protect") + i22_reconv_target(t,j,"forest") + p22_reconv_forest_add(j));
p22_reconv_forest(t,j) = p22_reconv_forest(t,j) + pm_land_conservation(t,j,"secdforest","protect");
);

if (m_year(t) >= s22_base_protect_reversal,
  pm_land_conservation(t,j,land,consv_type) = 0;
);


