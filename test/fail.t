#! /usr/bin/lua

require 'Test.More'
plan(2)

local tb = require 'Test.Builder.NoOutput':create()
tb:plan(5)

tb:ok( 1 == 1, 'passing' );
tb:ok( 2 == 2, 'passing still' );
tb:ok( 3 == 3, 'still passing' );
tb:ok( false, 'oh no!', -1 ); -- line 12
tb:ok( false, 'damnit', -1 ); -- line 13

is( tb:read'out', [[
1..5
ok 1 - passing
ok 2 - passing still
ok 3 - still passing
not ok 4 - oh no!
not ok 5 - damnit
]] )

is( tb:read'err', "#     Failed test (" .. arg[0] .. " at line 12)\n"
               .. "#     Failed test (" .. arg[0] .. " at line 13)\n" )

