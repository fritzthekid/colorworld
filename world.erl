-module(world).
-export([neighbors/0]).

neighbors() ->
    [{de,[dk,nl,bl,lx,fr,ch,oe,tc,po,oz]},
     {fr,[de,bl,sp,it,ch,lx,oz,v0]},
     {sp,[fr,pr,oz,v0]},
     {pr,[sp,oz,v0]},
     {it,[fr,ch,oe,ju,hu,oz]},
     {ju,[it,hu,gr,oz,bw]},
     {gr,[ju,oz,bw]},
     {hu,[oe,it,sl,ju,bw]},
     {sl,[hu,tc,po,oe,bw]},
     {oe,[de,ch,it,hu,tc,sl]},
     {tc,[de,oe,sl,po]},
     {po,[de,tc,sl,oz,bw]},
     {dk,[de,oz]},
     {nl,[de,bl,oz]},
     {bl,[de,nl,fr,lx,v0,oz]},
     {lx,[de,bl,fr]},
     {ch,[de,fr,it,oe]},
     {v0,[pr,sp,fr,bl,oz]},     %% virtual country 0
     {bw,[gr,ju,hu,sl,po,oz]},  %% black world
     {oz,[de,nl,bl,fr,sp,po,it,ju,gr,pr,dk,v0,bw]}
    ].

