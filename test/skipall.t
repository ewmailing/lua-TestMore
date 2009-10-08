#! /usr/bin/lua

require 'Test.More'
plan(3)

function os.exit (code)
    error( "os.exit(" .. tostring(code) .. ")" )
end

local tb = require 'Test.Builder.NoOutput':create()

error_like(tb.skip_all, { tb },
           '^[^:]+:%d+: os.exit%(0%)')

is( tb:read'out', "1..0 # SKIP\n" )

is( tb:read'err', '' )

