% ex: set ts=4 et:

-module(node1).
-author("Ryan Flynn www.parseerror.com github.com/rflynn").
-export([run/0]).

% wait to hear from node2, then register a global name

run() ->
    io:format("~p waiting to hear from somebody...~n",
        [?MODULE]),
    io:format("~p ok, so I see ~p~n",
        [?MODULE, while([], nodes(), fun erlang:nodes/0)]),
    application:start(gproc),
    io:format("~p reg: ~p~n",
        [?MODULE, gproc:reg({n,g,foo})]),
    io:format("~p double-check name I just registered: ~p~n",
        [?MODULE, gproc:where({n,g,foo})]),
    timer:sleep(infinity). % wait to be killed by node2

while(X, X, F) -> while(X, F(), F);
while(_, Y, _) -> Y.
