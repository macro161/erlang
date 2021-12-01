-module(editor_supervisor).

-behaviour(supervisor).

-compile(export_all).

start_link() ->
    io:format("hel god ~n"),
    supervisor:start_link({global,?MODULE}, ?MODULE, []).

init([]) ->
    io:format("pls ~n"),

    %%% If MaxRestarts restarts occur in MaxSecondsBetweenRestarts seconds
    %%% supervisor and child processes are killed
    RestartStrategy = one_for_one,
    MaxRestarts = 3,                  % 3 restart within
    MaxSecondsBetweenRestarts = 5,    % five seconds
    Flags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    %%% permanent - always restart
    %%% temporary - never restart
    %%% transient - restart if abnormally ends
    Restart = permanent,

    %%%brutal_kill - use exit(Child, kill) to terminate
    %%%integer - use exit(Child, shutdown) - milliseconds
    Shutdown = infinity,

    %%% worker
    %%% supervisor
    Type = worker,

    %% Modules ones supervisor uses
    %%% {ChildId, {StartFunc - {module,function,arg}, Restart, Shutdown, Type, Modules}.
    Server = {serverId, {server, start_link, []},
    Restart, Shutdown, Type, [server]},

    %%% tuple of restart strategy, max restart and max time
    %%% child specification
    {ok, {Flags, [Server]}}.