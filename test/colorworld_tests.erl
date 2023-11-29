-module(colorworld_tests).

-include_lib("eunit/include/eunit.hrl").

colorworld_test() ->
    ok.

coloreurope_test() ->
    {_,Count,Colors} = colorworld:color_world(),
    if 
	(Count =/= 19) ->
	    throw({"number of countries do not match ww instead of 19."});
	(Colors =/= 4) ->
	    throw({"number of colors do not match ww instead of 4."});
	true ->
	    ok
    end.

gengraph_test() ->
    {CL,Count,_} = colorworld:color_world(gengraph:gen_graph(150,20)),
    if 
	is_list(CL) =/= true ->
	    throw({"Colortable, is no list."});
	Count < 15 ->
	    throw({"Only less then 15 vertices"});
	true ->
	    ok
    end.
