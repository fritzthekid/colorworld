-module(world).
-export([countries/0, neighbors/0]).

countries() ->
    [de,fr,sp,pr,it,ju,gr,hu,sl,oe,tc,po,dk,nl,bl,lx,ch,oz].

neighbors() ->
    [{de,[dk,nl,bl,lx,fr,ch,oe,tc,po,oz]},
     {fr,[de,bl,sp,it,ch,lx,oz]},
     {sp,[fr,pr,oz]},
     {pr,[sp,oz]},
     {it,[fr,ch,oe,ju,hu,oz]},
     {ju,[it,hu,gr,oz]},
     {gr,[ju,oz]},
     {hu,[oe,it,sl,ju,oz]},
     {sl,[hu,tc,po,oe,oz]},
     {oe,[de,ch,it,hu,tc,sl]},
     {tc,[de,oe,sl,po]},
     {po,[de,tc,sl,oz]},
     {dk,[de,oz]},
     {nl,[de,bl,oz]},
     {bl,[de,nl,fr,lx,oz]},
     {lx,[de,bl,fr]},
     {ch,[de,fr,it,oe]},
     {oz,[de,nl,bl,fr,sp,po,it,ju,gr,hu,sl,pr,dk]}
    ].

