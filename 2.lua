local collection = arg[1] or "db"

local conn = require "mongol" ( )

local ismaster = conn:ismaster ( )
print ( "Master: " , ismaster )
if not ismaster then
	print ( "Connecting to master database" )
	conn = conn:getprimary ( )
	ismaster = conn:ismaster ( )
	assert ( ismaster )
end

print ( "Databases: " )
local dbs = conn:databases ( )
for k , v in pairs ( dbs ) do
	print("",v.name )
end

print()


local m = conn:new_db_handle ( "test" )

m:auth ( "user" , "pwd" )

print ( "Collections" )
local cursor = m:listcollections ( )
for k , v in cursor:pairs ( ) do
end

print()

m:delete ( collection , { } )

m:insert ( collection , { { a = "lol" ; b = 1 } } )
m:insert ( collection , { { a = "lol" ; b = 2 } } )
m:insert ( collection , { { a = "lol" ; b = 3 } } )
m:insert ( collection , { { a = "lol" ; b = 4 } } )
m:insert ( collection , { { a = "lol" ; b = 5 } } )

m:insert ( collection , { { a = {}, b=9 } } )
m:update ( collection , {b=9}, { ['$push'] = {a="x"} } )


require 'lglib'
do
	local cursor = m:find ( collection , { } )
	for i , item in cursor:pairs ( ) do
		assert ( item.a == nil and item.b == i )
	end
end


collectgarbage"step"
collectgarbage"step"
collectgarbage"step"
collectgarbage"step"
collectgarbage"step"
collectgarbage"step"
collectgarbage"step"
collectgarbage"step"

