local new = require 'class'
local Camera = require 'camera'
local State = require 'state'


local GameCamera = new.class(Camera)

function GameCamera:init()
  Camera.init(self)
  self.transform.scale.x = 10
  self.transform.scale.y = 10
end


local GameState = new.class(State)

function GameState:enter()
  self.cam = new(GameCamera)
end

function GameState:update(dx)
  local camvel = { x = 0, y = 0 }
  local camspd = 250 * dx
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
    love.graphics.rectangle('fill', 10.1, 10.1, 0.8, 0.8)
  end)
end


return GameState
