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

%% From: https://stackoverflow.com/questions/44629823/how-to-apply-timeout-on-method-in-erlang  
tear_down(PIDL, Name, MasterPID)->
  YourTimeOut = 10,
  Self = self(),
  _Pid = spawn(fun()-> 
		       timer:sleep(2000),
		       io:format("hello ~p!~n",[Name]),
		       finalizer(PIDL),
		       Self ! {self(), ok}, MasterPID ! {tear_down, "fun stopped"} end),
  receive
    {_PidSpawned, ok} ->
	  io:format("hello world ~p!~n",[Name]),
	  ok
  after
      YourTimeOut -> 
	  io:format("hello after ~p!~n",[Name]),
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
-endif.
