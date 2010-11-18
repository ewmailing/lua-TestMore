#! /usr/bin/lua
--
-- lua-TestMore : <http://fperrad.github.com/lua-TestMore/>
--
-- Copyright (C) 2009-2010, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Debug Library

=head2 Synopsis

    % prove 310-debug.t

=head2 Description

Tests Lua Debug Library

See "Lua 5.2 Reference Manual", section 6.10 "The Debug Library",
L<http://www.lua.org/manual/5.2/manual.html#6.10>.

See "Programming in Lua", section 23 "The Debug Library".

=cut

]]

require 'Test.More'

plan(14)

debug = require 'debug'

info = debug.getinfo(is)
type_ok(info, 'table', "function getinfo (function)")
is(info.func, is, " .func")

info = debug.getinfo(1)
type_ok(info, 'table', "function getinfo (level)")
like(info.func, "^function: [0]?[Xx]?%x+", " .func")

is(debug.getinfo(12), nil, "function getinfo (too depth)")

error_like(function () debug.getinfo('bad') end,
           "bad argument #1 to 'getinfo' %(function or level expected%)",
           "function getinfo (bad arg)")

t = {}
is(debug.getmetatable(t), nil, "function getmetatable")
t1 = {}
setmetatable(t, t1)
is(debug.getmetatable(t), t1)

local reg = debug.getregistry()
type_ok(reg, 'table', "function getregistry")
type_ok(reg._LOADED, 'table')

t = {}
t1 = {}
is(debug.setmetatable(t, t1), true, "function setmetatable")
is(getmetatable(t), t1)

like(debug.traceback(), "^stack traceback:\n", "function traceback")

like(debug.traceback("message\n"), "^message\n\nstack traceback:\n", "function traceback with message")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
