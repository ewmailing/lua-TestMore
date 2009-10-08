#! lua

require 'Test.More'
plan(2)

local tb = require 'Test.Builder.NoOutput':create()
tb:plan(5)

-- line 11
tb:ok( 1 == 1, 'passing' );
tb:ok( 2 == 2, 'passing still' );
tb:ok( 3 == 3, 'still passing' );
tb:ok( false, 'oh no!' );
tb:ok( false, 'damnit' );

is( tb:read'out', [[
1..5
ok 1 - passing
ok 2 - passing still
ok 3 - still passing
not ok 4 - oh no!
not ok 5 - damnit
]] )

todo "need full _ending & testing_done"
is( tb:read'err', [[
#   Failed test 'oh no!'
#   at fail.t line 31.
#   Failed test 'damnit'
#   at fail.t line 32.
# Looks like you failed 2 tests of 5.
]] )

