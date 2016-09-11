local new = require 'class'
local geo = require 'geo'

local Morsel = require 'food'


local World = new.class()

function World:init(state)
  self.state = state
  self.food = {}
end

function World:eat(i)
  self.state:point(1)
  table.remove(self.food, i)
end

function World:draw()
  for _, m in ipairs(self.food) do
    m:draw()
  end
end


World.Random = new.class(World)

function World.Random:init(...)
  World.init(self, ...)
  self:genfood(1)
end

function World.Random:genfood(n)
  for i = 1, n do
    local pos = geo.vec2(math.random(50), math.random(50))
    table.insert(self.food, new(Morsel, pos))
  end
end

function World.Random:eat(i)
  World.eat(self, i)
  self:genfood(1)
end


return World
