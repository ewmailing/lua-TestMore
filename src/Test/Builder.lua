
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--

local _G = _G
local print = print

module 'Test.Builder'

local testnum = 1
local failed = 0
local planned = 0
local started = 0
local todo_upto = 0
local todo_reason

local function proclaim (cond, desc)
    local msg = ''
    if not cond then
        msg = "not "
        if todo_upto < testnum then
            failed = failed + 1
        end
    end
    msg = msg .. "ok " .. testnum .. " - " .. desc
    testnum = testnum + 1
    if todo_reason and todo_upto >= testnum then
        msg = msg .. todo_reason
    end
    print(msg)
end

function plan (num)
        print("1.." .. num)
        started = 1
        testnum = 1
        todo_upto = 0
        failed = 0
        planned = num
end

function ok (cond, desc)
    desc = desc or ''
    proclaim(cond, desc)
end

function diag (msg)
    print(msg)
end

function note (msg)
    print(msg)
end

function explain (msg)
    print(msg)
end

function todo (reason, count)
    count = count or 1
    todo_upto = testnum + count
    todo_reason = " # TODO #" .. reason
end

function skip (reason, count)
    reason = reason or ''
    count = count or 1
    for i = 1, count do
        fail("# SKIP #" .. reason)
    end
end

--
-- Copyright (c) 2009 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
