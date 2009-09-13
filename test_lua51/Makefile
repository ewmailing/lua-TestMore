
LUAJIT = /usr/local/bin/luajit
LLVM_LUA = /usr/local/bin/llvm-lua
LUA = lua
LUA_COVER = ../doc/lua-5.1.4/src/lua

OSNAME = $(shell perl -MConfig -e "print Config->{osname}")
INTSIZE = $(shell perl -MConfig -e "print Config->{intsize}")

export LUA_PATH=;;../src/?.lua
export LUA_INIT=platform = { osname=[[$(OSNAME)]], intsize=$(INTSIZE) }

harness:
	@prove --exec=$(LUA) *.t

sanity:
	@prove --exec=$(LUA) 0*.t

luajit:
	@prove --exec=$(LUAJIT) *.t

llvm-lua:
	@prove --exec=$(LLVM_LUA) *.t

cover:
	@prove --exec=$(LUA_COVER) *.t

