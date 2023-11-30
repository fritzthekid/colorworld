-module(planar).
-compile(export_all).

%% https://math.stackexchange.com/questions/3727153/prove-this-graph-is-not-planar
nonplanargraph() ->
    [{a,b},{b,c},{c,d},{d,e},{e,f},{f,g},{g,h},{h,i},{i,j},{j,k},{k,l},{l,m},{m,n},{n,a},
     {i,d},{h,m},{f,k}].

%% non planar and 4 colors
fourcolorsgraph() ->
    [{a,b},{b,c},{c,d},{d,e},{e,f},{f,g},{g,h},{h,i},{i,j},{j,k},{k,l},{l,m},{m,n},{n,a},
     {a,j},{b,g},{f,k},{h,m},
     {a,c},{a,d},{b,d}
    ].

%% five planes (edges) five colors
simple_fivecolor() ->
    [{a,b},{b,c},{c,d},{d,e},
     {a,c},{a,d},{a,e},
     {b,d},{b,e},
     {c,e}
    ].

bipartite_graph() ->
    [{b,a},{b,c},{b,f},{e,a},{e,d},{d,c},{e,g},{f,h},{h,a},{g,c},{g,f}].

%% dice with extension (non planar - four colors)
dice() ->
    [{u,a},{u,b},{u,c},{u,d},
     {a,b},{b,c},{c,d},{d,a},
     {o,a},{o,b},{o,c},{o,d},
     {a,c}
    ].
