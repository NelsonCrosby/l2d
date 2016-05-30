local new = require 'class'
local Entity = require 'entity'


local Tail = new.class(Entity)

function Tail:init(head, n)
  Entity.init(self, head.x - head.w, head.y, head.w, head.h)
  self.head = head
  if n > 0 then
    self.tail = new(Tail, self, n - 1)
  end
end

function Tail:update(dt)
  if self.tail then self.tail:update(dt) end
  self.x = self.head.x
  self.y = self.head.y
end

function Tail:draw()
  if self.tail then self.tail:draw() end
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('fill', self.x + 1, self.y + 1, self.w - 2, self.h - 2)
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
  self._timer = self._timer + dt
  local invspeed = 1 / self.speed
  while self._timer > invspeed do
    self._timer = self._timer - invspeed
    self.tail:update(1)
    Entity.update(self, 1)
  end
end

function Player:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('fill', self.x + 1, self.y + 1, self.w - 2, self.h - 2)
  self.tail:draw()
end


return Player
