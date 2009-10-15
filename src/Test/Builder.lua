
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
    self.expected_tests = 0
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
    if not self.have_output_plan then
        _output_plan(self, num_tests)
    end
end

function _ending (self)
    if self.no_ending then
        return
    end
    if self.no_plan then
        _output_plan(self, self.curr_test)
        self.expected_tests = self.curr_test
    end
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
