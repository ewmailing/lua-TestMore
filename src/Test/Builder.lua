
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--

local debug = debug
local io = io
local os = os
local error = error
local ipairs = ipairs
local print = print
local setmetatable = setmetatable
local tonumber = tonumber
local tostring = tostring
local type = type

module 'Test.Builder'

local testout = io and io.stdout
local testerr = io and (io.stderr or io.stdout)

local function _print (self, ...)
    local f = self:output()
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
        msg = msg:gsub("\n# \n", "\n#\n")
        msg = msg:gsub("\n# $", '')
        f:write("# ", msg, "\n")
    else
        print("# ", ...)
    end
end

function create (self)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o:reset()
    o:reset_outputs()
    return o
end

local test
function new (self)
    test = test or self:create()
    return test
end

function reset (self)
    self.curr_test = 0
    self._done_testing = false
    self.expected_tests = 0
    self.is_passing = true
    self.todo_upto = -1
    self.todo_reason = nil
    self.have_plan = false
    self.no_plan = false
    self.have_output_plan = false
end

local function _output_plan (self, max, directive, reason)
    local out = "1.." .. max
    if directive then
        out = out .. " # " .. directive
    end
    if reason then
        out = out .. " " .. reason
    end
    _print(self, out)
    self.have_output_plan = true
end

function plan (self, arg)
    if self.have_plan then
        error("You tried to plan twice")
    end
    if type(arg) == 'string' and arg == 'no_plan' then
        self.have_plan = true
        self.no_plan = true
        return true
    elseif type(arg) ~= 'number' then
        error("Need a number of tests")
    elseif arg <= 0 then
        error("Number of tests must be a positive integer.  You gave it '" .. arg .."'.")
    else
        self.expected_tests = arg
        self.have_plan = true
        _output_plan(self, arg)
        return arg
    end
end

function done_testing (self, num_tests)
    num_tests = num_tests or self.curr_test
    if self._done_testing then
        tb:ok(false, "done_testing() was already called")
        return
    end
    self._done_testing = true
    if self.expected_tests > 0 and num_tests ~= self.expected_tests then
        self:ok(false, "planned to run " .. self.expected_tests
                    .. " but done_testing() expects " .. num_tests)
    else
        self.expected_tests = num_tests
    end
    if not self.have_output_plan then
        _output_plan(self, num_tests)
    end
    self.have_plan = true
    -- The wrong number of tests were run
    if self.expected_tests ~= self.curr_test then
        self.is_passing = false
    end
    -- No tests were run
    if self.curr_test == 0 then
        self.is_passing = false
    end
end

function has_plan (self)
    if self.expected_tests > 0 then
        return self.expected_tests
    end
    if self.no_plan then
        return 'no_plan'
    end
    return nil
end

function skip_all (self, reason)
    if self.have_plan then
        error("You tried to plan twice")
    end
    _output_plan(self, 0, 'SKIP', reason)
    os.exit(0)
end

local function in_todo (self)
    return self.todo_upto >= self.curr_test
end

local function _check_is_passing_plan (self)
    local plan = self:has_plan()
    if not plan or not tonumber(plan) then
        return
    end
    if plan < self.curr_test then
        self.is_passing = false
    end
end

function ok (self, test, name, level)
    name = name or ''
    level = level or 0
    if not self.have_plan then
        error("You tried to run a test without a plan")
    end
    self.curr_test = self.curr_test + 1
    name = tostring(name)
    if name:match('^[%d%s]+$') then
        self:diag("    You named your test '" .. name .."'.  You shouldn't use numbers for your test names."
        .. "\n    Very confusing.")
    end
    local out = ''
    if not test then
        out = "not "
    end
    out = out .. "ok " .. self.curr_test
    if name ~= '' then
        out = out .. " - " .. name
    end
    if self.todo_reason and in_todo(self) then
        out = out .. " # TODO # " .. self.todo_reason
    end
    _print(self, out)
    if not test then
        local msg = "Failed"
        if in_todo(self) then
            msg = msg .. " (TODO)"
        end
        if debug then
            local info = debug.getinfo(3 + level)
            local file = info.short_src
            local line = info.currentline
            self:diag("    " .. msg .. " test (" .. file .. " at line " .. line .. ")")
        else
            self:diag("    " .. msg .. " test")
        end
    end
    if not test and not in_todo(self) then
        self.is_passing = false
    end
    _check_is_passing_plan(self)
end

function BAIL_OUT (self, reason)
    local out = "Bail out!"
    if reason then
        out = out .. "  " .. reason
    end
    _print(self, out)
    os.exit(255)
end

function current_test (self, num)
    if num then
        self.curr_test = num
    end
    return self.curr_test
end

function todo (self, reason, count)
    count = count or 1
    self.todo_upto = self.curr_test + count
    self.todo_reason = reason
end

function skip (self, reason, count)
    count = count or 1
    local name = "# skip"
    if reason then
        name = name .. " " .. reason
    end
    for i = 1, count do
        self:ok(true, name)
    end
end

function todo_skip (self, reason)
    local name = "# TODO & SKIP"
    if reason then
        name = name .. " " .. reason
    end
    self:ok(false, name, 1)
end

function skip_rest (self, reason)
    self:skip(reason, self.expected_tests - self.curr_test)
end

local function diag_file (self)
    if in_todo(self) then
        return self:todo_output()
    else
        return self:failure_output()
    end
end

function diag (self, ...)
    print_comment(diag_file(self), ...)
end

function note (self, ...)
    print_comment(self:output(), ...)
end

function output (self, f)
    if f then
        self.out_file = f
    end
    return self.out_file
end

function failure_output (self, f)
    if f then
        self.fail_file = f
    end
    return self.fail_file
end

function todo_output (self, f)
    if f then
        self.todo_file = f
    end
    return self.todo_file
end

function reset_outputs (self)
    self:output(testout)
    self:failure_output(testerr)
    self:todo_output(testout)
end

--
-- Copyright (c) 2009 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
