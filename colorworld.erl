-module(colorworld).
-export([color_world/0, color_world/1]).

check_neighbors(D) ->
    C = dict:fetch_keys(D),
    lists:foldr(fun(CC, Acc) ->
		      L = dict:fetch(CC,D),
		      Acc + lists:foldr(fun(X,AccI) ->
						Len = length(lists:filter(fun(XX) -> XX =:= CC end, dict:fetch(X,D))),
						if Len > 0 -> 
							AccI;
						   true ->
							io:format("~w in ~w missmatch\n",[X,CC]),
							AccI+1
						end 
					end,
					0, L) 
		end, 0, C).
color_world() ->
    color_world(neighbor_dict()).
color_world(D) ->
    N = check_neighbors(D),
    if N =/= 0 ->
	    throw({"check_neighbors() failed.\n"});
       true ->
	    ok
    end,
    NDL = lists:sort(fun(A,B) -> length(element(2, A)) > length(element(2,B)) end,dict:to_list(D)),
    CC = element(1, hd(NDL)),
    color_world([{CC,0}],tl(NDL),D).
color_world(L,[],_) -> 
    {L, length(L), lists:foldr(fun(E,Acc) -> max(Acc,element(2,E)) end, 0, L)};
color_world(L,[H|T],D) ->
    CL = dict:fetch_keys(D),
    NC = firstnotusedcolor(L,neighbors(element(1,H),D),length(CL)),
    color_world(L++[{element(1,H),NC}],T,D).

firstnotusedcolor(L,Neighbors,N) ->
    ColorD = dict:from_list(L),
    ColoredNeighbors = lists:filter(fun(C) -> lists:member(C,dict:fetch_keys(ColorD)) end, Neighbors), 
    ColorsUsed = lists:foldr(fun(C, Acc) -> [dict:fetch(C,ColorD)]++Acc end, [], ColoredNeighbors),
    lists:min(lists:filter(fun(C) -> lists:member(C,ColorsUsed) =:= false end, lists:seq(1,N))).
	      
neighbor_dict() ->
    dict:from_list(world:neighbors()).

neighbors(C,D) ->
    dict:fetch(C,D).
