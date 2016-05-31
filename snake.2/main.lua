local new = require 'class'
local State = require 'state'
local S2Game = require 's2game'


local m

function love.load()
  m = new(State.Machine)
  m:pushnew(S2Game)
end

function love.update(dt)
  m:activeState():update(dt)
end

function love.draw()
  m:activeState():draw()
end

function love.keypressed(k, s, r)
  m:activeState():keypressed(k, s, r)
end

function love.quit()
  while #m.stack > 1 do
    m:pop()
  end
  m:activeState():leave()
end
