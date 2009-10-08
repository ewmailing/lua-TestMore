#! /usr/bin/lua

require 'Test.More'
plan(7)

local tb = require 'Test.Builder.NoOutput':create()


-- Test diag() goes to todo_output() in a todo test.
tb:todo("todo_start", 1)
tb:diag "a single line"
is( tb:read'todo', "# a single line\n", "diag() with todo_output set" )


ret = tb:diag("multiple\n", "lines")
is( tb:read'todo', "# multiple\n# lines\n", "  multi line" )
is( ret, nil, "diag returns nil" )
tb:todo("todo_end", -1)


-- Test diagnostic formatting
tb:diag "# foo"
is( tb:read'err', [[
# # foo
]], "diag() adds # even if there's one already" )


tb:diag "foo\n\nbar"
is( tb:read'err', [[
# foo
#
# bar
]], "  blank lines get escaped" );


tb:diag "foo\n\nbar\n\n"
is( tb:read'err', [[
# foo
#
# bar
#
]], "  even at the end" )


tb:diag( "one", "two" )
is( tb:read'err', "# onetwo\n" )

