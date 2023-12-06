-module(calculator).
-compile(export_all).

finalizer(PIDL) ->
    lists:filter(fun(PID) -> PID ! finished,true end, PIDL).

add() ->
    %%io:format("add started\n",[]),
    receive
	finished ->
	    ok; %%io:format("add finished\n",[]);
	{calcunit, X_PID, A, B} ->
	    io:format("add: ~w + ~w\n",[A,B]),
	    X_PID ! {add, self(), A+B},
	    add()
    end.

mul() ->
    %%io:format("mul started\n",[]),
    receive
	finished ->
	    ok; %%io:format("mul finished\n",[]);
	{calcunit,X_PID, A, B} ->
	    io:format("mul: ~w * ~w\n",[A,B]),
	    X_PID ! {mul, self(), A*B},
	    mul()
	%%calcunit ->
	%%    io:format("mul do nothing\n",[])	    
    end.

do() ->
    TaskA = [3,4,mul,5,add],
    TaskB = [2,3,mul,7,add,2,mul],
    do([TaskA,TaskB]).
do(Tasks) ->
    PIDA = spawn(calculator,add,[]),
    PIDM = spawn(calculator,mul,[]),
    PIDs = [[{"job",add},{"pid",PIDA}],[{"job",mul},{"pid",PIDM}]],
    PIDSup = spawn(calculator, supervisor, [length(Tasks),PIDs,[],self()]),
    lists:filter(fun(T) -> 
			 spawn(calculator,
			       calcunit,
			       [PIDs ++ [[{"job",sup},{"pid",PIDSup}]], [], T]),
			 true
		 end, Tasks),
    receive
	{ supervisor, Results } ->
	    Results
    end.

supervisor(0,PIDs, Results, MasterPID) ->
    PIDL = get_pid(all,PIDs,self()),
    io:format("do finalize.\n",[]),
    finalizer(PIDL),
    MasterPID ! {supervisor, Results};
supervisor(N,PIDs, Results, MasterPID) ->
    io:format("supervisor started, jobs to wait: ~w (~w)~n",[N,self()]),
    receive
	{ calcunit, _, Args } ->
	    supervisor(N-1,PIDs,Results++[Args],MasterPID)
    end.

get_pid(T,L) ->
    get_pid(T,L,none).
get_pid(T,PIDs,ExPID) ->
    TPIDs = lists:foldl(fun(X,Acc) ->
				D = dict:from_list(X),
				J = dict:fetch("job",D),
				if 
				    ((J =:= T) or (T =:= all)) ->
				       [dict:fetch("pid",D)] ++ Acc;
				   true ->
				       Acc
			       end
			end, 
			[], PIDs),
    if 
	(ExPID =:= none) ->
	    if
		(length(TPIDs) =:= 0) ->
		    error;
		true ->
		    hd(TPIDs)
	    end;
	true ->
	    lists:filter(fun(PID) -> (PID =/= ExPID) end, TPIDs)
    end.

calcunit(PIDs, Args, []) ->
    if 
	(length(Args) > 1) ->
	    io:format("Fails (last operation with only one argument: ~w\n",[Args]);
	true ->
	    io:format("Result: ~w\n",[Args])
    end,
    %%io:format("tell supervisor this task is over.\n",[]),
    PIDSup = get_pid(sup,PIDs),
    PIDSup ! { calcunit, self(), Args };
calcunit(PIDs, ArgL, [H|Tail]) ->
    %%io:format("calcunit started (~w)\n",[self()]),
    PIDA = get_pid(add,PIDs),
    %%io:format("calcunit: PIDA (~w)\n",[PIDA]),
    PIDM = get_pid(mul,PIDs),
    %%io:format("calcunit: PIDA (~w), PIDM (~w)\n",[PIDA,PIDM]),
    if 
	H =:= add ->
	    %%io:format("do add\n",[]),
	    if 
		(length(ArgL) < 2) ->
		    calcunit(PIDs, ArgL ++ [mul], []);
		true ->
		    [A|[B|_]] = ArgL,
		    PIDA ! { calcunit, self(), A, B }
	    end;
        H =:= mul ->
	    %%io:format("do mul\n",[]),
	    if 
		(length(ArgL) < 2) ->
		    calcunit(PIDs, ArgL ++ [mul], []);
		true ->
		    [A|[B|_]] = ArgL,
		    PIDM ! { calcunit, self(), A, B }
	    end;
	true ->
	    %%io:format("shift arguments\n",[]),
	    calcunit(PIDs, [H] ++ ArgL, Tail)
    end,
    receive
	{ add, _, Sum } ->
	    [_|[_|Targs]] = ArgL,
	    calcunit(PIDs,[Sum]++Targs,Tail);
	{ mul, _, Prod } ->
	    [_|[_|Targs]] = ArgL,
	    calcunit(PIDs,[Prod]++Targs,Tail)
    end.


-ifdef(REBARTEST).
-include_lib("eunit/include/eunit.hrl").
get_pid_test() ->
    PID = get_pid(add,[[{"job",add},{"pid",1}],[{"job",mul},{"pid",2}]]),
    ?assertEqual(1,PID),
    ok.
multi_task_calculator_test() ->
    LR = length(do()),
    ?assertEqual(2,LR),
    Results = do([[1,1,add],[7,3,add,mul],[2]]),
    ?assertEqual(3,(length(Results))),
    ?assertEqual(1,(length(lists:filter(fun(X)->length(X)>1 end,Results)))),
    ok.
-endif.
