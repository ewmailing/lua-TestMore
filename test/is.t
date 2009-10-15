#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(4)


test_out "ok 1 - foo is foo"
is( "foo", "foo", "foo is foo" )
test_test "ok is"


test_out "not ok 1 - is foo bar"
test_fail(3)
test_diag "         got: foo"
test_diag "    expected: bar"
is( "foo", "bar", "is foo bar" )
test_test "fail is"


test_out "ok 1 - foo isn't bar"
isnt( "foo", "bar", "foo isn't bar" )
test_test "ok isnt"


test_out "not ok 1 - isn't foo foo"
test_fail(3)
test_diag "         got: foo"
test_diag "    expected: anything else"
isnt( "foo", "foo", "isn't foo foo" )
test_test "fail isnt"

