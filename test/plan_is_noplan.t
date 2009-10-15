#! /usr/bin/lua

require 'Test.More'
plan(1)

local tb = require 'Test.Builder.NoOutput':create()
tb:plan 'no_plan'

tb:ok( true, 'foo' )
tb:done_testing()

is( tb:read'out', [[
ok 1 - foo
1..1
]] )

