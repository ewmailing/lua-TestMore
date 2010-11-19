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

is(bit32.AND(0x01, 0x03, 0x07), 0x01, "function AND")

is(bit32.NOT(0x03), (-1 - 0x03) % 2^32, "function NOT")

is(bit32.OR(0x01, 0x03, 0x07), 0x07, "function OR")

is(bit32.TEST(0x01), true, "function TEST")
is(bit32.TEST(0x00), false, "function TEST")

is(bit32.XOR(0x01, 0x03, 0x07), 0x05, "function XOR")

is(bit32.ROL(0x03, 2), 0x0C, "function ROL")

is(bit32.ROR(0x06, 1), 0x03, "function ROR")

is(bit32.SAR(0x06, 1), 0x03, "function SAR")

is(bit32.SHL(0x03, 2), 0x0C, "function SHL")

is(bit32.SHR(0x06, 1), 0x03, "function SHR")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
