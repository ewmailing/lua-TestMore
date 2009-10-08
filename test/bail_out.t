#! /usr/bin/lua

require 'Test.More'
plan(2)

function os.exit (code)
    error( "os.exit(" .. tostring(code) .. ")" )
end

local tb = require 'Test.Builder.NoOutput':create()
tb:plan(7)


error_like(tb.BAIL_OUT, { tb },
           '^[^:]+:%d+: os.exit%(255%)')


is( tb:read'out', [[
1..7
Bail out!
]] )

