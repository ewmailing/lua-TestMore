#! /usr/bin/lua

require 'Test.More'
require 'Test.Builder.Tester'
plan(7)

t = {
    a = 1,
    b = 2,
    c = 3,
}
test_out "ok 1 - hashs are equals"
is_deeply( t, {a= 1, b= 2, c = 3}, "hashs are equals" )
test_test "ok is_deeply (hash)"


test_out "not ok 1 - key b differents"
test_fail(4)
test_diag "    Tables begin differing at:"
test_diag "         got.b: 2"
test_diag "    expected.b: -4"
is_deeply( t, {a= 1, b= -4, c = 3}, "key b differents" )
test_test "fail is_deeply"


test_out "not ok 1 - extra key"
test_fail(4)
test_diag "    Tables begin differing at:"
test_diag "         got.d: nil"
test_diag "    expected.d: extra"
is_deeply( t, {a= 1, b= 2, c = 3, d='extra'}, "extra key" )
test_test "fail is_deeply (extra)"


test_out "not ok 1 - missing key"
test_fail(4)
test_diag "    Tables begin differing at:"
test_diag "         got.b: 2"
test_diag "    expected.b: nil"
is_deeply( t, {a= 1, c = 3}, "missing key" )
test_test "fail is_deeply (missing)"


test_out "not ok 1 - got is'nt a table"
test_fail(2)
test_diag "got value isn't a table : nil"
eq_array( nil, t, "got is'nt a table" )
test_test "fail is_deeply (bad)"


test_out "not ok 1 - expected is'nt a table"
test_fail(2)
test_diag "expected value isn't a table : nil"
eq_array( t, nil, "expected is'nt a table" )
test_test "fail is_deeply (bad)"


t = {
    a = 1,
    b = 'text',
    c = true,
    d = {
        'x',
        'y',
        'z',
    },
}
test_out "not ok 1 - key d.2 differents"
test_fail(4)
test_diag "    Tables begin differing at:"
test_diag "         got.d.2: y"
test_diag "    expected.d.2: w"
is_deeply( t, {a=1, b='text', c=true, d={'x','w','z'}}, "key d.2 differents" )
test_test "fail is_deeply (recursif)"
