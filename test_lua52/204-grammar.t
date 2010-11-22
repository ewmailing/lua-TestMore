#! /usr/bin/lua
--
-- lua-TestMore : <http://fperrad.github.com/lua-TestMore/>
--
-- Copyright (C) 2010, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Grammar

=head2 Synopsis

    % prove 204-grammar.t

=head2 Description

See "Lua 5.2 Reference Manual", section 9 "The Complete Syntax of Lua",
L<http://www.lua.org/manual/5.2/manual.html#9>.

=cut

--]]

require 'Test.More'

plan(3)

--[[ empty statement ]]
f, msg = loadstring [[; a = 1]]
if arg[-1] == 'luajit' then
    todo("LuaJIT TODO. empty statement.", 1)
    diag(msg)
end
type_ok(f, 'function', "empty statement")

--[[ orphan break ]]
f, msg = loadstring [[
function f()
    print "before"
    do
        print "inner"
        break
    end
    print "after"
end
]]
like(msg, "^[^:]+:%d+: no loop to break", "orphan break")

--[[ no last ]]
f, msg = loadstring [[
function f()
    print "before"
    while true do
        print "inner"
        break
        print "break"
    end
    print "after"
end
]]
like(msg, "^[^:]+:%d+: 'end' expected %(to close", "no last")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
