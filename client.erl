-module(client).
-compile(nowarn_export_all).
-compile(export_all).

-define(SERVER_ID, 'server@127.0.0.1').
-define(SERVER_NAME, server).

start(Name) ->
    erlang:register(Name, self()).

send(Message, ClientName) ->
    if 
        Message == over ->
            {?SERVER_NAME,?SERVER_ID} ! {ClientName, Message}, 
            receiver();
        true ->
            {?SERVER_NAME,?SERVER_ID} ! {ClientName, Message}
    end.
receiver() ->
    receive
        {Message, ClientName} ->
            io:format("~p : ~p ~n",[ClientName, Message]),
            receiver();
        over -> io:format("Type your message now~n")
    end.

exit() ->
    {?SERVER_NAME,?SERVER_ID} ! shutdown.
