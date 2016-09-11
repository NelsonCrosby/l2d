local new = require 'class'
local geo = require 'geo'

local Entity = require 'entity'


local Morsel = new.class(Entity, Entity.Box, Entity.Stubs)

function Morsel:init(pos)
  Entity.init(self, nil, pos, 0.8, 0.8)
  Entity.Box.init(self, { 0, 255, 255 }, { 0.8, 0.8 })
end


return Morsel
