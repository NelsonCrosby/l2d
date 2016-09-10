local new = require 'class'
local geo = require 'geo'

local vec2_11 = geo.vec2(1, 1)


local Entity = new.class()

function Entity:init(x, y, w, h)
  self.rect = geo.rect(x, y, w, h)
  self.vel = geo.vec2(0, 0)
end

function Entity:update(dt)
  self.rect.pos = self.rect.pos + (self.vel * dt)
end

function Entity:collides(r)
  return r:collides(self.rect)
end


Entity.Stubs = new.class()

function Entity.Stubs:draw()
end


Entity.Box = new.class()

function Entity.Box:init(color, size)
  if size == nil then size = geo.vec2(1, 1) end
  self._b = { color, geo.vec2(size) }
end

function Entity.Box:setcolor(c)
  self._b[1] = c
end

function Entity.Box:draw()
  local color = self._b[1]
  local size = self._b[2]
  local box = geo.rect(self.rect)
  box.pos = box.pos + ((vec2_11 - size) / 2)
  box.size = box.size * size
  love.graphics.setColor(color[1], color[2], color[3])
  love.graphics.rectangle('fill', box.pos[1], box.pos[2], box.size[1], box.size[2])
end


return Entity
