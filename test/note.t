#! /usr/bin/lua

require 'Test.More'
plan(2)

local tb = require 'Test.Builder.NoOutput':create()

tb:note 'foo'
is( tb:read'out' , "# foo\n" )
is( tb:read'err', '')

