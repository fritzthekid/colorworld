-module(gengraph).
-export([gen_graph/2]).

%% generates some random graph, could be of any shape - not planar
%% arguments:
%%   N: number of raw elements (double and symetrical will be removed)
%%   M: number of vertices
gen_graph(N,M) ->
    LL = lists:foldr(fun(_,Acc) -> [{rand:uniform(M),rand:uniform(M)}]++Acc end, [], lists:seq(1,N)), 
    Orderd = lists:foldr(fun(E,Acc) -> 
				 [if 
				      element(1,E) < element(2,E) -> 
					  E; 
				      true -> 
					  {element(2,E),element(1,E)}
				  end] ++ Acc 
			 end, 
			 [],LL),
    NewOrderd = sets:to_list(sets:from_list(Orderd)),
    SinIdents = lists:filter(fun(E)->element(1,E) =/= element(2,E) end, NewOrderd),
    Sorted = lists:sort(fun(A,B) -> element(1,A) < element(1,B) end, SinIdents),
    Renamed = lists:foldr(fun(E,Acc) -> 
				  [{{v,element(1,E)},{v,element(2,E)}}]
				      ++ Acc
			  end, [], Sorted),
    Renamed.
