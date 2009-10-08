#! /usr/bin/lua

require 'Test.More'
plan(5)

local m = require 'Test.More'
type_ok( m, 'table' )
is( m, Test.More )
like( m._COPYRIGHT, 'Perrad', "_COPYRIGHT" )
like( m._DESCRIPTION, 'Unit Testing Framework', "_DESCRIPTION" )
like( m._VERSION, '^%d%.%d%.%d$', "_VERSION" )

