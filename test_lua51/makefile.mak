# nmake /F makefile.mak

LUAJIT = luajit
LLVM_LUA = llvm-lua
LUA = lua

harness: env
	@prove --exec=$(LUA) *.t

sanity: env
	@prove --exec=$(LUA) 0*.t

luajit: env
	@prove --exec=$(LUAJIT) *.t

llvm-lua: env
	@prove --exec=$(LLVM_LUA) *.t

env:
	@set LUA_PATH=;;../src/?.lua
	@set LUA_INIT=platform = { osname=[[MSWin32]], intsize=4 }

