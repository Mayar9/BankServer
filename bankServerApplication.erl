-module(bankServerApplication).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).


start(_StartType, BNameArg) ->
    case 'bankSupervisor':start_link(BNameArg) of
	{ok, Pid} ->
	    {ok, Pid};
	Error ->
	    Error
    end.


stop(_State) ->
    ok.

