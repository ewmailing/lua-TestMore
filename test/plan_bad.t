#! /usr/bin/lua

require 'Test.More'
plan(5)

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

