#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(6)


test_out "ok 1 - foo matches foo"
like( "foo", 'foo', "foo matches foo" )
test_test "ok like"


test_out "not ok 1 - is foo like that"
test_fail(3)
test_diag "                  'foo'"
test_diag "    doesn't match 'that'"
like( "foo", 'that', "is foo like that" )
test_test "fail like"


test_out "not ok 1 - pattern isn't a string"
test_fail(2)
test_diag "pattern isn't a string : nil"
like( "foo", nil, "pattern isn't a string" )
test_test "not a pattern"


test_out "ok 1 - foo doesn't matches bar"
unlike( "foo", 'bar', "foo doesn't matches bar" )
test_test "ok unlike"


test_out "not ok 1 - is foo match foo"
test_fail(3)
test_diag "                  'foo'"
test_diag "          matches 'foo'"
unlike( "foo", 'foo', "is foo match foo" )
test_test "fail unlike"


test_out "not ok 1 - pattern isn't a string"
test_fail(2)
test_diag "pattern isn't a string : nil"
unlike( "foo", nil, "pattern isn't a string" )
test_test "not a pattern"

