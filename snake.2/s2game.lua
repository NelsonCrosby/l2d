local new = require 'class'
local State = require 'state'
local GameState = require 'gamestate'


local S2Game = new.class(State)

function S2Game:enter()
  self:bind('keypressed', 'escape', 'evcancel')

  self.m:pushnew(GameState)
end

function S2Game:evcancel()
  love.event.quit()
end


return S2Game
