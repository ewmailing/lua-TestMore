#! /usr/bin/lua

require 'Test.More'
plan(2)

local tb = require 'Test.Builder.NoOutput':create()
tb:plan(1)

tb:ok( false, nil, -1 ) -- line 9

is( tb:read'out', [[
1..1
not ok 1
]] )

is( tb:read'err', "#     Failed test (" .. arg[0] .. " at line 9)\n" )

