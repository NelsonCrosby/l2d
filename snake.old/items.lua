local new = require 'class'
local Entity = require 'entity'


local items = {}

items.Item = new.class(Entity)


items.Food = new.class(items.Item)

function items.Food:init(bounds)
  local x = math.floor(math.random(bounds.x1, bounds.x2) / 10) * 10
  local y = math.floor(math.random(bounds.y1, bounds.y2) / 10) * 10
  Entity.init(self, x, y, 10, 10)
end

function items.Food:draw()
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle('fill', self.x + 2, self.y + 2, self.w - 4, self.h - 4)
end


return items
