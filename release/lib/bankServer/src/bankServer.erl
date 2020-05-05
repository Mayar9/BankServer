-module(bankServer).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-export([start/1,newAccount/1,viewAccounts/0,viewBalance/1,
	 depositeClient/2,withDrawClient/2,stop/0]).

-define(SERVER, ?MODULE). 

-record(state, {}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start(Bankname) ->
    bankServer:start_link(Bankname).

newAccount(ClientName) ->
    gen_server:cast(bankServer,{new_account,ClientName}).

viewAccounts() ->
    gen_server:call(bankServer,view_accounts).

viewBalance(ClientName) ->
    gen_server:call(bankServer,{view_balance,ClientName}).

depositeClient(ClientName,Value) ->
    gen_server:cast(bankServer,{deposite,ClientName,Value}).

withDrawClient(ClientName,Value) ->
    gen_server:cast(bankServer,{withDraw,ClientName,Value}).

stop() ->
    bankServer:terminate(normal,[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
start_link(BankName) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [BankName], []).


init(BName) ->
    io:format("Bank ~p has been opened ~n",[BName]),
    {ok, []}.

%%new_account,deposite,withdraw,view_accounts,view_balance


handle_call(view_accounts, _From, State) ->
    {reply , State , State};

handle_call({view_balance,Name}, _From, State) ->
    {reply, {Name,proplists:get_value(Name,State)} , State};
handle_call(_, _From, State) ->
    {reply, unknown_message, State}.

handle_cast({new_account,Name}, State) ->
    {noreply, [{Name,0} | State]};

handle_cast({deposite,Name,Value}, State) ->
    {noreply, [{Name,proplists:get_value(Name,State)+Value} | proplists:delete(Name,State)]};

handle_cast({withDraw,Name,Value}, State) ->
    {noreply, [{Name,proplists:get_value(Name,State)-Value} | proplists:delete(Name,State)]}.



handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    io:format("Bank is Closed !",[]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

