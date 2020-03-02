if (s21_walras_auction = 1,
pc21_trade_surplus_shr(k_trade) = 0;
pc21_trade_surplus_shr(k_trade)$(sum(i, vm_prod_reg.l(i,k_trade) > 0)) = 
					sum(i, v21_trade_flows.l(i,k_trade))/
					sum(i, vm_prod_reg.l(i,k_trade));
pc21_trade_surplus_shr("scp") = 0;

s21_counter = 0;

*while(smax(k_trade,abs(pc21_trade_surplus_shr(k_trade))) > 0.05,
repeat
s21_counter = s21_counter + 1;
pc21_prices(k_trade) = pc21_prices(k_trade)*min(1.2, max(0.8, 1 - 0.5*pc21_trade_surplus_shr(k_trade)));
pc21_trade_surplus_glo(k_trade) = sum(i, v21_trade_flows.l(i,k_trade));

display "walras auction";
display pc21_trade_surplus_shr;
display pc21_prices;
display pc21_trade_surplus_glo;

i2(i) = no;
j2(j) = no;
magpie.solvelink = 3;
*start loop over Regions
loop(i,
	i2(i) = yes;
	j2(j) = yes$cell(i,j);
	solve magpie USING nlp MINIMIZING vm_cost_glo ;
	i2(i) = no;
	j2(j) = no;
	p21_handle(i) = magpie.handle;
);

Repeat
  	loop(i$handlecollect(p21_handle(i)),
		p21_modelstat(t,i) = magpie.modelstat;
		p21_repy(i,'solvestat') = magpie.solvestat;
		p21_repy(i,'modelstat') = magpie.modelstat;
		p21_repy(i,'resusd'   ) = magpie.resusd;
		p21_repy(i,'objval')    = magpie.objval;
                if(p21_repy(i,'modelstat') eq 2,
                    p21_repyLastOptim(i,'objval') = p21_repy(i,'objval');
                );
		display$handledelete(p21_handle(i)) 'trouble deleting handles' ;
		p21_handle(i) = 0
	) ;
display$sleep(5) 'sleep some time';
until card(p21_handle) = 0;
i2(i) = yes;
j2(j) = yes;

pc21_trade_surplus_shr(k_trade)$(sum(i, vm_prod_reg.l(i,k_trade) > 0)) = 
					sum(i, v21_trade_flows.l(i,k_trade))/
					sum(i, vm_prod_reg.l(i,k_trade));
pc21_trade_surplus_shr("scp") = 0;
until smax(k_trade,abs(pc21_trade_surplus_glo(k_trade))) = 0 OR s21_counter = 100;

*);
);
