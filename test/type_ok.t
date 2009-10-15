#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(3)


test_out "ok 1 - 2 is a number"
type_ok( 2, 'number', "2 is a number" )
test_test "ok type_ok"


test_out "not ok 1 - false is not a table"
test_fail(2)
test_diag "    false isn't a 'table' it's a 'boolean'"
type_ok( false, 'table', "false is not a table" )
test_test "fail type_ok"


test_out "not ok 1 - type isn't a string"
test_fail(2)
test_diag "type isn't a string : nil"
type_ok( 2, nil, "type isn't a string" )
test_test "not a type"

