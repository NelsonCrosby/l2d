local new = require 'class'
local Entity = require 'entity'


local Tail = new.class(Entity)

function Tail:init(head, n, direction)
  local x = head.x
  local y = head.y
  if direction == 'l' or direction == nil then x = head.x - head.w
  elseif direction == 'r' then x = head.x + head.w
  elseif direction == 'u' then y = head.y - head.h
  elseif direction == 'd' then y = head.y + head.h
  end
  Entity.init(self, x, y, head.w, head.h)
  self.head = head
  if n > 0 then
    self.tail = new(Tail, self, n - 1, direction)
  end
end

function Tail:update(dt)
  -- By updating the tail first, we can just move
  -- each segment to where its head is
  if self.tail then self.tail:update(dt) end
  self.x = self.head.x
  self.y = self.head.y
end

function Tail:draw()
  love.graphics.rectangle('fill', self.x + 1, self.y + 1, self.w - 2, self.h - 2)
  if self.tail then self.tail:draw() end
end

function Tail:insert()
  if self.tail then
    return self.tail:insert()
  else
    local direction
    if self.head.x > self.x then direction = 'l'
    elseif self.head.x < self.x then direction = 'r'
    elseif self.head.y > self.y then direction = 'u'
    elseif self.head.y < self.y then direction = 'd'
    end
    self.tail = new(Tail, self, 0, direction)
  end
end

function Tail:collides(r)
  return Entity.collides(self, r) or (self.tail and self.tail:collides(r))
end


local Player = new.class(Entity)

function Player:init(...)
  Entity.init(self, ...)
  self.dx = 0
  self._timer = 0
  self.speed = 2.5
  self.tail = new(Tail, self, 5)
end

function Player:update(dt)
  if self.dx == 0 and self.dy == 0 then return end
  self._timer = self._timer + dt
  local invspeed = 1 / self.speed
  while self._timer > invspeed do
    self._timer = self._timer - invspeed
    self.tail:update(1)
    Entity.update(self, 1)
  end
end

function Player:draw()
  if self.dead then love.graphics.setColor(255, 0, 0)
  else love.graphics.setColor(255, 255, 255)
  end
  love.graphics.rectangle('fill', self.x + 1, self.y + 1, self.w - 2, self.h - 2)
  self.tail:draw()
end

function Player:bitTail()
  return self.tail:collides({ x = self.x + self.dx, y = self.y + self.dy })
end


return Player
