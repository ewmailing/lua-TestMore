#! /usr/bin/lua

require 'Test.More'

plan(4)

error_like( plan, { 4 },
            '^[^:]+:%d+: You tried to plan twice',
            "disallow double plan" )

error_like( plan, { 'no_plan' },
            '^[^:]+:%d+: You tried to plan twice',
            "disallow changing plan" )

pass "Just testing plan()"
pass "Testing it some more"

