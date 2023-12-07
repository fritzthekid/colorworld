-module(xgen).
-compile(export_all).
%%-export([gen_code]).

gen_code() ->
    Network=cwutils:read_json("data/network.json"),
    Text = gen_layers(maps:get("layers",Network)),
    io:format("~s",[Text]),
    binary:list_to_bin(Text).

gen_layers([]) ->
    io_lib:format("/*end*/\n",[]);
gen_layers([Layer|Tail]) ->
    case maps:get("class",Layer) of
	"dense" -> Code = gen_dense(Layer);
	"conv" -> Code = gen_conv(Layer);
	_Else -> 
	    Code = io_lib:format("/* Layer ~s class ~s not supported.*/\n",
				 [maps:get("name",Layer), maps:get("class",Layer)])
    end,
    Code ++ gen_layers(Tail).

gen_dense(L) ->
    io_lib:format("/* Dense Layer implemented */\n~s\n",
		  [matrix_mult(maps:get("name",L),maps:get("weights",L),maps:get("bias",L),maps:get("inout",L))]).

gen_conv(_) ->
    io_lib:format("/* Conv Layer not implemented yet */\n",[]).

matrix_mult(Name,W,B,Io) ->
    io_lib:format("MatrixMult_~s(~s, ~s, ~w, ~w, *y) {\n~s\n}\n",
		  [Name,W,B,hd(Io),lists:last(Io), for_loop(W,hd(Io),lists:last(Io))]).

for_loop(P0,M,N) ->
    Mt = integer_to_list(M), Nt = integer_to_list(N),
    io_lib:format("for (int i = 0; i < ~s, i++) {\n"++
		      "  for (int j = 0; j < ~s, j++) {\n"++
		      "    *y[i] = ~s[i*~s+j]*x[j];\n  }}\n",
		  [Mt,Nt,P0,Mt])
    ++
	io_lib:format("return;",[]).

-ifdef(REBARTEST).
-include_lib("eunit/include/eunit.hrl").
codegen_test() ->
    Text = gen_code().
    %%?assert(length(Text)> 50).
-endif.
