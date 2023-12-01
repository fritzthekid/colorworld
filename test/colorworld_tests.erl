-module(colorworld_tests).

-include_lib("eunit/include/eunit.hrl").

coloreurope_test() ->
    {_,Count,Colors} = colorworld:color_world(),
    ?assertEqual(19,Count),
    ?assertEqual(4,Colors).

%% see neighbors should be [dk,tc,nl,po,fr,oe,lx,ch,bl]
colorworld_neighbor_test() ->
    N = cwgraph:neighbors("de",cwworld:world_graph()),
    ?assert(is_list(N),"should be list"),
    Expect = ["dk","tc","nl","po","fr","oe","lx","ch","bl"],
    lists:filter(fun(C) -> ?assert(lists:member(C,N)),true end, Expect).

colorworld_contry_test() ->
    CL = cwgraph:countries(cwworld:world_graph()),
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

%% cwutils_test() ->
%%     WGJ = cwgraph:neighbor_struct_to_graph(
%% 	   cwutils:neighbor_struct_from_json(filename:absname("") ++ "/data/world.json")),
%%     WGE = cwworld:world_graph(),
%%     Result = sets:from_list(cwgraph:neighbors("de",WGJ)) =:= 
%% 	sets:from_list(cwgraph:neighbors("de",WGE)),
%%     ?assert(Result).

cwworld_neighbors_unquoted_test() ->
    NU = cwgraph:neighbors(de,cwgraph:neighbor_struct_to_graph(cwworld:world_neighbors_unquoted())),
    NQ = cwgraph:neighbors("de",cwworld:world_graph()),
    Result = (length(NU) == length(NQ)),
    ?assert(Result).

cwutils_read_json_test() ->
    try
	cwutils:read_json("x.txt")
    catch
	_ ->
	    ok
    end.

cwutils_read_write_term_test() ->
    WN = cwworld:world_neighbors(),
    cwutils:write_terms("./test/output/x.txt",[WN]),
    Read = cwutils:neighbor_struct_import_config("./test/output/x.txt"),
    LN = cwgraph:neighbors("de",cwworld:world_graph()),
    LR = cwgraph:neighbors("de",cwgraph:neighbor_struct_to_graph(Read)),
    lists:filter(fun(A) -> ?assert(lists:member(A,LR)), true end, LN),
    ok.

cwutils_neighbor_struct_from_json_test() -> 
    NSR = cwgraph:neighbor_struct_to_graph(cwutils:neighbor_struct_from_json("data/world.json")),
    LN = cwgraph:neighbors("oe",cwworld:world_graph()),
    LR = cwgraph:neighbors("oe",NSR),
    lists:filter(fun(A) -> ?assert(lists:member(A,LR)), true end, LN),
    ok.
    
