-module(client).

-compile(export_all).

writeData(UserName, NewData, OldData) ->
    server:writeData(UserName, NewData, OldData).

readData(UserName) ->
    server:readData(UserName).