#! /usr/bin/lua
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--
-- Copyright (C) 2009, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Stand-alone

=head2 Synopsis

    % perl t/standalone.t

=head2 Description

See "Lua 5.1 Reference Manual", section 6 "Lua Stand-alone",
L<http://www.lua.org/manual/5.1/manual.html#6>.

=cut

--]]

require 'Test.More'

local lua = (platform and platform.lua) or arg[-1]

plan(8)

f = io.open('hello.lua', 'w')
f:write([[
print 'Hello World'
]])
f:close()

cmd = lua .. " hello.lua"
f = io.popen(cmd)
is(f:read'*l', 'Hello World', "file")
f:close()

os.execute "luac -o hello.luac hello.lua"

cmd = lua .. " hello.luac"
f = io.popen(cmd)
is(f:read'*l', 'Hello World', "bytecode")
f:close()

os.remove('hello.luac') -- clean up

cmd = lua .. " < hello.lua"
f = io.popen(cmd)
is(f:read'*l', 'Hello World', "redirect")
f:close()

cmd = lua .. [[ -e"a=1" -e "print(a)"]]
f = io.popen(cmd)
is(f:read'*l', '1', "-e")
f:close()

cmd = lua .. [[ -e"a=1" -e "print(a)" hello.lua]]
f = io.popen(cmd)
is(f:read'*l', '1', "-e & script")
is(f:read'*l', 'Hello World')
f:close()

os.remove('hello.lua') -- clean up

cmd = lua .. [[ -lTest.More -e "print(type(Test.More.ok))"]]
f = io.popen(cmd)
is(f:read'*l', 'function', "-lTest.More")
f:close()

cmd = lua .. [[ -l Test.More -e "print(type(Test.More.ok))"]]
f = io.popen(cmd)
is(f:read'*l', 'function', "-l Test.More")
f:close()

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
