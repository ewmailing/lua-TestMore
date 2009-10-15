#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(9)


test_out "ok 1 - function error with param"
error_is(error, { 'MSG' }, 'MSG', "function error with param")
test_test "ok error_is"


test_out "not ok 1 - function error with param"
test_fail(3)
test_diag "         got: bad"
test_diag "    expected: MSG"
error_is(error, { 'bad' }, 'MSG', "function error with param")
test_test "fail error_is (wrong error)"


test_out "not ok 1 - function print without param"
test_fail(3)
test_diag "    unexpected success"
test_diag "    expected: MSG"
error_is(print, 'MSG', "function print without param")
test_test "fail error_is (unexpected success)"


test_out "ok 1 - loadstring error"
error_like([[error 'MSG']], '^[^:]+:%d+: MSG', "loadstring error")
test_test "ok error_like"


test_out "not ok 1 - loadstring error"
test_fail(3)
test_diag [[                  '[string "error 'bad'"]:1: bad']]
test_diag [[    doesn't match '^[^:]+:%d+: MSG']]
error_like([[error 'bad']], '^[^:]+:%d+: MSG', "loadstring error")
test_test "fail error_like (doesn't match)"


test_out "not ok 1 - loadstring ok"
test_fail(3)
test_diag "    unexpected success"
test_diag "    expected: ^[^:]+:%d+: MSG"
error_like([[m = _G]], '^[^:]+:%d+: MSG', "loadstring ok")
test_test "fail error_like (unexpected success)"


test_out "not ok 1 - can't compile"
test_fail(3)
test_diag [[    can't compile code :]]
test_diag [[    [string "?syntax error?"]:1: unexpected symbol near '?']]
error_like([[?syntax error?]], '^[^:]+:%d+: MSG', "can't compile")
test_test "fail error_like (can't compile)"


test_out "ok 1 - anonymous function"
lives_ok(function () return true end, "anonymous function")
test_test "ok lives_ok"


test_out "not ok 1 - anonymous function"
test_fail(2)
test_diag("    " .. arg[0] .. ":" .. tostring(line_num ()+1) .. ": MSG")
lives_ok(function () error 'MSG' end, "anonymous function")
test_test "fail lives_ok"

