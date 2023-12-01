-module(cwutils).
-compile([export_all]).

read_json(Filename) ->
    {Ret, JStr} = file:read_file(Filename),
    if 
	Ret == ok ->
	    mochijson:decode(JStr);
	true ->
	    throw({"file not found."})
    end.

neighbor_struct_from_json(Filename) ->
    D = dict:from_list(element(2,read_json(Filename))),
    lists:foldr(fun(E,Acc) -> 
			Acc ++ [{element(1,E),element(2,element(2,E))}] 
		end, 
		[],dict:to_list(D)).
