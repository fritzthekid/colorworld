%% color some graph, if planar should be not more than 4 colors
%% color_world/0 colors only europe (from the graph in world.erl)
%% color_world/1 could be color_world(cwgraph:cwgraph(150,20)) - just random graph (not planar)
-module(colorworld).
-export([color_world/0, color_world/1]).
%% for eunit tests
-ifdef(EXPORTALL).
-compile(export_all).
-endif.

check_neighbors(WL) ->
    C = cwgraph:countries(WL),
    lists:foldr(fun(CC, Acc) ->
		      L = cwgraph:neighbors(CC,WL),
		      Acc + lists:foldr(fun(X,AccI) ->
						Len = length(lists:filter(fun(XX) -> XX =:= CC end, cwgraph:neighbors(X,WL))),
						if Len > 0 -> 
							AccI;
						   true ->
							io:format("~w in ~w missmatch\n",[X,CC]),
							AccI+1
						end 
					end,
					0, L) 
		end, 0, C).

%%% color_world assign color to every vertice (countries)

color_world() ->
    color_world(cwworld:world_graph()).
color_world(WL) ->
    N = check_neighbors(WL),
    if N =/= 0 ->
	    throw({"check_neighbors() failed.\n"});
       true ->
	    ok
    end,
    [{CC,_}|TL] = lists:sort(fun(A,B) -> length(element(2, A)) > length(element(2,B)) end,cwgraph:neighbor_struct(WL)),
    color_world([{CC,1}],TL,WL).
color_world(ColL,[],_) -> 
    {ColL, length(ColL), lists:foldr(fun(E,Acc) -> max(Acc,element(2,E)) end, 0, ColL)};
color_world(ColL,[H|T],WL) ->
    CL = cwgraph:countries(WL),
    NC = firstnotusedcolor(ColL,cwgraph:neighbors(element(1,H),WL),length(CL)),
    color_world(ColL++[{element(1,H),NC}],T,WL).

firstnotusedcolor(L,Neighbors,N) ->
    ColorD = dict:from_list(L),
    ColoredNeighbors = lists:filter(fun(C) -> lists:member(C,dict:fetch_keys(ColorD)) end, Neighbors), 
    ColorsUsed = lists:foldr(fun(C, Acc) -> [dict:fetch(C,ColorD)]++Acc end, [], ColoredNeighbors),
    lists:min(lists:filter(fun(C) -> lists:member(C,ColorsUsed) =:= false end, lists:seq(1,N))).
	      

