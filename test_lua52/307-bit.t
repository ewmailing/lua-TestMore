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

=head1 Lua Bitwise Library

=head2 Synopsis

    % prove 307-bit.t

=head2 Description

Tests Lua Bitwise Library

See "Lua 5.2 Reference Manual", section 6.7 "Bitwise operations",
L<http://www.lua.org/manual/5.2/manual.html#6.7>.

=cut

--]]

require 'Test.More'

if arg[-1] == 'luajit' then
    skip_all("LuaJIT. bit32")
end

plan(11)

is(bit32.band(0x01, 0x03, 0x07), 0x01, "function band")

is(bit32.bnot(0x03), (-1 - 0x03) % 2^32, "function bnot")

is(bit32.bor(0x01, 0x03, 0x07), 0x07, "function bor")

is(bit32.btest(0x01), true, "function btest")
is(bit32.btest(0x00), false, "function btest")

is(bit32.bxor(0x01, 0x03, 0x07), 0x05, "function bxor")

is(bit32.lrotate(0x03, 2), 0x0C, "function lrotate")

is(bit32.rrotate(0x06, 1), 0x03, "function rrotate")

is(bit32.arshift(0x06, 1), 0x03, "function arshift")

is(bit32.lshift(0x03, 2), 0x0C, "function lshift")

is(bit32.rshift(0x06, 1), 0x03, "function rshift")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
