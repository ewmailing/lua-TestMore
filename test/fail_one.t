#! lua

require 'Test.More'
plan(2)

require 'Test.Builder.NoOutput'

local tb = Test.Builder.NoOutput:create()
tb:plan(1)

-- line 11
tb:ok( false );

is( tb:read'out', [[
1..1
not ok 1
]] )

todo "need full _ending & testing_done"
is( tb:read'err', [[
#   Failed test at fail_one.t line 28.
# Looks like you failed 1 test of 1.
]] )

