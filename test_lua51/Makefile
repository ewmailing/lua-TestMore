
LUAJIT = /usr/local/bin/luajit
LLVM_LUA = /usr/local/bin/llvm-lua
LUA = /usr/bin/lua

export LUA_PATH=;;../src/?.lua

harness:
	@prove --exec=$(LUA) *.t

sanity:
	@prove --exec=$(LUA) 0*.t

luajit:
	@prove --exec=$(LUAJIT) *.t

llvm-lua:
	@prove --exec=$(LLVM_LUA) *.t

