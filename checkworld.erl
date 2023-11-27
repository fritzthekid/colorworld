-module(checkworld).
-compile(export_all).

check_neighbors() ->
    D = neighbor_dict(),
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
    N = check_neighbors(),
    if N =/= 0 ->
	    throw({"check_neighbors() failed.\n"});
       true ->
	    ok
    end,
    NDL = lists:sort(fun(A,B) -> length(element(2, A)) > length(element(2,B)) end,world:neighbors()),
    CC = element(1, hd(NDL)),
    color_world([{CC,0}],tl(NDL),neighbor_dict()).
color_world(L,[],_) -> L;
color_world(L,[H|T],D) ->
    CL = dict:fetch_keys(D),
    N = length(CL),
    ColorD = dict:from_list(L),
    Neighbors = neighbors(element(1,H),D),
    ColoredNeighbors = lists:filter(fun(C) -> lists:member(C,dict:fetch_keys(ColorD)) end, Neighbors), 
    ColorsUsed = lists:foldr(fun(C, Acc) -> [dict:fetch(C,ColorD)]++Acc end, [], ColoredNeighbors),
    ColorsNotUsed = lists:filter(fun(C) -> lists:member(C,ColorsUsed) =:= false end, lists:seq(0,N)),
    NC = lists:min(ColorsNotUsed),
    color_world(L++[{element(1,H),NC}],T,D).

%% my_min(L) -> 
%%     lists:foldr(fun(E,Acc)-> min(E,Acc) end,hd(L), L).
%% my_max(L) -> 
%%     lists:foldr(fun(E,Acc)-> max(E,Acc) end,hd(L), L).

%% neighbor_dict_smallest() ->
%%     neighbor_dict_smallest(3).
%% neighbor_dict_smallest(M) ->
%%     neighbor_dict_smallest(length(world:countries()),M,neighbor_dict()).

%% neighbor_dict_smallest(0,_,D) -> D;
%% neighbor_dict_smallest(N,M,D) ->
%%     R = neighbor_dict_reduced(M,D),
%%     RL = length(dict:fetch_keys(R)),
%%     if 
%% 	N =:= RL ->
%% 	    D;
%% 	true ->
%% 	    neighbor_dict_smallest(RL,M,R)
%%     end.

%% neighbor_dict_reduced(N) ->
%%     L = lists:filter(fun(C) -> length(neighbors(C)) > N end, world:countries()),
%%     NL = lists:foldr(fun(C, Acc) -> Acc ++ [{C,neighbors(C)}] end, [], L),    
%%     dict:from_list(NL).

%% neighbor_dict_reduced(N,D) ->
%%     L = lists:filter(fun(C) -> length(dict:fetch(C,D)) > N end, dict:fetch_keys(D)),
%%     %%io:format("1: ~w\n",[L]),
%%     NL = lists:foldr(fun(C, Acc) -> 
%% 			     Acc ++ [{C,lists:filter(fun(CC) -> 
%% 							     ismember(CC,L) end, neighbors(C,D))}] end, [], L),
%%     dict:from_list(NL).
	
%% ismember(C,L) ->
%%     length(lists:filter(fun(X) -> C =:= X end, L)) > 0.

neighbor_dict() ->
    dict:from_list(world:neighbors()).
neighbor_dict(L,D) ->
    NL = lists:foldr(fun(X,Acc) -> Acc ++ [{X,neighbors(X,D)}] end, [], L),
    dict:from_list(NL).

isneighbor(CA,CB,D) ->
    lists:member(CA, neighbors(CB,D)).

neighbors(C) ->
    dict:fetch(C,neighbor_dict()).

neighbors(C,D) ->
    dict:fetch(C,D).
