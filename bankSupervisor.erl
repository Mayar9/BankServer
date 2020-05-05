-module(bankSupervisor).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1,terminate/0]).

-define(SERVER, ?MODULE).

start_link(BankName) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [BankName]).

init(BName) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 10,
    MaxSecondsBetweenRestarts = 60,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown =brutal_kill,
    Type = worker,

    AChild = {bankServer, {bankServer, start_link, [BName]},
	      Restart, Shutdown, Type, [bankServer]},

    {ok, {SupFlags, [AChild]}}.


terminate() ->
    io:format("supervisor Closed !",[]),
    ok.
