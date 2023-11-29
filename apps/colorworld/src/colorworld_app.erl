%%%-------------------------------------------------------------------
%% @doc colorworld public API
%% @end
%%%-------------------------------------------------------------------

-module(colorworld_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    colorworld_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
