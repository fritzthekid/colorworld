%% only part of europe
-module(world).
-export([neighbors/0, world_graph/0]).

neighbors() ->
    [{de,[dk,nl,bl,lx,fr,ch,oe,tc,po]},
     {fr,[de,bl,sp,it,ch,lx,v0]},
     {sp,[fr,pr,v0]},
     {pr,[sp,v0]},
     {it,[fr,ch,oe,ju,hu]},
     {ju,[it,hu,gr,bw]},
     {gr,[ju,bw]},
     {hu,[oe,it,sl,ju,bw]},
     {sl,[hu,tc,po,oe,bw]},
     {oe,[de,ch,it,hu,tc,sl]},
     {tc,[de,oe,sl,po]},
     {po,[de,tc,sl,bw]},
     {dk,[de]},
     {nl,[de,bl]},
     {bl,[de,nl,fr,lx,v0]},
     {lx,[de,bl,fr]},
     {ch,[de,fr,it,oe]},
     {v0,[pr,sp,fr,bl]},     %% virtual country 0
     {bw,[gr,ju,hu,sl,po]}   %% black world
    ].

world_graph() ->
    Graph = lists:foldr(fun(E,Acc) ->
			Acc++
			    lists:foldr(fun(N,Acc1) ->
						[{element(1,E),N}]++Acc1
					end, [], element(2,E))
			end, [], neighbors()),
    Sorted = lists:foldr(fun(E,Acc) ->
				 if 
				     element(1,E) < element(2,E) ->
					 Acc++[E];
				     true ->
					 Acc++[{element(2,E),element(1,E)}]
				 end
			 end, [], Graph),
    lists:sort(fun(A,B) -> element(1,A) < element(1,B) end, sets:to_list(sets:from_list(Sorted))).
