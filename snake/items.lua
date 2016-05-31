local new = require 'class'
local Entity = require 'entity'


local items = {}

items.Item = new.class(Entity)


items.Food = new.class(items.Item)

function items.Food:init(x, y)
  local w, h = love.window.getMode()
  if x == nil then x = math.random(0, math.floor(w / 10)) end
  if y == nil then y = math.random(0, math.floor(h / 10)) end
  Entity.init(self, x * 10, y * 10, 10, 10)
end

function items.Food:draw()
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle('fill', self.x + 2, self.y + 2, self.w - 4, self.h - 4)
end


return items
