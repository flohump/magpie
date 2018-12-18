*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

vm_land.l(j,land) = pcm_land(j,land);
v10_lu_transitions.fx(j,"forestry",land_to10) = 0;
v10_lu_transitions.up(j,"forestry","forestry") = Inf;
v10_lu_transitions.fx(j,land_from10,"primforest") = 0;
*v10_lu_transitions.up(j,"primforest","primforest")$(pcm_land(j,"primforest") > 0) = Inf;
v10_lu_transitions.up(j,"primforest","primforest") = Inf;
*v10_lu_transitions.fx(j,land_from10,"secdforest") = 0;
*v10_lu_transitions.up(j,"secdforest","secdforest") = Inf;
v10_lu_transitions.fx(j,land_from10,"urban") = 0;
v10_lu_transitions.fx(j,"urban",land_to10) = 0;
v10_lu_transitions.fx(j,"urban","urban") = pcm_land(j,"urban");
