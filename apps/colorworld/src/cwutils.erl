-module(cwutils).
-compile([export_all]).

read_json(Filename) ->
    try 
	{ok, JStr} = file:read_file(Filename),
	mochijson:decode(JStr)
    catch
	{_,_} ->
	    throw({"file not found."})
    end.

%% D = utils:read_json("/home/eduard/work/tmp/colorworld/world.json").
%%utils:neighbor_struct_from_json(dict:from_list(element(2,D))).

neighbor_struct_from_json(Filename) ->
    D = dict:from_list(element(2,read_json(Filename))),
    lists:foldr(fun(E,Acc) -> 
			Acc ++ [{element(1,E),element(2,element(2,E))}] 
		end, 
		[],dict:to_list(D)).

writepwd() ->
    io:format("dir: \"~s\"\n",[filename:absname(".")]).

test() ->
    {ok,D} = file:read_file("/home/eduard/work/tmp/colorworld/test.json"),
    L = dict:fetch_keys(utils:json_struct_to_dict(mochijson:decode(D))),
    io:format("T: ~w\n",[L]),
    lists:filter(fun(X) -> io:format("T1: ~s, ~w\n",[X,dict:fetch(X,D)]), true end, L).

json_list_to_list(L)->
    io:format("jltol ~w\n",[L]),
    lists:foldr(fun(X,Acc) ->
			io:format("jltol1: ~w\n",[X]),
			if 
			    is_list(X) ->
				O = json_list_to_list(X);
			    is_tuple(X) and element(1,X) =:= struct ->
				O = json_struct_to_dict(element(2,X));
			    true ->
				O = X
			end,
			Acc ++ [O] end, [], L).

json_struct_to_dict(S) ->
    io:format("jstod ~s\n",[element(1,S)]),
    if
	element(1,S) =:= struct -> 
	    dict:from_list(json_list_to_list(element(2,S)));
	element(1,S) =:= array ->
	    json_list_to_list(element(2,S));
	true ->
	    S
    end.
