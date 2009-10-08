#! /usr/bin/lua

require 'Test.More'
plan(7)

local why = "Just testing the todo interface."

todo(why, 2)
fail "Expected failure"
fail "Another expected failure"

pass "This is not todo"

todo(why)
fail "Yet another failure"

pass "This is still not todo"

if true then
    todo_skip "Just testing todo_skip"
else
    fail "Just testing todo"
end
pass "Again"

