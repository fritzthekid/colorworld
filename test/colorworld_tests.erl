-module(colorworld_tests).

-include_lib("eunit/include/eunit.hrl").

coloreurope_test() ->
    {_,Count,Colors} = colorworld:color_world(),
    ?assertEqual(19,Count),
    ?assertEqual(4,Colors).

%% see neighbors should be [dk,tc,nl,po,fr,oe,lx,ch,bl]
colorworld_neighbor_test() ->
    N = colorworld:neighbors("de",cwworld:world_graph()),
    ?assert(is_list(N),"should be list"),
    Expect = ["dk","tc","nl","po","fr","oe","lx","ch","bl"],
    lists:filter(fun(C) -> ?assert(lists:member(C,N)),true end, Expect).

colorworld_contry_test() ->
    CL = colorworld:countries(cwworld:world_graph()),
    Expect = ["sp","v0","pr","gr","fr","tc","it","oe","ju","hu","de","bw","lx","ch","dk","sl","nl","bl","po"],
    ?assert(is_list(CL), "countries is list."),
    ?assertEqual(length(Expect),length(CL), "identical length."),
    lists:filter(fun(C) -> ?assert(lists:member(C,CL)),true end, Expect).

colorworld_gengraph_test() ->
    {CL,Count,_} = colorworld:color_world(cwgraph:gen_graph(150,20)),
    ?assert(is_list(CL),"Colortable, is no a list."),
    ?assert(Count>15,"Only less then 15 vertices").

colorworld_example_graph_test() ->
    {_,_,Exa1} = colorworld:color_world(cwplanar:nonplanargraph()),
    ?assertEqual(3,Exa1,"planar:nonplanargraph"),
    {_,_,Exa2} = colorworld:color_world(cwplanar:fourcolorsgraph()),
    ?assertEqual(4,Exa2,"planar:fourcolorsgraph"),
    {_,_,Exa3} = colorworld:color_world(cwplanar:simple_fivecolor()),
    ?assertEqual(5,Exa3,"planar:simple_fivecolor"),
    {_,_,Exa4} = colorworld:color_world(cwplanar:bipartite_graph()),
    ?assertEqual(3,Exa4,"planar:bipartite_graph"),
    {_,_,Exa5} = colorworld:color_world(cwplanar:dice()),
    ?assertEqual(4,Exa5,"planar:dice").
