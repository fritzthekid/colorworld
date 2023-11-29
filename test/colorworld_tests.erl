-module(colorworld_tests).

-include_lib("eunit/include/eunit.hrl").

coloreurope_test() ->
    {_,Count,Colors} = colorworld:color_world(),
    ?assertEqual(19,Count),
    ?assertEqual(4,Colors).

gengraph_test() ->
    {CL,Count,_} = colorworld:color_world(gengraph:gen_graph(150,20)),
    ?assert(is_list(CL),"Colortable, is no a list."),
    ?assert(Count>15,"Only less then 15 vertices").


example_graph_test() ->
    {_,_,Exa1} = colorworld:color_world(planar:nonplanargraph()),
    ?assertEqual(3,Exa1,"planar:nonplanargraph"),
    {_,_,Exa2} = colorworld:color_world(planar:fourcolorsgraph()),
    ?assertEqual(4,Exa2,"planar:fourcolorsgraph"),
    {_,_,Exa3} = colorworld:color_world(planar:simple_fivecolor()),
    ?assertEqual(5,Exa3,"planar:simple_fivecolor"),
    {_,_,Exa4} = colorworld:color_world(planar:bipartite_graph()),
    ?assertEqual(3,Exa4,"planar:bipartite_graph"),
    {_,_,Exa5} = colorworld:color_world(planar:dice()),
    ?assertEqual(4,Exa5,"planar:dice").
