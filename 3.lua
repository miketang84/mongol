local mongol = require 'mongol'
local conn = mongol()
require 'lglib'

ptable(conn)

dbs = conn:databases()
fptable(dbs)
db = conn:new_db_handle('chat')

n = db:count('users')
print(n)
local ObjectId = (require 'mongol.object_id').ObjectId


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
