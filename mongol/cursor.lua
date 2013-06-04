local t_insert = table.insert
local t_remove = table.remove
local t_concat = table.concat
local strbyte = string.byte
local strformat = string.format


local cursor_methods = { }
local cursor_mt = { __index = cursor_methods }

local p = function (t)
  for k, v in pairs(t) do
    print(k, v)
  end
end

local function new_cursor ( conn , collection , query , returnfields, numberToSkip, numberToReturn)
	return setmetatable ( {
			conn = conn ;
			collection = collection ;
			query = query ;
			returnfields = returnfields ;
      numberToSkip = numberToSkip or 0;
      numberToReturn = numberToReturn or 0;

			id = false ;
			results = { } ;

			done = false ;
			i = 0 ;
		} , cursor_mt )
end

cursor_mt.__gc = function ( self )
	self.conn:kill_cursors ( self.collection , { self.id } )
end


cursor_mt.__tostring = function ( ob )
  assert(ob.id, 'not initialized cursor.')
	local t = { }
	for i = 1 , 8 do
		t_insert ( t , strformat ( "%02x", strbyte ( ob.id , i , i )) )
	end
	return "CursorId(" .. t_concat ( t ) .. ")"
end

function cursor_methods:next ( )
  local index = self.numberToSkip + self.i + 1
	local v = self.results [ index ]
	if v ~= nil then
		self.i = self.i + 1
		self.results [ index ] = nil
		return self.i , v
	end

	if self.done or self.i + 1 > self.numberToReturn then return nil end

	local t
	if not self.id then
		self.id , self.results , t = self.conn:query ( self.collection , self.query , self.returnfields , self.numberToSkip + self.i, self.numberToReturn)
		if self.id == "\0\0\0\0\0\0\0\0" then
			self.done = true
		end
	else
		self.id , self.results , t = self.conn:getmore ( self.collection , self.id , 0 , self.numberToSkip + self.i )
		if self.id == "\0\0\0\0\0\0\0\0" then
			self.done = true
		elseif t.CursorNotFound then
			self.id = false
		end
	end
  
	return self:next ( )
end

function cursor_methods:pairs ( )
	return self.next , self
end

function cursor_methods:all ( )
	local ret = {}
  for i, v in self:pairs() do
    t_insert(ret, v)
  end
  return ret
end

function cursor_methods:each (func)
	assert(func, '#2 must be function.')
	local ret = {}
  local r
  for i, v in self:pairs() do
    r = func(v)
    if r then 
      t_insert(ret, r)
    elseif r == false then
      break
    end
  end
  return ret
end



return new_cursor
