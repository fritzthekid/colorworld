-module(procutils).
-compile(export_all).

killme(PID,Timeout) ->
    timer:sleep(Timeout),
    PID ! killme.

timeouttest_proc(Wait) ->
    YourTimeOut=Wait,
    io:format("~p~n",[self()]),
    receive
        killme ->
            io:format("proc received killme~n",[]),
	    {ok,killme}
    after
	YourTimeOut ->
	    io:format("timeouttest_proc YourTimeOut~n",[]),
	    {error,timeout}
    end.
	
-ifdef(REBARTEST).
-include_lib("eunit/include/eunit.hrl").
timeout_test() ->
    timeouttest_proc(10),
    PID = spawn(procutils,timeouttest_proc,[10000]),
    killme(PID,10).
-endif.
