#! /usr/bin/lua
--
-- lua-TestMore : <http://fperrad.github.com/lua-TestMore/>
--
-- Copyright (C) 2009, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua thread & coercion

=head2 Synopsis

    % prove 107-thread.t

=head2 Description

=cut

--]]

require 'Test.More'

plan(24)

co = coroutine.create(function () return 1 end)

error_like(function () return -co end,
           "attempt to perform arithmetic on",
           "-co")

error_like(function () return #co end,
           "attempt to get length of",
           "#co")

is(not co, false, "not co")

error_like(function () return co + 10 end,
           "attempt to perform arithmetic on",
           "co + 10")

error_like(function () return co - 2 end,
           "attempt to perform arithmetic on",
           "co - 2")

error_like(function () return co * 3.14 end,
           "attempt to perform arithmetic on",
           "co * 3.14")

error_like(function () return co / 7 end,
           "attempt to perform arithmetic on",
           "co / 7")

error_like(function () return co % 4 end,
           "attempt to perform arithmetic on",
           "co % 4")

error_like(function () return co ^ 3 end,
           "attempt to perform arithmetic on",
           "co ^ 3")

error_like(function () return co .. 'end' end,
           "attempt to concatenate",
           "co .. 'end'")

is(co == co, true, "co == co")

co1 = coroutine.create(function () return 1 end)
co2 = coroutine.create(function () return 2 end)
is(co1 ~= co2, true, "co1 ~= co2")

is(co == 1, false, "co == 1")

is(co ~= 1, true, "co ~= 1")

error_like(function () return co1 < co2 end,
           "attempt to compare two thread values",
           "co1 < co2")

error_like(function () return co1 <= co2 end,
           "attempt to compare two thread values",
           "co1 <= co2")

error_like(function () return co1 > co2 end,
           "attempt to compare two thread values",
           "co1 > co2")

error_like(function () return co1 >= co2 end,
           "attempt to compare two thread values",
           "co1 >= co2")

error_like(function () return co < 0 end,
           "attempt to compare %w+ with %w+",
           "co < 0")

error_like(function () return co <= 0 end,
           "attempt to compare %w+ with %w+",
           "co <= 0")

error_like(function () return co > 0 end,
           "attempt to compare %w+ with %w+",
           "co > 0")

error_like(function () return co > 0 end,
           "attempt to compare %w+ with %w+",
           "co >= 0")

error_like(function () a = co[1] end,
           "attempt to index",
           "index")

error_like(function () co[1] = 1 end,
           "attempt to index",
           "index")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
