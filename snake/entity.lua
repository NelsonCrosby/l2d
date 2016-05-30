local new = require 'class'


local Entity = new.class()

function Entity:init(x, y)
  self.x = x
  self.y = y
  self.dx = 0
  self.dy = 0
end

function Entity:update(dt)
  self.x = self.x + (self.dx * dt)
  self.y = self.y + (self.dy * dt)
end


return Entity
