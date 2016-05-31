local new = require 'class'
local Entity = require 'entity'
local Player = require 'player'
local items = require 'items'


local Game = new.class()

function Game:init()
  local winw, winh = love.window.getMode()
  self.bounds = {
    x1 = 0, x2 = winw,
    y1 = 0, y2 = winh
  }
  self.player = new(Player, 400, 300, 10, 10)
  self.food = nil

  self.timer = 0
  self.running = true
end

function Game:update(dt)
  if self.running then
    self.player:update(dt)

    if self.food and self.player:collides(self.food) then
      self.food = nil
      self.player.tail:insert()
      self.player.speed = self.player.speed + 0.1
    end

    while self.food == nil do
      self.food = new(items.Food)
      if self.player:collides(self.food) then
        self.food = nil
      end
    end

    if not self.player:inbounds(self.bounds)
        or self.player:bitTail() then
      self.player.dead = true
      self.running = false
    end
  end
end

function Game:draw()
  self.player:draw()
  self.food:draw()
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
  elseif k == '=' then
    self.player.tail:insert()
  elseif k == 'escape' then
    love.event.quit()
  end
end


return Game
