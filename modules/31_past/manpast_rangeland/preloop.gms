*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

v31_land.l(j,"manpast") = pcm_land(j,"past") * fm_luh2_side_layers(j,"manpast");
v31_land.l(j,"rangeland") = pcm_land(j,"past") * fm_luh2_side_layers(j,"rangeland");

*** EOF postsolve.gms ***
