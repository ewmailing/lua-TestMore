#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(3)


test_out "ok 1 - 1 <= 2"
cmp_ok( 1, '<=', 2, "1 <= 2" )
test_test "ok cmp_ok"


test_out "not ok 1 - 1 > 2"
test_fail(4)
test_diag "    1"
test_diag "        >"
test_diag "    2"
cmp_ok( 1, '>', 2, "1 > 2" )
test_test "fail cmp_ok"


test_out "not ok 1 - 1 <=> 2"
test_fail(2)
test_diag "unknown operator : <=>"
cmp_ok( 1, '<=>', 2, "1 <=> 2" )
test_test "unknown operator"

