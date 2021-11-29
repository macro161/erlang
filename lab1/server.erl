%% Copyright
-module(server).
-author("Ola").

%% Let the compiler know this is a gen_server
%% Must implement the functions
-behaviour(gen_server).

%% API
-export([start_link/0, factorial/1, stop/0, factorial/2]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3, writeData/3]).

%% API Client Call
start_link() ->
    file:write_file("foo.txt", "tests"),
    Data = readlines(),
    io:format(Data),
    io:format("server start link ~n"),
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

stop() ->
    io:format("server stop ~n"),
  gen_server:cast({global,?MODULE}, stop).

factorial(Val) ->
    io:format("server factorial ~n"),
  %% spawn(fun() -> divide_server:divide(10,0) end).
  gen_server:call({global,?MODULE},{factorial,Val}).

factorial(Val,IoDevice) ->
    io:format("server factorial io ~n"),
%% spawn(fun() -> divide_server:divide(10,0) end).
  gen_server:call({global,?MODULE},{factorial,Val,IoDevice}).

writeData(datafunc, Data, Row) ->
    io:format(Data),
    io:format(Row).
    
    

readlines() ->
    {ok, Device} = file:open("foo.txt", [read]),
    try get_all_lines(Device)
      after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.


%% gen_server callbacks
%% gen_server calls on start up
%% [] = state - something persistent between each message example: a dictionary
init([]) ->
    io:format("server init ~n"),
  %%% we ensure that the supervisor to receive notification when the process goes down
  %%% When a process traps exists when ever the process dies it sends a message to the supervisor
  process_flag(trap_exit, true),
  io:format("~p (~p) starting.... ~n", [{global, ?MODULE}, self()]),
  {ok, []}.

handle_call(stop, _From, State) ->
    io:format("server handle call 1 ~n"),
  {stop, normal, ok, State};

handle_call({factorial,Val}, _From, State) ->
    io:format("server handle call 2 ~n"),
  Pid = spawn(fun() -> factorial_logic:factorial_handler() end),
  {reply, Pid ! {factorial, Val},State};

handle_call({factorial,Val,IoDevice}, _From, State) ->
    io:format("server handle call 3 ~n"),
  Pid = spawn(fun() -> factorial_logic:factorial_handler() end),
  {reply, Pid ! {factorialRecorder, Val, IoDevice},State};




handle_call(_Request, _From, State) ->
    io:format("server handle call 4 ~n"),
  {reply,error, State}.

handle_cast(stop, State) ->
    io:format(" serve handl cast 1 ~n"),
  {stop, normal, State};

handle_cast(_Request, State) ->
    io:format("server handle cast 2 ~n"),
  {noreply, State}.

%% handle info - server ! hello
handle_info(_Info, State) ->
    io:format("server handle info ~n"),
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("server terminating ~p~n", [{global, ?MODULE}]),
  ok.

code_change(_OldVsn, State, _Extra) ->
    io:format("server code change ~n"),
  {ok, State}.