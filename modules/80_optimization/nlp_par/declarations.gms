*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

parameters
	p80_num_nonopt(t)		numNOpt indicator (1)
	p80_modelstat(t,i)             		"modelstat"
	p80_handle(i)						"parallel mode handle parameter"
	p80_repy(i,solveinfo80)  			"summary report from solver"
	p80_repyLastOptim(i,solveinfo80)	"objective value from last optimal solution"

;

scalars
  s80_counter       counter (1)
;
