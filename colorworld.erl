%% color some graph, if planar should be not more than 4 colors
%% color_world/0 colors only europe (from the graph in world.erl)
%% color_world/1 could be color_world(gengraph:gengraph(150,20)) - just random graph (not planar)
-module(colorworld).
-export([color_world/0, color_world/1]).

check_neighbors(WL) ->
    C = countries(WL),
    lists:foldr(fun(CC, Acc) ->
		      L = neighbors(CC,WL),
		      Acc + lists:foldr(fun(X,AccI) ->
						Len = length(lists:filter(fun(XX) -> XX =:= CC end, neighbors(X,WL))),
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
    color_world(world:world_graph()).
color_world(WL) ->
    N = check_neighbors(WL),
    if N =/= 0 ->
	    throw({"check_neighbors() failed.\n"});
       true ->
	    ok
    end,
    [{CC,_}|TL] = lists:sort(fun(A,B) -> length(element(2, A)) > length(element(2,B)) end,neighbor_struct(WL)),
    color_world([{CC,1}],TL,WL).
color_world(ColL,[],_) -> 
    {ColL, length(ColL), lists:foldr(fun(E,Acc) -> max(Acc,element(2,E)) end, 0, ColL)};
color_world(ColL,[H|T],WL) ->
    CL = countries(WL),
    NC = firstnotusedcolor(ColL,neighbors(element(1,H),WL),length(CL)),
    color_world(ColL++[{element(1,H),NC}],T,WL).

firstnotusedcolor(L,Neighbors,N) ->
    ColorD = dict:from_list(L),
    ColoredNeighbors = lists:filter(fun(C) -> lists:member(C,dict:fetch_keys(ColorD)) end, Neighbors), 
    ColorsUsed = lists:foldr(fun(C, Acc) -> [dict:fetch(C,ColorD)]++Acc end, [], ColoredNeighbors),
    lists:min(lists:filter(fun(C) -> lists:member(C,ColorsUsed) =:= false end, lists:seq(1,N))).
	      
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

