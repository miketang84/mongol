local mongol = require 'mongol'
local conn = mongol()
require 'lglib'

ptable(conn)

dbs = conn:databases()
fptable(dbs)
db = conn:new_db_handle('chat')

ptable(db)
ptable(getmetatable(db).__index)

-- cs is a cursor, iterator
cs = db:listcollections()
fptable(cs)

for i, v in cs:pairs() do
	print(i)
	ptable(v)
end

n = db:count('users')
print(n)

local cursor = db:find('users', {email="daogangtang@163.com"}, {username=true})
--local cursor = db:find('users', {})
fptable(cursor)
for i, item in cursor:pairs() do
	print(i, item)
	
  fptable(item)
end
