local new = require 'class'
local Entity = require 'entity'
local Player = require 'player'


local Game = new.class()

function Game:init()
  local winw, winh = love.window.getMode()
  self.bounds = {
    x1 = 0, x2 = winw,
    y1 = 0, y2 = winh
  }
  self.player = new(Player, 10, 10, 10, 10)

  self.running = true
end

function Game:update(dt)
  if self.running then
    self.player:update(dt)

    if not self.player:inbounds(self.bounds) then
      self.running = false
    end
  end
end

function Game:draw()
  self.player:draw()
end

function Game:keypressed(k, s, r)
  if k == 'right' and self.player.dx == 0 then
    self.player.dx = 10
    self.player.dy = 0
  elseif k == 'left' and self.player.dx == 0 then
    self.player.dx = -10
    self.player.dy = 0
  elseif k == 'down' and self.player.dy == 0 then
    self.player.dx = 0
    self.player.dy = 10
  elseif k == 'up' and self.player.dy == 0 then
    self.player.dx = 0
    self.player.dy = -10
  end
end


return Game
