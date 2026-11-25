*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

scalars
 s22_shift number of 5-year age-classes corresponding to current time step length (1)
;

parameters
 p22_wdpa_baseline(t,j,base22,land)                 Baseline protection (mio. ha)
 p22_conservation_area(t,j,land)                    Total land conservation area for all land types (mio. ha)
 pm_land_conservation(t,j,land,consv_type)          Land protection and restoration for all land types (mio. ha)
 p22_conservation_fader(t_all)                      Land conservation fader (1)
 p22_add_consv(t,j,consv22_all,land)                Additional land conservation in conservation priority areas (mio. ha)
 p22_secdforest_restore_pot(t,j)                    Potential secondary forest restoration area (mio. ha)
 p22_past_restore_pot(t,j)                          Potential pasture restoration area (mio. ha)
 p22_other_restore_pot(t,j)                         Potential other land restoration area (mio. ha)
 p22_country_weight(i)                              Land conservation country weight per region (1)
 p22_country_switch(iso)                             Switch indicating whether country is affected by selected land conservation policy (1)
 i22_land_iso(iso)                                  Total land area at ISO level (mio. ha)
 p22_reconv_fader1(t_all)                           Linear fader towards first reconversion milestone (1)
 p22_reconv_fader2(t_all)                           Linear fader towards second reconversion milestone (1)
 i22_reconv_target(t,j,reconv_pool22)               Cumulative reconversion target (mio. ha)
 p22_reconv(t,j)                                    Agricultural land to be reconverted in current time step (mio. ha)
 p22_reconv_done(j,land_reconv22)                   Cumulative reconversion of agricultural land since start year (mio. ha)
 p22_reconv_net_shr(j)                              Share of reconversion not offset by conversion of natural vegetation (1)
 pm_land_reconv(j)                                  Protected reconverted agricultural land (mio. ha)
 p22_reconv_shortfall(t,j,reconv_pool22)            Cumulative reconversion target not met (mio. ha)
 p22_forest_cap(j)                                  Secondary forest available for managed forest reconversion (mio. ha)
 p22_forest_spare(j)                                Secondary forest available beyond the cluster target (mio. ha)
 p22_forest_short(j)                                Managed forest target exceeding available secondary forest (mio. ha)
 p22_forest_gap(i)                                  Regional managed forest target not met in its own clusters (mio. ha)
 p22_forest_spare_reg(i)                            Regional secondary forest available beyond the cluster targets (mio. ha)
 p22_forest_short_reg(i)                            Regional sum of managed forest targets exceeding available secondary forest (mio. ha)
 p22_reconv_forest_add(j)                           Managed forest target moved from other clusters of the region (mio. ha)
;

equations
 q22_reconversion(j)                                Minimum reconversion of agricultural land (mio. ha)
 q22_reconversion_stock(j)                          Minimum growth of natural vegetation under reconversion (mio. ha)
;

*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 oq22_reconversion(t,j,type) Minimum reconversion of agricultural land (mio. ha)
 oq22_reconversion_stock(t,j,type) Minimum growth of natural vegetation under reconversion (mio. ha)
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################

