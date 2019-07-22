
When trying to get erlang's gproc lib to work between nodes I found
lots of people describing the problem and some information but no
straight-forward examples. So here it is.

# Run

    make

# Recipe

1. clone gproc
2. build with GPROC_DIST to pull in gen_leader
3. invoke erl with -gproc gproc_dist all
4. ensure nodes see each other before starting gproc
5. gproc:reg({_,g,_})

# Issues

* gproc_dist/gen_leader doesn't handle netsplits, which is why
  the application must be started after connecting to other nodes.

# Output

Initial run should pull in and build gproc/gen_leader;
subsequent invocations should look like:

    [ -d gproc ] || git clone https://github.com/uwiger/gproc.git
    [ -d gproc/deps/gen_leader/ebin ] || GPROC_DIST=true make -C gproc
    erlc node1.erl
    erlc node2.erl
    # launch node 1 in background...
    erl -name node1@127.0.0.1                         \
            -noshell                                  \
            -pa gproc/ebin gproc/deps/gen_leader/ebin \
            -gproc gproc_dist all                     \
            -s node1 &
    # launch node 2 and wait for it to finish and kill both nodes
    erl -name node2@127.0.0.1                         \
            -noshell                                  \
            -pa gproc/ebin gproc/deps/gen_leader/ebin \
            -gproc gproc_dist all                     \
            -s node2
    node1 waiting to hear from somebody...
    node1 ok, so I see ['node2@127.0.0.1']
    node2 I can see ['node1@127.0.0.1']
    node1 reg: true
    node1 double-check name I just registered: <0.2.0>
    node2 waiting for global name registered elsewhere...
    node2 sweet, I see it: <4868.2.0>

