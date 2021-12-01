-module(editor_system_app).

-behaviour(application).

-compile(export_all).

start() ->
    io:format("es1 start ~n"),
    application:start(?MODULE).

start(_Type, _Args) ->
    io:format("es2 start ~n"),
    editor_supervisor:start_link().

stop() ->
    application:stop(?MODULE).

stop(_State) ->
    ok.