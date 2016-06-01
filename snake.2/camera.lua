local new = require 'class'
local geo = require 'geo'


local Camera = new.class()

function Camera:init()
  self.transform = {
    scale = geo.vec2(0, 0),
    translate = geo.vec2(0, 0),
    rotate = 0
  }
end

function Camera:move(x, y)
  local tr = self.transform.translate
  tr.x = tr.x - x
  tr.y = tr.y - y
end

function Camera:apply()
  local tr = self.transform.translate
  love.graphics.translate(tr.x, tr.y)
  local rt = self.transform.rotate
  love.graphics.rotate(rt)
  local sc = self.transform.scale
  love.graphics.scale(sc.x, sc.y)
end

function Camera:with(f)
  love.graphics.push()
  self:apply()
  f()
  love.graphics.pop()
end


return Camera
