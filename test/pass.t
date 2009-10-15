#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(6)


test_out "ok 1 - foo"
ok( true, "foo" )
test_test "ok ok"


test_out "not ok 1 - foo"
test_fail(1)
ok( false, "foo" )
test_test "fail ok"


test_out "ok 1 - foo"
nok( false, "foo" )
test_test "ok nok"


test_out "not ok 1 - foo"
test_fail(1)
nok( true, "foo" )
test_test "fail nok"


test_out "ok 1 - foo"
pass "foo"
test_test "pass"


test_out "not ok 1 - foo"
test_fail(1)
fail "foo"
test_test "fail"

