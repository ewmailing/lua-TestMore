
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
local unpack = unpack or require 'table'.unpack

require 'Test.Builder'
local tb = Test.Builder:new()

module 'Test.More'

function plan (arg)
    tb:plan(arg)
end

function done_testing (num_tests)
    tb:done_testing(num_tests)
end

function skip_all (reason)
    tb:skip_all(reason)
end

function BAIL_OUT (reason)
    tb:BAIL_OUT(reason)
end

function ok (test, name)
    tb:ok(test, name)
end

function nok (test, name)
    tb:ok(not test, name)
end

function is (got, expected, name)
    local pass = got == expected
    tb:ok(pass, name)
    if not pass then
        tb:diag("         got: " .. tostring(got)
           .. "\n    expected: " .. tostring(expected))
    end
end

function isnt (got, expected, name)
    local pass = got ~= expected
    tb:ok(pass, name)
    if not pass then
        tb:diag("         got: " .. tostring(got)
           .. "\n    expected: anything else")
    end
end

function like (got, pattern, name)
    if type(pattern) ~= 'string' then
        tb:ok(false, name)
        tb:diag("pattern isn't a string : " .. tostring(pattern))
        return
    end
    got = tostring(got)
    local pass = got:match(pattern)
    tb:ok(pass, name)
    if not pass then
        tb:diag("                  '" .. got .. "'"
           .. "\n    doesn't match '" .. pattern .. "'")
    end
end

function unlike (got, pattern, name)
    if type(pattern) ~= 'string' then
        tb:ok(false, name)
        tb:diag("pattern isn't a string : " .. tostring(pattern))
        return
    end
    got = tostring(got)
    local pass = not got:match(pattern)
    tb:ok(pass, name)
    if not pass then
        tb:diag("                  '" .. got .. "'"
           .. "\n          matches '" .. pattern .. "'")
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
    local f = cmp[op]
    if not f then
        tb:ok(false, name)
        tb:diag("unknown operator : " .. tostring(op))
        return
    end
    local pass = f(this, that)
    tb:ok(pass, name)
    if not pass then
        tb:diag("    " .. tostring(this)
           .. "\n        " .. op
           .. "\n    " .. tostring(that))
    end
end

function type_ok (val, t, name)
    if type(t) ~= 'string' then
        tb:ok(false, name)
        tb:diag("type isn't a string : " .. tostring(pattern))
        return
    end
    if type(val) == t then
        tb:ok(true, name)
    else
        tb:ok(false, name)
        tb:diag("    " .. tostring(val) .. " isn't a '" .. t .."' it's a '" .. type(val) .. "'")
    end
end

function pass (name)
    tb:ok(true, name)
end

function fail (name)
    tb:ok(false, name)
end

function require_ok (mod)
    local r, msg = pcall(require, mod)
    tb:ok(r, "require '" .. tostring(mod) .. "'")
    if not r then
        tb:diag("    " .. msg)
    end
    return r
end

function eq_array (got, expected, name)
    if type(got) ~= 'table' then
        tb:ok(false, name)
        tb:diag("got value isn't a table : " .. tostring(got))
        return
    elseif type(expected) ~= 'table' then
        tb:ok(false, name)
        tb:diag("expected value isn't a table : " .. tostring(expected))
        return
    end
    for i, v in ipairs(expected) do
        local val = got[i]
        if val ~= v then
            tb:ok(false, name)
            tb:diag("    at index: " .. tostring(i)
               .. "\n         got: " .. tostring(val)
               .. "\n    expected: " .. tostring(v))
            return
        end
    end
    local extra = #got - #expected
    if extra ~= 0 then
        tb:ok(false, name)
        tb:diag("    " .. tostring(extra) .. " unexpected item(s)")
    else
        tb:ok(true, name)
    end
end

function is_deeply (got, expected, name)
    if type(got) ~= 'table' then
        tb:ok(false, name)
        tb:diag("got value isn't a table : " .. tostring(got))
        return
    elseif type(expected) ~= 'table' then
        tb:ok(false, name)
        tb:diag("expected value isn't a table : " .. tostring(expected))
        return
    end
    local msg1
    local msg2

    local function deep_eq (t1, t2, key_path)
        if t1 == t2 then
            return true
        end
        for k, v2 in pairs(t2) do
            local v1 = t1[k]
            if type(v1) == 'table' and type(v2) == 'table' then
                local r = deep_eq(v1, v2, key_path .. "." .. tostring(k))
                if not r then
                    return false
                end
            else
                if v1 ~= v2 then
                    key_path = key_path .. "." .. tostring(k)
                    msg1 = "     got" .. key_path .. ": " .. tostring(v1)
                    msg2 = "expected" .. key_path .. ": " .. tostring(v2)
                    return false
                end
            end
        end
        for k in pairs(t1) do
            local v2 = t2[k]
            if v2 == nil then
                key_path = key_path .. "." .. tostring(k)
                msg1 = "     got" .. key_path .. ": " .. tostring(t1[k])
                msg2 = "expected" .. key_path .. ": " .. tostring(v2)
                return false
            end
        end
        return true
    end -- deep_eq

    local pass = deep_eq(got, expected, '')
    tb:ok(pass, name)
    if not pass then
        tb:diag("    Tables begin differing at:")
        tb:diag("    " .. msg1)
        tb:diag("    " .. msg2)
    end
end

function error_is (code, arg2, arg3, arg4)
    local params, expected, name
    if type(arg2) == 'table' then
        params = arg2
        expected = arg3
        name = arg4
    else
        params = {}
        expected = arg2
        name = arg3
    end
    if type(code) == 'string' then
        local msg
        code, msg = loadstring(code)
        if not code then
            tb:ok(false, name)
            tb:diag("    can't compile code :"
               .. "\n    " .. msg)
            return
        end
    end
    local r, msg = pcall(code, unpack(params))
    if r then
        tb:ok(false, name)
        tb:diag("    unexpected success"
           .. "\n    expected: " .. tostring(expected))
    else
        local pass = msg == expected
        tb:ok(pass, name)
        if not pass then
            tb:diag("         got: " .. msg
               .. "\n    expected: " .. tostring(expected))
        end
    end
end

function error_like (code, arg2, arg3, arg4)
    local params, pattern, name
    if type(arg2) == 'table' then
        params = arg2
        pattern = arg3
        name = arg4
    else
        params = {}
        pattern = arg2
        name = arg3
    end
    if type(code) == 'string' then
        local msg
        code, msg = loadstring(code)
        if not code then
            tb:ok(false, name)
            tb:diag("    can't compile code :"
               .. "\n    " .. msg)
            return
        end
    end
    local r, msg = pcall(code, unpack(params))
    if r then
        tb:ok(false, name)
        tb:diag("    unexpected success"
           .. "\n    expected: " .. tostring(pattern))
    else
        if type(pattern) ~= 'string' then
            tb:ok(false, name)
            tb:diag("pattern isn't a string : " .. tostring(pattern))
            return
        end
        local pass = msg:match(pattern)
        tb:ok(pass, name)
        if not pass then
            tb:diag("                  '" .. msg .. "'"
               .. "\n    doesn't match '" .. pattern .. "'")
        end
    end
end

function lives_ok (code, arg2, arg3)
    local params, name
    if type(arg2) == 'table' then
        params = arg2
        name = arg3
    else
        params = {}
        name = arg2
    end
    if type(code) == 'string' then
        local msg
        code, msg = loadstring(code)
        if not code then
            tb:ok(false, name)
            tb:diag("    can't compile code :"
               .. "\n    " .. msg)
            return
        end
    end
    local r, msg = pcall(code, unpack(params))
    tb:ok(r, name)
    if not r then
        tb:diag("    " .. msg)
    end
end

function diag (msg)
    tb:diag(msg)
end

function note (msg)
    tb:note(msg)
end

function skip (reason, count)
    tb:skip(reason, count)
end

function todo_skip (reason)
    tb:todo_skip(reason)
end

function skip_rest (reason)
    tb:skip_rest(reason)
end

function todo (reason, count)
    tb:todo(reason, count)
end

for k, v in pairs(_G.Test.More) do  -- injection
    _G[k] = v
end

_VERSION = "0.2.1"
_DESCRIPTION = "lua-TestMore : an Unit Testing Framework"
_COPYRIGHT = "Copyright (c) 2009-2010 Francois Perrad"
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
