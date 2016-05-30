local new = require 'class'
local Entity = require 'entity'
local Player = require 'player'


local Game = new.class()

function Game:init()
  self.player = new(Player, 10, 10)
end

function Game:update(dt)
  self.player:update(dt)
end

function Game:draw()
  self.player:draw()
end

function Game:keypressed(k, s, r)
  if k == 'right' then
    self.player.dx = 10
    self.player.dy = 0
  elseif k == 'left' then
    self.player.dx = -10
    self.player.dy = 0
  elseif k == 'down' then
    self.player.dx = 0
    self.player.dy = 10
  elseif k == 'up' then
    self.player.dx = 0
    self.player.dy = -10
  end
end


return Game
