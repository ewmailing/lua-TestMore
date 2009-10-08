#! /usr/bin/lua

require 'Test.More'
plan(4)

local why = "Just testing the skip interface."

if false then
    skip("We're not skipping", 2)
else
    pass "not skipped in this branch"
    pass "not skipped again"
end

if true then
    skip(why, 2)
else
    fail "Deliberate failure"
    fail "And again"
end

