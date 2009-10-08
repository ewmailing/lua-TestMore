#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(4)


test_out "ok 1 - arrays are equal"
eq_array( {1, 2, 3}, {1, 2, 3}, "arrays are equal" )
test_test "ok eq_array"


test_out "not ok 1 - item2 differents"
--test_fail(4)
test_diag "    at index: 2"
test_diag "         got: -4"
test_diag "    expected: 2"
eq_array( {1, -4, 3}, {1, 2, 3}, "item2 differents" )
test_test "fail eq_array"


test_out "not ok 1 - extra item"
--test_fail(2)
test_diag "    1 unexpected item(s)"
eq_array( {1, 2, 3, 'extra'}, {1, 2, 3}, "extra item" )
test_test "fail eq_array (extra)"


test_out "not ok 1 - missing item"
--test_fail(4)
test_diag "    at index: 3"
test_diag "         got: nil"
test_diag "    expected: 3"
eq_array( {1, 2 }, {1, 2, 3}, "missing item" )
test_test "fail eq_array (missing)"

