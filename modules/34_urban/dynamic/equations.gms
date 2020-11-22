*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

$ontext
Urban land in the current time step (vm_land) is forced to the value from the previous 
time step (pcm_land) multiplied by 1 + population growth between these time steps.
$offtext

q34_urban(j2)..
 vm_land(j2,"urban") =e= 
 pcm_land(j2,"urban") * (1 + sum((ct,cell(i2,j2)), p34_pop_growth(ct,i2)) * m_timestep_length);
 