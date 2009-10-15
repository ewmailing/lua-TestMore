#! /usr/bin/lua

require 'Test.More'
plan(2)

require 'Test.Builder.NoOutput'

local tb = Test.Builder.NoOutput:create()
tb:plan(1)

tb:ok( false, nil, -1 ) -- line 11

is( tb:read'out', [[
1..1
not ok 1
]] )

is( tb:read'err', "#     Failed test (" .. arg[0] .. " at line 11)\n" )

