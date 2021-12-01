-module(server).

-behaviour(gen_server).

-compile(export_all).

-import(string,[equal/2]). 


start_link() ->
    io:format("serverrrrrrr ~n"),

    initFile(),
    {ok, Pid} = gen_server:start_link({global,?MODULE}, ?MODULE, [], []),
    register(server, Pid),
    {ok, Pid}.

initFile() ->
    file:write_file("data.txt", "xzfdsfdsf").

writeData(UserName, NewData, OldData) ->
    gen_server:call({global,?MODULE},{writeData, UserName, NewData, OldData}).

readData(Name) ->
    io:format("read from server ~n"),
    gen_server:call({global,?MODULE},{readData}).

handle_call({readData}, _From, State) ->
    io:format("read call handler ~n"),
    Pid = spawn(fun() -> editor_logic:readData() end),
    Killme = {reply, Pid ! {readData}, State},
    io:format("adasd ~n"),
    io:format(Killme);

handle_call(stop, _From, State) ->
    {stop, normal, ok, State};

handle_call({writeData, UserName, NewData, OldData}, _From, State) ->
    io:format("User attempts to write data"),
    {ok, Data} = file:read_file("data.txt"),
    Status = equal(Data,OldData),
    
    if 
        Status == true ->
        io:format("User privided good old data"),
        file:delete("data.txt"),
        file:write_file("data.txt", NewData);
    true ->
        io:format("User provided bad old data")
    end.

init(_State) ->
    {ok, _State}.

handle_cast(stop, State) ->
    {stop, normal, State}.
