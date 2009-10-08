#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(4)


test_out "ok 1 - require 'Test.More'"
ret = require_ok "Test.More"
test_test "ok require_ok"
is( ret, true, "return true" )


test_out "not ok 1 - require 'MyApp'"
--test_fail(3)
test_diag "    module 'MyApp' not found:"  -- not checked
test_diag "\tno field package.preload['MyApp']"
ret = require_ok "MyApp"
test_test{ "fail require_ok", skip_err = true }
is( ret, false, "return false" )

