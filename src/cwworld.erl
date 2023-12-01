%% only part of europe
-module(cwworld).
-export([world_neighbors/0, world_neighbors_unquoted/0, world_neighbors_quoted/0 ,world_graph/0]).
%% for eunit tests
-ifdef(EXPORTALL).
-compile(export_all).
-endif.

world_neighbors() ->
    world_neighbors_quoted().
world_neighbors_unquoted() ->
    [{de,[dk,nl,bl,lx,fr,ch,oe,tc,po]},
     {fr,[de,bl,sp,it,ch,lx,v0]},
     {sp,[fr,pr,v0]},
     {pr,[sp,v0]},
     {it,[fr,ch,oe,ju,hu]},
     {ju,[it,hu,gr,bw]},
     {gr,[ju,bw]},
     {hu,[oe,it,sl,ju,bw]},
     {sl,[hu,tc,po,oe,bw]},
     {oe,[de,ch,it,hu,tc,sl]},
     {tc,[de,oe,sl,po]},
     {po,[de,tc,sl,bw]},
     {dk,[de]},
     {nl,[de,bl]},
     {bl,[de,nl,fr,lx,v0]},
     {lx,[de,bl,fr]},
     {ch,[de,fr,it,oe]},
     {v0,[pr,sp,fr,bl]},     %% virtual country 0
     {bw,[gr,ju,hu,sl,po]}   %% black world
    ].

world_graph() ->
    cwgraph:neighbor_struct_to_graph(world_neighbors()).

world_neighbors_quoted() -> 
    [{"de",["dk","nl","bl","lx","fr","ch","oe","tc","po"]},
     {"fr",["de","bl","sp","it","ch","lx","v0"]},
     {"sp",["fr","pr","v0"]},
     {"pr",["sp","v0"]},
     {"it",["fr","ch","oe","ju","hu"]},
     {"ju",["it","hu","gr","bw"]},
     {"gr",["ju","bw"]},
     {"hu",["oe","it","sl","ju","bw"]},
     {"sl",["hu","tc","po","oe","bw"]},
     {"oe",["de","ch","it","hu","tc","sl"]},
     {"tc",["de","oe","sl","po"]},
     {"po",["de","tc","sl","bw"]},
     {"dk",["de"]},
     {"nl",["de","bl"]},
     {"bl",["de","nl","fr","lx","v0"]},
     {"lx",["de","bl","fr"]},
     {"ch",["de","fr","it","oe"]},
     {"v0",["pr","sp","fr","bl"]},     %% virtual country 0
     {"bw",["gr","ju","hu","sl","po"]}   %% black world
    ].
