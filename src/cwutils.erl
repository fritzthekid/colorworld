-module(cwutils).
-compile([export_all]).

read_json(Filename) ->
    {Ret, JStr} = file:read_file(Filename),
    if 
	Ret == ok ->
	    try
		mochijson_to_term(mochijson:decode(JStr))
	    catch error:_ ->
		    throw({"file is not a json file."})
	    end;
	true ->
	    throw({"file not found."})
    end.

neighbor_struct_import_config(Filename) ->
    {ok, [Data]} = file:consult(Filename),
    Data.

%% From: (opposite to file:consult) https://zxq9.com/archives/1021
write_terms(Filename, List) ->
    Format = fun(Term) -> io_lib:format("~tp.~n", [Term]) end,
    Text = unicode:characters_to_binary(lists:map(Format, List)),
    file:write_file(Filename, Text).

neighbor_struct_from_json(Filename) ->
    Map = read_json(Filename),
    maps:fold(fun(K,V,AccIn)->AccIn ++[{K,V}] end, [],Map).

mochijson_to_term(Obj) ->
    Isstr = ismochistruct(Obj),
    Isarr = ismochiarray(Obj),
    if
	Isstr ->
	    {_,T} = Obj,
	    mochistruct_to_map(T);
	Isarr ->
	    {_,T} = Obj,
	    mochiarray_to_list(T);
	%%is_list(Obj) ->
	%%    lists:foldr(fun(E,Acc)->Acc++[mochijson_to_term(E)] end, [], Obj);
	true ->
	    Obj
    end.

mochistruct_to_map(L) ->
    maps:from_list(lists:foldl(fun({H,T},Acc)->Acc++[{H,mochijson_to_term(T)}] end,[], L)).

mochiarray_to_list(L) ->
    lists:foldl(fun(E,Acc)->Acc++[mochijson_to_term(E)] end,[], L).

ismochistruct(Obj) ->
    if 
	is_tuple(Obj) ->
	    if
		(tuple_size(Obj) =:= 2) ->
		    {H,L} = Obj, 
		    (H =:= struct) and is_list(L);
		true ->
		    false
	    end;
	true ->
	    false
    end.

ismochiarray(Obj) ->
    if 
	is_tuple(Obj) ->
	    if
		(tuple_size(Obj) =:= 2) ->
		    {H,L} = Obj, 
		    (H =:= array) and is_list(L);
		true ->
		    false
	    end;
	true ->
	    false
    end.

-ifdef(REBARTEST).
-include_lib("eunit/include/eunit.hrl").
cwutils_isstruct_isarry_test() ->
    ?assert((false==ismochistruct({1}))),
    ?assert((false==ismochistruct(1))),
    ?assert((ismochistruct({struct,[]}))),
    ?assert((false==ismochiarray({1}))),    
    ?assert((false==ismochiarray(1))),
    ?assert(false),
    ?assert(ismochiarray({array,[]})).
-endif.
