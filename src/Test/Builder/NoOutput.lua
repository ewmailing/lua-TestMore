
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--

local io =io
local pairs = pairs
local require = require

module 'Test.Builder.NoOutput'  -- useful for testing Test.Builder

function create (self)
    local tb = require 'Test.Builder':create()
    tb:output(io.tmpfile())
    tb:failure_output(io.tmpfile())
    tb:todo_output(io.tmpfile())

    function tb:read (stream)
        if     stream == 'out' then
            f = self:output()
            f:seek 'set'
            local out = f:read '*a'
            f:close()
            self:output(io.tmpfile())
            return out
        elseif stream == 'err' then
            f = self:failure_output()
            f:seek 'set'
            local out = f:read '*a'
            f:close()
            self:failure_output(io.tmpfile())
            return out
        elseif stream == 'todo' then
            f = self:todo_output()
            f:seek 'set'
            local out = f:read '*a'
            f:close()
            self:todo_output(io.tmpfile())
            return out
        else
            self:output():close()
            self:output(io.tmpfile())
            self:failure_output():close()
            self:failure_output(io.tmpfile())
            self:todo_output():close()
            self:todo_output(io.tmpfile())
        end
    end

    return tb
end

--
-- Copyright (c) 2009 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
