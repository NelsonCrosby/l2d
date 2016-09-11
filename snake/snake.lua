local new = require 'class'
local geo = require 'geo'
local Entity = require 'entity'


local SnakeTail = new.class(Entity, Entity.Box, Entity.Stubs)

function SnakeTail:init(head, tailsize, dr)
  local pos = geo.vec2(head.rect.pos)
  local dx = geo.vec2(dr)
  Entity.init(self, head.world, pos + dx, 0.9, 0.9)
  Entity.Box.init(self, { 255, 255, 255 }, { 0.8888, 0.8888 })

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

function SnakeHead:init(world, x, y)
  Entity.init(self, world, x, y, 0.9, 0.9)
  Entity.Box.init(self, { 255, 255, 255 }, { 0.8888, 0.8888 })

  self.tail = new(SnakeTail, self, 4, geo.LEFT)
  self.dead = false
end

function SnakeHead:die()
  self.dead = true
  self:setcolor({ 255, 0, 0 })
end

function SnakeHead:update(dt, state)
  if not self.dead then
    if self:eattail() then
      self:die()
      return
    end
    self.tail:update(dt)
    Entity.update(self, dt)
    local food = self.world.food
    local i = 1
    while i <= #food do
      local morsel = food[i]
      if self:collides(morsel) then
        self.world:eat(i)
        self:insert()
      else
        i = i + 1
      end
    end
  end
end

function SnakeHead:draw()
  self.tail:draw()
  Entity.Box.draw(self)
end

function SnakeHead:insert()
  self.tail:insert()
end

function SnakeHead:reverse()
  return self.tail.rect.pos - self.rect.pos
end

function SnakeHead:eattail()
  local nextpos = geo.rect(self.rect.pos + self.vel, self.rect.size)
  local tail = self.tail
  while tail do
    if tail:collides(nextpos) then return true end
    tail = tail.tail
  end
  return false
end

return SnakeHead
