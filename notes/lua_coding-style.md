
http://lua-users.org/wiki/LuaStyleGuide
https://luapower.com/coding-style

# Naming

Use Lua’s naming conventions foo_bar and foobar instead of FooBar or fooBar.

## Temporary variables

    t is for tables
    dt is for destination (accumulation) tables (and for time diffs)
    i and j are for indexing
    n is for counting
    k, v is what you get out of pairs()
    i, v is what you get out of ipairs(
    k is for table keys
    v is for values that are passed around
    x is for generic math quantities
    s is for strings
    c is for 1-char strings
    f and func are for functions
    o is for objects
    ret is for return values
    ok, ret is what you get out of pcall
    buf, sz is a (buffer, size) pair
    p is for pointers
    x, y, w, h is for rectangles
    t0, t1 is for timestamps
    err is for errors
    t0 or t_ is for avoiding a name clash with t


Syntax

    use foo() instead of foo ()
    use foo{} instead of foo({}) (there’s no font to save you from that)
    use foo'bar' instead of foo"bar", foo "bar" or foo("bar")
    use foo.bar instead of foo['bar']
    use local function foo() end instead of local foo = function() end (this sugar shouldn’t have existed, but it’s too late now)
    put a comma after the last element of vertical lists

FFI Declarations

Put cdefs in a separate foo_h.lua file because it may contain types that other packages might need. If this is unlikely and the API is small, embed the cdefs in the main module file directly.

Add a comment on top of your foo_h.lua file describing the origin (which files? which version?) and process (cpp? by hand?) used for generating the file. This adds confidence that the C API is complete and up-to-date and can hint a maintainer on how to upgrade the definitions.

Call ffi.load() without paths, custom names or version numbers to keep the module away from any decisions regarding how and where the library is to be found. This allows for more freedom on how to deploy libraries.

Code patterns

Sometimes the drive to compress and compact the code goes against clarity, obscuring the programmer’s intention. Here’s a few patterns of code that can be improved in that regard:
Intention
	
Unclear way
	
Better way
break the code 	return last_func_call() 	last_func_call()
return
declaring unrelated variables 	local var1, var2 = val1, val2 	local var1 = val1
local var2 = val2
private methods 	local function foo(self, ...) end
foo(self, ...) 	function obj:_foo(...) end
self:_foo(...)
dealing with simple cases 	if simple_case then
  return simple_answer
else
  hard case ...
end 	if simple_case then
  return simple_answer
end
hard case ...
emulating bool() 	not not x 	x and true or false
Strict mode

Use require'strict' when developing, but make sure to remove it before publishing your code to avoid breaking other people’s code.
