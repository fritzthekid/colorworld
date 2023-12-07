-module(calculator).
-export([do/0, do/1]).
-compile(export_all).


do() ->
    TaskA = [3,4,mul,5,add],
    TaskB = [2,3,mul,7,add,2,mul],
    do([TaskA,TaskB]).
do(Tasks) ->
    PIDA = spawn(calculator,add,[]),
    PIDM = spawn(calculator,mul,[]),
    PIDF = spawn(calculator,fact,[]),
    PIDSum = spawn(calculator,sum,[]),
    PIDs = [[{"job",add},{"pid",PIDA}],[{"job",mul},{"pid",PIDM}]] ++
		[[{"job",fact},{"pid",PIDF}],[{"job",sum},{"pid",PIDSum}]],
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
			io:format("Fails! (arguments do not fit last operation): ~p)\n",[Args]);
		true ->
			io:format("Result: ~p\n",[Args])
    end,
    PIDSup = get_pid(sup,PIDs),
    PIDSup ! { calcunit, self(), Args };
calcunit(PIDs, ArgL, [H|Tail]) ->
	io:format("calcunit: ~p ~p ~p\n",[ArgL,H,Tail]),
    case H of
		add ->
			if 
				(length(ArgL) < 2) ->
					calcunit(PIDs, ArgL ++ [add], []);
				true ->
				    PIDA = get_pid(add,PIDs),
					[A|[B|_]] = ArgL,
					PIDA ! { calcunit, self(), A, B }
			end;
		mul ->
			if 
				(length(ArgL) < 2) ->
					calcunit(PIDs, ArgL ++ [mul], []);
				true ->
    				PIDM = get_pid(mul,PIDs),
					[A|[B|_]] = ArgL,
					PIDM ! { calcunit, self(), A, B }
	    	end;
		fact ->
			if 
				(length(ArgL) =:= 0) ->
					calcunit(PIDs, ArgL ++ [fact], []);
				true ->
					PIDF = get_pid(fact,PIDs),
					[A|_] = ArgL,
					PIDF ! { calcunit, self(), A }
	    	end;
		sum ->
			PIDSum = get_pid(sum,PIDs),
			PIDSum ! { calcunit, self(), ArgL };
		_Default ->
			%% shift arguments to arglist
	    	calcunit(PIDs, [H] ++ ArgL, Tail)
    end,
    receive
		{ fact, _, Res } ->
			[_|Targs] = ArgL,
			calcunit(PIDs,[Res]++Targs,Tail);
		{ sum, _, Res } ->
			calcunit(PIDs,[Res],Tail);
		{ _Task, _, Result} ->
			[_|[_|Targs]] = ArgL,
			calcunit(PIDs,[Result]++Targs,Tail)
    end.

finalizer(PIDL) ->
    lists:filter(fun(PID) -> PID ! finished,true end, PIDL).

add() ->
    receive
		finished ->
			ok;
		{calcunit, X_PID, A, B} ->
			io:format("add: ~w + ~w\n",[A,B]),
			X_PID ! {add, self(), A+B},
			add()
    end.

mul() ->
    receive
	finished ->
	    ok;
	{calcunit,X_PID, A, B} ->
	    io:format("mul: ~w * ~w\n",[A,B]),
	    X_PID ! {mul, self(), A*B},
	    mul()
    end.

fact() ->
    receive
		finished ->
			ok;
		{calcunit,X_PID, A} ->
			io:format("fact: ~w\n",[A]),
			X_PID ! {fact, self(), factrec(A)},
			fact()
    end.

sum() ->
    receive
		finished ->
			ok;
		{calcunit,X_PID, Args} ->
			io:format("sum: ~p \n",[Args]),
			X_PID ! {sum, self(), lists:sum(Args)},
			sum()
    end.


factrec(N) ->
	if
		(N < 1) ->
			0;
		true ->
			factrec(1,N)
	end.
factrec(Acc, 1) -> Acc;
factrec(Acc, X) ->
	factrec(Acc*X,X-1).

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
    ?assertEqual(137,hd(hd(do([[17,3,2,add,fact,sum]])))),
    ok.
-endif.
