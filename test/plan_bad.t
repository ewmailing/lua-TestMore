#! /usr/bin/lua

require 'Test.More'
plan(7)

local tb = require 'Test.Builder.NoOutput':create()

error_like(tb.plan, { tb, 'wrong' },
           '^[^:]+:%d+: Need a number of tests')

error_like(tb.plan, { tb, {} },
           '^[^:]+:%d+: Need a number of tests')

error_like(tb.plan, { tb, '12' },
           '^[^:]+:%d+: Need a number of tests')

error_like(tb.plan, { tb, '' },
           '^[^:]+:%d+: Need a number of tests')

error_like(tb.plan, { tb, -1 },
           "^[^:]+:%d+: Number of tests must be a positive integer.  You gave it '%-1'.")

tb:plan( 0 )
is( tb:read'out', "1..0\n" )
is( tb:read'err', '' )

