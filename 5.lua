local mongol = require 'mongol'
local conn = mongol()
require 'lglib'

db = conn:use('chat')

n = db:count('units')

--local cursor, ret = db:findOne('users', {server = ObjectId("50f646a7a5f48e2c49000004")});
local obj = db:findOne('units', {});
fptable(obj)

local obj = db:findOne('units', {}, {});
fptable(obj)

local obj = db:findOne('units', {}, {name=true});
fptable(obj)
--[[
local cursor = db:find('users', {
  ['$query'] = {server = ObjectId("50f646a7a5f48e2c49000004")},
  ['$maxScan'] = 10,
  ['$orderby'] = {username=1}
}, {username=true})
--local cursor = db:find('users', {})
--fptable(cursor)
for i, item in cursor:pairs() do
	print(i, item)
	
  fptable(item)
end
--]]
