*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de


v20_dem_processing.fx(i,processing_subst20,knpr)=0;
v20_dem_processing.up(i,"substitutes","scp")=Inf;

v20_processing_shares.fx(i,ksd,kpr)=f20_processing_shares(t,i,ksd,kpr);
v20_processing_shares.fx(i,"scp",kpr)=0;
$ifThen "%c20_scp%" == "off"
	v20_processing_shares.fx(i,"scp",kpr)=0;
$elseIf "%c20_scp%" == "begr"
	v20_processing_shares.fx(i,"scp","begr")=1;
$elseIf "%c20_scp%" == "sugar"
	v20_processing_shares.fx(i,"scp","sugr_cane")=1;
$elseIf "%c20_scp%" == "mixed_fixed",
	v20_processing_shares.fx(i,"scp","begr")=0.5;
	v20_processing_shares.fx(i,"scp","sugr_cane")=0.5;
$elseIf "%c20_scp%" == "mixed_free"
	v20_processing_shares.lo(i,"scp","begr")=0;
	v20_processing_shares.up(i,"scp","begr")=Inf;
	v20_processing_shares.lo(i,"scp","sugr_cane")=0;
	v20_processing_shares.up(i,"scp","sugr_cane")=Inf;	
$endif


vm_dem_processing.fx(i,knpr)=0;

vm_secondary_overproduction.fx(i2,kall,kpr)=0;
vm_secondary_overproduction.up(i2,ksd,kpr)=Inf;

v20_secondary_substitutes.fx(i2,ksd,kpr)=0;
v20_secondary_substitutes.up(i2,"oils",kpr)=Inf;
v20_secondary_substitutes.up(i2,"molasses",kpr)=Inf;
v20_secondary_substitutes.up(i2,"distillers_grain",kpr)=Inf;
v20_secondary_substitutes.up(i2,"oilcakes",kpr)=Inf;
v20_secondary_substitutes.up(i2,"brans",kcereals20)=Inf;
