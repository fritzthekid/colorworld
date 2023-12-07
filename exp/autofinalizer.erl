-module(autofinalizer).
-compile(export_all).

start() ->
    start(6,2000).
start(Num, Wait) ->
    PIDL = lists:foldl(fun(N,Acc) -> PID=spawn(autofinalizer, tail, [N,Wait]), Acc++[PID] end, [], lists:seq(1,Num)), 
    spawn(autofinalizer, tear_down, [PIDL,"fritz",self()]),
    receive
	{ tear_down, Msg } ->
	    io:format("tear_down stopped: ~s\n",[Msg]),
	    ok	
    end.

tear_down(PIDL, Name, MasterPID)->
    YourTimeOut = 1000,
    receive
	killme ->
	    io:format("received killme ~p!~n",[Name]),
	    ok
    after
	YourTimeOut -> 
	    finalizer(PIDL),
	    io:format("timeout ~p!~n",[Name]),
	    MasterPID ! { tear_down, "got timeout"},
	    timout
    end.

finalizer(PIDL) ->
    lists:filter(fun(PID) -> PID ! finished,true end, PIDL).

tail(_N, _M) ->
    receive
	finished ->
	    Wait = round(_M*rand:uniform()),
	    timer:sleep(Wait),
	    %%io:format("tail finished ~w (~w)~n", [_N,Wait]),
	    ok;
	{tear_down, _} ->
	    io:format("tail does something~n", []),
	    ok
    end.

-ifdef(REBARTEST).
-include_lib("eunit/include/eunit.hrl").
start_test() ->
    ok = start(1,0).
teardown_test() ->
    P=spawn(lists,seq,[1,6]),
    tear_down([],"fritz",P),
    LPID = spawn(autofinalizer,tear_down,[[],"fritz",P]),
    procutils:killme(LPID,10).
tail_test() ->
    LPID=spawn(autofinalizer,tail,[3,10]),
    LPID!{tear_down,ok}.
-endif.
