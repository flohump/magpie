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
 p22_reconv_booked(j)                               Reconversion counted in the current time step (mio. ha)
 p22_reconv_grow(j,land_reconv22)                   Net growth of natural land pools receiving reconversion (mio. ha)
 p22_reconv_mature(j)                               Reconverted other land matured to secondary forest (mio. ha)
 pm_land_reconv(j)                                  Protected reconverted agricultural land (mio. ha)
 p22_reconv_shortfall(t,j,reconv_pool22)            Cumulative reconversion target not met (mio. ha)
 p22_wdpa_secdforest(t,j)                           Secondary forest protected by the WDPA baseline (mio. ha)
 p22_forest_base(j)                                 Secondary forest protected by WDPA or as reconverted agricultural land (mio. ha)
 p22_consv_cap(j)                                   Secondary forest protected by the conservation layer (mio. ha)
 p22_consv_gap(i)                                   Regional managed forest target in the conservation layer not met in its own clusters (mio. ha)
 p22_consv_spare(j)                                 Conservation-layer secondary forest beyond the cluster target (mio. ha)
 p22_consv_spare_reg(i)                             Regional conservation-layer secondary forest beyond the cluster targets (mio. ha)
 p22_forest_cap(j)                                  Secondary forest available for managed forest reconversion (mio. ha)
 p22_forest_spare(j)                                Secondary forest available beyond the cluster target (mio. ha)
 p22_forest_short(j)                                Managed forest target exceeding available secondary forest (mio. ha)
 p22_forest_gap(i)                                  Regional managed forest target not met in its own clusters (mio. ha)
 p22_forest_spare_reg(i)                            Regional secondary forest available beyond the cluster targets (mio. ha)
 p22_forest_short_reg(i)                            Regional sum of managed forest targets exceeding available secondary forest (mio. ha)
 p22_reconv_forest_add(j)                           Managed forest target moved from other clusters of the region (mio. ha)
 p22_reconv_forest(t,j)                             Secondary forest protected as reconverted managed forest incl. conservation layer (mio. ha)
 p22_ag_cap(j)                                      Agricultural land available for reconversion (mio. ha)
 p22_ag_due(j)                                      Agricultural land still to be reconverted incl. moved targets (mio. ha)
 p22_ag_spare(j)                                    Agricultural land available beyond the reconversion due (mio. ha)
 p22_ag_gap(i)                                      Regional agricultural land target not met in its own clusters (mio. ha)
 p22_ag_spare_reg(i)                                Regional agricultural land available beyond the reconversion due (mio. ha)
 p22_reconv_ag_add(j)                               Agricultural land target moved from other clusters of the region (mio. ha)
 p22_ag_short(j)                                    Agricultural land target not met in its own cluster (mio. ha)
 p22_ag_short_reg(i)                                Regional sum of agricultural land targets not met in their own clusters (mio. ha)
 p22_ag_over_reg(i)                                 Regional reconversion beyond the own cluster targets (mio. ha)
;

equations
 q22_reconversion(j)                                Minimum growth of natural vegetation under reconversion (mio. ha)
 q22_reconversion_ag(j)                             Minimum decline of agricultural land under reconversion (mio. ha)
;

*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 oq22_reconversion(t,j,type) Minimum growth of natural vegetation under reconversion (mio. ha)
 oq22_reconversion_ag(t,j,type) Minimum decline of agricultural land under reconversion (mio. ha)
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################

