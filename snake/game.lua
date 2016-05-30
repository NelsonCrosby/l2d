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


return Game
