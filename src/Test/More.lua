
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--

local _G = _G
local ipairs = ipairs
local loadstring = loadstring
local pairs = pairs
local pcall = pcall
local require = require
local tostring = tostring
local type = type

module 'Test.More'

local tb = require 'Test.Builder'

function plan (arg)
    tb.plan(arg)
end

function skip_all (reason)
    tb.skip_all(reason)
end

function BAIL_OUT (reason)
    tb.BAIL_OUT(reason)
end

function ok (test, name)
    tb.ok(test, name)
end

function nok (test, name)
    tb.ok(not test, name)
end

function is (got, expected, name)
    local pass = got == expected
    tb.ok(pass, name)
    if not pass then
        tb.diag("         got: " .. tostring(got)
           .. "\n    expected: " .. tostring(expected))
    end
end

function isnt (got, expected, name)
    local pass = got ~= expected
    tb.ok(pass, name)
    if not pass then
        tb.diag("         got: " .. tostring(got)
           .. "\n    expected: anything else")
    end
end

function like (got, pattern, name)
    local pass = tostring(got):match(pattern)
    tb.ok(pass, name)
    if not pass then
        tb.diag("                  " .. tostring(got)
           .. "\n    doesn't match '" .. tostring(pattern) .. "'")
    end
end

function unlike (got, pattern, name)
    local pass = not tostring(got):match(pattern)
    tb.ok(pass, name)
    if not pass then
        tb.diag("                  " .. tostring(got)
           .. "\n    matches '" .. tostring(pattern) .. "'")
    end
end

local cmp = {
    ['<']  = function (a, b) return a <  b end,
    ['<='] = function (a, b) return a <= b end,
    ['>']  = function (a, b) return a >  b end,
    ['>='] = function (a, b) return a >= b end,
    ['=='] = function (a, b) return a == b end,
    ['~='] = function (a, b) return a ~= b end,
}

function cmp_ok (this, op, that, name)
    local pass = cmp[op](this, that)
    tb.ok(pass, name)
    if not pass then
        tb.diag("    " .. tostring(this)
           .. "\n        " .. op
           .. "\n    " .. tostring(that))
    end
end

function type_ok (val, t, name)
    if type(val) == t then
        tb.ok(true, name)
    else
        tb.ok(false, name)
        tb.diag("    " .. tostring(val) .. " isn't a '" .. t .."' it's '" .. type(val) .. "'")
    end
end

function pass (name)
    tb.ok(true, name)
end

function fail (name)
    tb.ok(false, name)
end

function require_ok (mod)
    local r, msg = pcall(require, mod)
    tb.ok(r, "require '" .. mod .. "'")
    if not r then
        tb.diag("    " .. msg)
    end
    return r
end

function eq_array (got, expected, name)
    for i, v in ipairs(expected) do
        local val = got[i]
        if val ~= v then
            tb.ok(false, name)
            tb.diag("    at index: " .. tostring(i)
               .. "\n         got: " .. tostring(val)
               .. "\n    expected: " .. tostring(v))
            return
        end
    end
    local extra = #got - #expected
    if extra ~= 0 then
        tb.ok(false, name)
        tb.diag("    " .. tostring(extra) .. " unexpected item(s)")
    else
        tb.ok(true, name)
    end
end

function is_deeply (got, expected, name)
    local msg

    local function deep_eq (t1, t2)
        for k, v in pairs(t2) do
            local val = t1[k]
            if type(v) == 'table' then
                local r = deep_eq(val, v)
                if not r then
                    return false
                end
            else
                if val ~= v then
                    msg = "diff"
                    return false
                end
            end
        end
        for k, _ in pairs(t1) do
            local val = t2[k]
            if val == nil then
                msg = "unexpected key"
                return false
            end
        end
        return true
    end -- deep_eq

    local pass = deep_eq(got, expected)
    tb.ok(pass, name)
    if not pass then
        tb.diag("    " .. msg)
    end
end

function error_is (code, expected, name)
    if type(code) == 'string' then
        code = loadstring(code)
    end
    local r, msg = pcall(code)
    if r then
        tb.ok(false, name)
        tb.diag("    unexpected success"
           .. "\n    expected: " .. tostring(expected))
    else
        is(msg, expected, name)
    end
end

function error_like (code, pattern, name)
    if type(code) == 'string' then
        code = loadstring(code)
    end
    local r, msg = pcall(code)
    if r then
        tb.ok(false, name)
        tb.diag("    unexpected success"
           .. "\n    expected: " .. tostring(pattern))
    else
        like(msg, pattern, name)
    end
end

function lives_ok (code, name)
    if type(code) == 'string' then
        code = loadstring(code)
    end
    local r, msg = pcall(code)
    tb.ok(r)
    if not r then
        tb.diag("    " .. msg)
    end
end

function diag (msg)
    tb.diag(msg)
end

function note (msg)
    tb.note(msg)
end

function skip (reason, count)
    tb.skip(reason, count)
end

function todo_skip (reason)
    tb.todo_skip(reason)
end

function skip_rest (reason)
    tb.skip_rest(reason)
end

function todo (reason, count)
    tb.todo(reason, count)
end

for k, v in pairs(_G.Test.More) do
    if k:sub(1, 1) ~= '_' then
        -- injection
        _G[k] = v
    end
end

_VERSION = "0.0.0"
_DESCRIPTION = "lua-TestMore : an Unit Testing Framework"
_COPYRIGHT = "Copyright (c) 2009 Francois Perrad"
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
