*** |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de
**************start solve loop**************

$ifthen "%c80_nlp_solver%" == "conopt3"
  option nlp        = conopt ;
$elseif "%c80_nlp_solver%" == "conopt4"
  option nlp        = conopt4;
$else
  abort "c80_nlp_solver setting not supported in nlp_apr17 realization!";
$endif

s80_counter = 0;
p80_modelstat(t,i) = 1;

*** solver settings

magpie.optfile   = s80_optfile ;
magpie.scaleopt  = 1 ;
magpie.solprint  = 0 ;
magpie.holdfixed = 1 ;

$onecho > conopt4.opt
Tol_Obj_Change = 3.0e-6
Tol_Feas_Min = 4.0e-7
Tol_Feas_Max = 4.0e-6
Tol_Feas_Tria = 4.0e-6
$offecho

*magpie.solvelink = 3;

i2(i) = no;
j2(j) = no;
i2("SSA") = yes;
j2(j) = yes$cell("SSA",j);
solve magpie USING nlp MINIMIZING vm_cost_glo ;
p80_handle("SSA") = magpie.handle;
i2(i) = no;
j2(j) = no;

$ontext
Repeat
  	loop(i$handlecollect(p80_handle(i)),
		i2(i) = yes;
		display i2;
		i2(i) = no;
		display magpie.modelstat;
		p80_modelstat(t,i) = magpie.modelstat;
		p80_repy(i,'solvestat') = magpie.solvestat;
		p80_repy(i,'modelstat') = magpie.modelstat;
		p80_repy(i,'resusd'   ) = magpie.resusd;
		p80_repy(i,'objval')    = magpie.objval;
                if(p80_repy(i,'modelstat') <= 2,
                    p80_repyLastOptim(i,'objval') = p80_repy(i,'objval');
                );
		if (magpie.modelstat <= 2 OR magpie.modelstat = 7,
		display$handledelete(p80_handle(i)) 'trouble deleting handles' ;
		p80_handle(i) = 0;
		else display$handleSubmit(p80_handle(i)) 'trouble resubmitting handles' ;
		);
	) ;
display$readyCollect(p80_handle) 'Problem waiting for next instance to complete';
*display$sleep(5) 'sleep some time';
until card(p80_handle) = 0;
$offtext
$ontext
magpie.solvelink = 3;
*start loop over Regions
loop(i,
	i2(i) = yes;
	j2(j) = yes$cell(i,j);
	solve magpie USING nlp MINIMIZING vm_cost_glo ;
	display j2;
	display i2;
	i2(i) = no;
	j2(j) = no;
	p80_handle(i) = magpie.handle;
);

Repeat
  	loop(i$handlecollect(p80_handle(i)),
		i2(i) = yes;
		display i2;
		i2(i) = no;
		display magpie.modelstat;
		p80_modelstat(t,i) = magpie.modelstat;
		p80_repy(i,'solvestat') = magpie.solvestat;
		p80_repy(i,'modelstat') = magpie.modelstat;
		p80_repy(i,'resusd'   ) = magpie.resusd;
		p80_repy(i,'objval')    = magpie.objval;
                if(p80_repy(i,'modelstat') <= 2,
                    p80_repyLastOptim(i,'objval') = p80_repy(i,'objval');
                );
		if (magpie.modelstat <= 2 OR magpie.modelstat = 7,
		display$handledelete(p80_handle(i)) 'trouble deleting handles' ;
		p80_handle(i) = 0;
		else display$handleSubmit(p80_handle(i)) 'trouble resubmitting handles' ;
		);
	) ;
display$readyCollect(p80_handle) 'Problem waiting for next instance to complete';
*display$sleep(5) 'sleep some time';
until card(p80_handle) = 0;
*reset to default for food demand model
i2(i) = yes;
j2(j) = yes;
	display j2;
	display i2;
magpie.solvelink = 0;
$offtext
***************end solve loop***************
