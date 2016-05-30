local new = require 'class'
local Entity = require 'entity'


local Player = new.class(Entity)

function Player:init(...)
  Entity.init(self, ...)
  self.dx = 0
  self._timer = 0
  self.speed = 2.5
end

function Player:update(dt)
  self._timer = self._timer + dt
  local invspeed = 1 / self.speed
  while self._timer > invspeed do
    self._timer = self._timer - invspeed
    Entity.update(self, 1)
  end
end

function Player:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end


return Player
