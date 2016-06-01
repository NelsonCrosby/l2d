local new = require 'class'
local Camera = require 'camera'
local State = require 'state'
local Entity = require 'entity'
local SnakeHead = require 'snake'


local GameCamera = new.class(Camera)

function GameCamera:init()
  Camera.init(self)
  self.transform.scale.x = 10
  self.transform.scale.y = 10
end


local GameState = new.class(State)

function GameState:enter()
  self.cam = new(GameCamera)
  self.entities = { new(SnakeHead, 10, 10) }
  self:bind('keypressed', 'home', 'evpop')
end

function GameState:update(dt)
  for _, e in ipairs(self.entities) do
    e:update(dt)
  end

  local camvel = { x = 0, y = 0 }
  local camspd = 250 * dt
  if love.keyboard.isDown('i') then
    camvel.y = -camspd
  end
  if love.keyboard.isDown('k') then
    camvel.y = camspd
  end
  if love.keyboard.isDown('j') then
    camvel.x = -camspd
  end
  if love.keyboard.isDown('l') then
    camvel.x = camspd
  end
  self.cam:move(camvel.x, camvel.y)
end

function GameState:draw()
  self.cam:with(function()
    for _, e in ipairs(self.entities) do
      e:draw()
    end
  end)
end

function GameState:evpop()
  self.m:pop()
end


return GameState
