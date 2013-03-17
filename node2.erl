% ex: set ts=4 et:

-module(node2).
-author("Ryan Flynn www.parseerror.com github.com/rflynn").
-export([run/0]).

% contact node1, then lookup a global name that node1 registers

run() ->
    until(true, conn(), fun conn/0),
    io:format("~p I can see ~p~n",
        [?MODULE, nodes()]),
    application:start(gproc), % wait until connected
    io:format("~p waiting for global name registered elsewhere...~n",
        [?MODULE]),
    io:format("~p sweet, I see it: ~p~n",
        [?MODULE, while(undefined, w(), fun w/0)]),
    rpc:call('node1@127.0.0.1', init, stop, []),
    halt().

conn() -> net_kernel:connect_node('node1@127.0.0.1').

w() -> gproc:where({n,g,foo}).

until(X, X, _) -> X;
until(X, _, F) -> until(X, F(), F).

while(X, X, F) -> while(X, F(), F);
while(_, Y, _) -> Y.
