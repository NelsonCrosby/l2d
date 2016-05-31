local new = require 'class'


local Entity = new.class()

function Entity:init(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.dx = 0
  self.dy = 0
end

function Entity:update(dt)
  self.x = self.x + (self.dx * dt)
  self.y = self.y + (self.dy * dt)
end

function Entity:collides(r)
  -- Not really an accurate collides function,
  -- but sufficient for Snake which runs on a grid
  return self.x == r.x and self.y == r.y
end

function Entity:inbounds(bounds)
  return self.x >= bounds.x1 and (self.x + self.w) <= bounds.x2
      and self.y >= bounds.y1 and (self.y + self.h) <= bounds.y2
end


return Entity
