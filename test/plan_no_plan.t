#! /usr/bin/lua

require 'Test.More'

plan 'no_plan'

pass "Just testing"
ok(true, "Testing again")

skip "Just testing skip with no_plan"

todo_skip "Just testing todo_skip"

todo "Just testing todo"
fail "Just testing todo"

done_testing()

