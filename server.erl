-module(server).
-compile(nowarn_export_all).
-compile(export_all).

start() ->
    erlang:register(server,self()),
    database().

database() ->
    ets:new(usernames, [set, protected, named_table]),
    ets:insert(usernames, {clientone, "Client one"}),
    ets:insert(usernames, {clienttwo, "Client two"}),
    
    ets:new(userip, [set, protected, named_table]),
    ets:insert(userip, {clientone, 'clientone@127.0.0.1'}),
    ets:insert(userip, {clienttwo, 'clienttwo@127.0.0.1'}).

set_up_receiver() ->
    receive
        {ClientName, over} -> 
            {ClientName, lookup_id(ClientName)} ! over, 
            set_up_receiver();
        {ClientName, Message} ->
            {ClientName, lookup_id(ClientName)} ! {Message, lookup_name(ClientName)},
            set_up_receiver();
        shutdown ->
            io:format("Shutting down~n")
    end.

lookup_name(ClientName) ->
    element(2, lists:last(ets:lookup(usernames, ClientName))).

lookup_id(ClientName) ->
    element(2, lists:last(ets:lookup(userip, ClientName))).
