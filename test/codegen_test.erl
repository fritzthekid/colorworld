-module(codegen_test).

-include_lib("eunit/include/eunit.hrl").

codegen_test() ->
    Text = codegenerator:gen_code(),
    ?assert(length(Text)> 50).
