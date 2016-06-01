local new = require 'class'
local geo = require 'geo'
local Entity = require 'entity'


local SnakeTail = new.class(Entity, Entity.Box, Entity.Stubs)

function SnakeTail:init(head, tailsize, dr)
  local pos = geo.vec2(head.rect.pos)
  local dx = geo.vec2(dr)
  Entity.init(self, pos + dx, 1, 1)
  Entity.Box.init(self, { 255, 255, 255 }, { 0.8, 0.8 })

  self.head = head
  if tailsize > 1 then
    self.tail = new(SnakeTail, self, tailsize - 1, dr)
  end
end

function SnakeTail:update(dt)
  if self.tail then
    self.tail:update(dt)
  end
end

function SnakeTail:draw()
  Entity.Box.draw(self)
  if self.tail then self.tail:draw() end
end


local SnakeHead = new.class(Entity, Entity.Box, Entity.Stubs)

function SnakeHead:init(x, y)
  Entity.init(self, x, y, 1, 1)
  Entity.Box.init(self, { 255, 255, 255 }, { 0.8, 0.8 })

  self.tail = new(SnakeTail, self, 4, geo.LEFT)
end

function SnakeHead:update(dt)
  while dt > 1 do
    dt = dt - 1
    self.tail:update(1)
    Entity.update(self, 1)
  end
end

function SnakeHead:draw()
  Entity.Box.draw(self)
  self.tail:draw()
end


return SnakeHead
