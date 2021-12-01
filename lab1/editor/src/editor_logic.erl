-module(editor_logic).

-compile(export_all).

readData() ->
    receive
        {readData}->
            io:format("in logic ~n"),
            readlines();
            % io:format(Data);
        Other->
            io:format("Invalid data read ~p~n" ,[Other])
    end.

readlines() ->
    {ok, Device} = file:open("data.txt", [read]),
    try get_all_lines(Device)
        after file:close(Device)
    end.
    
get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

