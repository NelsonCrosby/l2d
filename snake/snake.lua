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
  self.rect.pos = geo.vec2(self.head.rect.pos)
end

function SnakeTail:draw()
  Entity.Box.draw(self)
  if self.tail then self.tail:draw() end
end

function SnakeTail:insert()
  if self.tail then
    return self.tail:insert()
  else
    local dx = self.rect.pos - self.head.rect.pos
    self.tail = new(SnakeTail, self, 1, dx)
  end
end


local SnakeHead = new.class(Entity, Entity.Box, Entity.Stubs)

function SnakeHead:init(x, y)
  Entity.init(self, x, y, 1, 1)
  Entity.Box.init(self, { 255, 255, 255 }, { 0.8, 0.8 })

  self.tail = new(SnakeTail, self, 4, geo.LEFT)
end

function SnakeHead:update(dt)
  self.tail:update(dt)
  Entity.update(self, dt)
end

function SnakeHead:draw()
  self.tail:draw()
  Entity.Box.draw(self)
end

function SnakeHead:insert()
  self.tail:insert()
end


return SnakeHead
