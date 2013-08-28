local mongol = require 'mongol'
local conn = mongol()
require 'lglib'

db = conn:use('test_new')


db:drop('Person')
local n = db:count('Person', {})
assert(n == 1, '[Error] insert fail.')
print('n', n)

db:insert('Person', {{name="aaa"}})
local n = db:count('Person', {})
assert(n == 1, '[Error] insert fail.')
print('n', n)

db:drop('Person');
local n = db:count('Person', {})
assert(n == 0, '[Error] drop fail.')
print('n', n)



