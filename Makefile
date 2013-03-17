# ex: set ts=8 noet:

gproc_dist_example: build compile
	# launch node 1 in background...
	erl -name node1@127.0.0.1                     \
    	-noshell                                  \
    	-pa gproc/ebin gproc/deps/gen_leader/ebin \
    	-gproc gproc_dist all                     \
    	-s node1 run &
	# launch node 2 and wait for it to finish and kill both nodes
	erl -name node2@127.0.0.1                     \
    	-noshell                                  \
    	-pa gproc/ebin gproc/deps/gen_leader/ebin \
    	-gproc gproc_dist all                     \
    	-s node2 run 

build:
	[ -d gproc ] || git clone https://github.com/uwiger/gproc.git
	[ -d gproc/deps/gen_leader/ebin ] || GPROC_DIST=true make -C gproc

compile:
	erlc node1.erl
	erlc node2.erl
