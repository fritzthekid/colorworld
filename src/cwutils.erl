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

neighbor_struct_import_config(Filename) ->
    {ok, [Data]} = file:consult(Filename),
    Data.

write_terms(Filename, List) ->
    Format = fun(Term) -> io_lib:format("~tp.~n", [Term]) end,
    Text = unicode:characters_to_binary(lists:map(Format, List)),
    file:write_file(Filename, Text).

neighbor_struct_from_json(Filename) ->
    {struct, L} = read_json(Filename),
    lists:foldr(fun({H,{array, T}},Acc) -> 
			Acc ++ [{H,T}] 
		end, 
		[],L).

%% write_json(Filename, Dict) ->
%%     TJ = mochistruct_from_dict(Dict),
%%     JB = mochijson2:encode(TJ),
%%     file:write_file(Filename, JB),
%%     io:format("write json: ~s, keys: ~w\n",[Filename, dict:fetch_keys(Dict)]).

%% neighbors_struct_export(Filename, Neighbors) ->
%%     MS = {stuct, lists:foldr(fun({H,T},Acc) -> [{H,{array,T}}] ++ Acc end, [], Neighbors)},
%%     JB = mochijson2:encode(MS),
%%     file:write_file(Filename, JB).
%%     %% io:format("write json: ~s, keys: ~w\n",[Filename, dict:fetch_keys(Dict)]).
    
%% mochistruct_from_dict(Dict) ->
%%     io:format("from_dict ~w  ~w\n",[dict:fetch_keys(Dict),dict:fetch(hd(dict:fetch_keys(Dict)),Dict)]),
%%     L = lists:foldr(fun(X,Acc) -> 
%% 			    IsdictEntry = isdictEntry(element(2,X)),
%% 			    IslistEntry = is_list(element(2,X)),
%% 			    if
%% 				IsdictEntry ->
%% 				    io:format("isdict; ~w\n",[element(2,X)]),
%% 				    Y= {element(1,X),mochistruct_from_dict(element(2,X))};
%% 				IslistEntry -> 
%% 				    Y = mochistruct_from_list(X);
%% 				true ->
%% 				    Y = X
%% 			    end,
%% 			    Acc++[Y] end, [], dict:to_list(Dict)),
%%     {struct, L}.

%% mochistruct_from_list({H,List}) ->
%%     L = lists:foldr(fun(X,Acc) -> 
%% 			    IsdictEntry = false,%%isdictEntry(element(2,X)),
%% 			    IslistEntry = false,%%is_list(element(2,X)), %listEntry(element(2,X)),
%% 			    if
%% 				IsdictEntry ->
%% 				    Y= {element(1,X),mochistruct_from_dict(dict:from_list([element(2,X)]))};
%% 				IslistEntry -> 
%% 				    Y = mochistruct_from_list(X);
%% 				true ->
%% 				    Y = X
%% 			    end,
%% 			    Acc++[Y] end, [], List),
%%     {H, {array, L}}.

%% isdictEntry(A) ->
%%     %% A = element(2,E),
%%     if
%% 	is_tuple(A) ->
%% 	    if 
%% 		element(1,A) =:=dict ->
%% 		    true;
%% 		true ->
%% 		    false
%% 	    end;
%% 	true ->
%% 	    false
%%     end.
%%     %% A = element(2,E),
%%     %% try dict:to_list(element(2,E)) of
%%     %% 	_ ->
%%     %% 	    true
%%     %% catch
%%     %% 	excetion:_Reason ->
%%     %% 	    false
%%     %% end.
%%     %% IsTuple = is_tuple(A),
%%     %% if 
%%     %% 	IsTuple ->
%%     %% 	    (is_list(element(1,A))) and (tuple_size(A) =:= 2);
%%     %% 	true ->
%%     %% 	    false
%%     %% end.

%% islistEntry(A) ->
%%     IsTuple = is_tuple(A),
%%     if 
%% 	IsTuple ->
%% 	    (is_list(element(1,A))) and (tuple_size(A) =:= 2);
%% 	true ->
%% 	    false
%%     end.
