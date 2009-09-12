
LUA = /usr/bin/lua

export LUA_PATH=;;../src/?.lua

harness:
	@prove --exec=$(LUA) *.t

sanity:
	@prove --exec=$(LUA) 0*.t

