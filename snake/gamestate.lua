local new = require 'class'
local geo = require 'geo'
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

  self.started = false
  self.score = 0
  self.timer = 0

  self:bind('keypressed', 'home', 'evpop')
  self:bind('keypressed', '=', function(self) self.entities[1]:insert() end)

  self:bind('keypressed', 'left', 'evmove', geo.LEFT)
  self:bind('keypressed', 'right', 'evmove', geo.RIGHT)
  self:bind('keypressed', 'up', 'evmove', geo.UP)
  self:bind('keypressed', 'down', 'evmove', geo.DOWN)
end

function GameState:update(dt)
  self.timer = self.timer + dt
  if self.started and self.timer > (1 / (1 + self.score * 0.1)) then
    self.timer = self.timer - 1
    for _, e in ipairs(self.entities) do
      e:update(1)
    end
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

function GameState:evmove(_, dr)
  self.entities[0].vel = geo.vec2(dr)
end


return GameState
