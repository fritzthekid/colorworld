-module(cwgraph).
-export([gen_graph/2, countries/1, neighbors/2, neighbor_struct_to_graph/1, neighbor_struct/1]).

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
    %% Renamed = lists:foldr(fun(E,Acc) -> 
    %% 				  [{{v,element(1,E)},{v,element(2,E)}}]
    %% 				      ++ Acc
    %% 			  end, [], Sorted),
    Renamed = lists:foldr(fun(E,Acc) -> 
				  V1="v"++integer_to_list(element(1,E)),
				  V2="v"++integer_to_list(element(2,E)),
				  [{V1,V2}] ++ Acc
			  end, [], Sorted),
    Renamed.

neighbors(C,L) ->
    lists:foldr(fun(E,Acc) ->
			 if 
			     element(1,E) =:= C ->
				 Acc ++ [element(2,E)];
			     element(2,E) =:= C ->
				 Acc ++ [element(1,E)];
			     true ->
				 Acc
			 end
		end, [], L).

countries(L) ->
    R = lists:foldr(fun(E,Acc) ->  Acc ++ [element(1,E), element(2,E)] end, [], L),
    sets:to_list(sets:from_list(R)).

neighbor_struct(WL) ->
    lists:foldr(fun(C, Acc) -> Acc ++ [{C,neighbors(C,WL)}] end,[],countries(WL)).

neighbor_struct_to_graph(NeighborStruct) ->
    Graph = lists:foldr(fun(E,Acc) ->
			Acc++
			    lists:foldr(fun(N,Acc1) ->
						[{element(1,E),N}]++Acc1
					end, [], element(2,E))
			end, [], NeighborStruct),
    Sorted = lists:foldr(fun(E,Acc) ->
				 if 
				     element(1,E) < element(2,E) ->
					 Acc++[E];
				     true ->
					 Acc++[{element(2,E),element(1,E)}]
				 end
			 end, [], Graph),
    lists:sort(fun(A,B) -> element(1,A) < element(1,B) end, sets:to_list(sets:from_list(Sorted))).

