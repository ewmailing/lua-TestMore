
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--

local _G = _G
local io = io
local os = os
local error = error
local ipairs = ipairs
local print = print
local tostring = tostring
local type = type

module 'Test.Builder'

local curr_test = 0
local expected_tests = 0
local todo_upto = 0
local todo_reason
local have_plan = false

local out_file = io and io.stdout
local fail_file = io and (io.stderr or io.stdout)
local todo_file = io and io.stdout

local function _print (...)
    local f = output()
    if f then
        f:write(..., "\n")
    else
        print(...)
    end
end

local function print_comment (f, ...)
    if f then
        local msg = ''
        for _, v in ipairs{...} do
            msg = msg .. tostring(v)
        end
        msg = msg:gsub("\n", "\n# ")
        f:write("# ", msg, "\n")
    else
        print("# ", ...)
    end
end

function reset ()
    curr_test = 0
    expected_tests = 0
    todo_upto = 0
    have_plan = false
end

function plan (arg)
    if have_plan then
        error("You tried to plan twice")
    end
    if type(arg) == 'string' and arg == 'no_plan' then
        have_plan = true
        return true
    elseif type(arg) ~= 'number' then
        error("Need a number of tests")
    elseif arg <= 0 then
        error("Number of tests must be a positive integer.  You gave it '" .. arg .."'")
    else
        expected_tests = arg
        have_plan = true
        _print("1.." .. arg)
        return arg
    end
end

function skip_all (reason)
    if have_plan then
        error("You tried to plan twice")
    end
    out = "1..0"
    if reason then
        out = out .. " # Skip " .. reason
    end
    _print(out)
    os.exit(0)
end

local function in_todo ()
    return todo_upto >= curr_test
end

function ok (test, name)
    name = name or ''
    if not have_plan then
        error("You tried to run a test without a plan")
    end
    curr_test = curr_test + 1
    name = tostring(name)
    if name:match('^[%d%s]+$') then
        diag("    You named your test '" .. name .."'.  You shouldn't use numbers for your test names."
        .. "\n    Very confusing.")
    end
    local out = ''
    if not test then
        out = "not "
    end
    out = out .. "ok " .. curr_test .. " - " .. name
    if todo_reason and in_todo() then
        out = out .. " # TODO # " .. todo_reason
    end
    _print(out)
end

function BAIL_OUT (reason)
    local out = "Bail out!"
    if reason then
        out = out .. "  " .. reason
    end
    _print(out)
    os.exit(255)
end

function todo (reason, count)
    count = count or 1
    todo_upto = curr_test + count
    todo_reason = reason
end

function skip (reason, count)
    count = count or 1
    local name = "# skip"
    if reason then
        name = name .. " " .. reason
    end
    for i = 1, count do
        ok(true, name)
    end
end

local function diag_file ()
    if in_todo() then
        return todo_output()
    else
        return failure_output()
    end
end

function diag (...)
    print_comment(diag_file(), ...)
end

function note (...)
    print_comment(output(), ...)
end

function output (f)
    if f then
        out_file = f
    end
    return out_file
end

function failure_output (f)
    if f then
        fail_file = f
    end
    return fail_file
end

function todo_output (f)
    if f then
        todo_file = f
    end
    return todo_file
end

--
-- Copyright (c) 2009 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
