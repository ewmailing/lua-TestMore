#! lua
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--
-- Copyright (C) 2009, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Regex Compiler

=head2 Synopsis

    % prove 314-regex.t

=head2 Description

Tests Lua Regex

Individual tests are stored in the C<rx_*> files in the same directory;
There is one test per line: each test consists of the following
columns (separated by one *or more* tabs):

=over 4

=item pattern

The Lua regex to test.

=item target

The string that will be matched against the pattern. Use '' to indicate
an empty string.

=item result

The expected result of the match.

=item description

Description of the test.

=back

=cut

--]]

require 'Test.More'

plan(150)

local test_files = {
    'rx_captures',
    'rx_charclass',
    'rx_metachars',
}

local todo_info = {
    [143] = "fp",
}

local function split (line)
    local pattern, target, result, desc = line:match '^([^\t]*)\t+([^\t]*)\t+([^\t]*)\t+([^\t]*)'
    if pattern == "''" then
        pattern = ''
    else
        pattern = pattern:gsub('"', "\\\"")
    end
    if target == "''" then
        target = ''
    else
        target = target:gsub('"', "\\\"")
    end
    if result == "''" then
        result = ''
    else
        result = result:gsub("\\f", "\f")
        result = result:gsub("\\r", "\r")
        result = result:gsub("\\n", "\n")
        result = result:gsub("\\t", "\t")
        result = result:gsub("\\01", "\01")
        result = result:gsub("\\02", "\02")
        result = result:gsub("\\03", "\03")
        result = result:gsub("\\04", "\04")
--        result = result:gsub("\\0", "\0")
    end
    return pattern, target, result, desc
end

local test_number = 0
for _, filename in ipairs(test_files) do
    local f, msg = io.open(filename, 'r')
    if f == nil then
        diag(msg)
        break
    else
        for line in f:lines() do
            if line:len() == 0 then
                break
            end
            local pattern, target, result, desc = split(line)
--            print(pattern, target, result, desc)
            test_number = test_number + 1
            if todo_info[test_number] then
                todo(todo_info[test_number])
            end
            local code = [[
                    local t = {string.match("]] .. target .. [[", "]] .. pattern .. [[")}
                    if #t== 0 then
                        return 'nil'
                    else
                        return table.concat(t, "\t")
                    end
            ]]
--            print(code)
            if result:sub(1, 1) == '/' then
                local pattern = result:sub(2, result:len() - 1)
                error_like(loadstring(code), pattern, desc)
            else
                is(loadstring(code)(), result, desc)
            end
        end
        f:close()
    end
end

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
