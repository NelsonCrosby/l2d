local geo = {}
local mt = {}

geo.LEFT = 1
geo.RIGHT = 2
geo.UP = 3
geo.DOWN = 4

geo.vec2 = {}
setmetatable(geo.vec2, geo.vec2)
function geo.vec2.__call(_, x, y)
  if type(x) == 'number' and y == nil then
    return geo.vec2(geo.vec2[x])
  end

  local v
  if type(x) == 'table' then
    if x[1] and x[2] then
      v = { x[1], x[2] }
    else
      v = { x.x or x.w or x.width,
      x.y or x.h or x.height }
    end
  else
    v = { x, y }
  end

  return setmetatable(v, mt.vec2)
end

geo.vec2[geo.LEFT] = geo.vec2(-1, 0)
geo.vec2[geo.RIGHT] = geo.vec2(1, 0)
geo.vec2[geo.UP] = geo.vec2(0, -1)
geo.vec2[geo.DOWN] = geo.vec2(0, 1)
geo.vec2.left = geo.vec2[geo.LEFT]
geo.vec2.right = geo.vec2[geo.RIGHT]
geo.vec2.up = geo.vec2[geo.UP]
geo.vec2.down = geo.vec2[geo.DOWN]

geo.rect = {}
setmetatable(geo.rect, geo.rect)
function geo.rect.__call(_, x, y, w, h)
  local r = setmetatable({}, mt.rect)

  if type(x) == 'table' and y1 == nil then
    if type(x[1]) == 'table' then
      r[1] = geo.vec2(x[1])
      r[2] = geo.vec2(x[2])
    else
      r[1] = geo.vec2(x)
      if x[3] then
        r[2] = geo.vec2(x[3], x[4])
      elseif type(y) == 'table' then
        r[2] = geo.vec2(y)
      else
        r[2] = geo.vec2(y, w)
      end
    end
  elseif type(x) == 'table' then
    r[1] = geo.vec2(x)
    if type(y) == 'table' then
      r[2] = geo.vec2(y)
    else
      r[2] = geo.vec2(y, w)
    end
  else
    r[1] = geo.vec2(x, y)
    if type(w) == 'table' then
      r[2] = geo.vec2(w)
    else
      r[2] = geo.vec2(w, h)
    end
  end

  return r
end


mt.vec2 = {
  xwords = { x = true, w = true, width = true },
  ywords = { y = true, h = true, height = true }
}

function mt.vec2.__index(v, k)
  if mt.vec2.xwords[k] then return v[1]
  elseif mt.vec2.ywords[k] then return v[2]
  end
end

function mt.vec2.__newindex(v, k, n)
  if mt.vec2.xwords[k] then v[1] = n
  elseif mt.vec2.ywords[k] then v[2] = n
  else rawset(v, k, n)
  end
end

function mt.vec2.__add(u, v)
  return geo.vec2(u[1] + v[1], u[2] + v[2])
end

function mt.vec2.__sub(u, v)
  return geo.vec2(u[1] - v[1], u[2] - v[2])
end

function mt.vec2.__mul(u, v)
  if type(v) == 'number' then
    return geo.vec2(u[1] * v, u[2] * v)
  else
    return geo.vec2(u[1] * v[1], u[2] * v[2])
  end
end

function mt.vec2.__div(u, v)
  if type(v) == 'number' then
    return geo.vec2(u[1] / v, u[2] / v)
  end
end

function mt.vec2.__eq(u, v)
  return u[1] == v[1] and u[2] == v[2]
end

function mt.vec2.__tostring(v)
  return 'vec2(' .. tostring(v[1]) .. ', ' .. tostring(v[2]) .. ')'
end


mt.rect = {
  xwords = { p = true, pos = true },
  ywords = { s = true, size = true },
  proto = {}
}

function mt.rect.__index(r, k)
  if mt.rect.xwords[k] then return r[1]
  elseif mt.rect.ywords[k] then return r[2]
  else return mt.rect.proto[k]
  end
end

function mt.rect.__newindex(r, k, v)
  if mt.rect.xwords[k] then r[1] = v
  elseif mt.rect.ywords[k] then r[2] = v
  else rawset(r, k, v)
  end
end

function mt.rect.__tostring(r)
  return 'rect(' .. tostring(r[1]) .. ', ' .. tostring(r[2]) .. ')'
end

local function between(l, p)
  return p >= l[1] and p <= l[2]
end

local function inside(r, p)
  return between({ r.pos.x, r.pos.x + r.size.w }, p.x) and
    between({ r.pos.y, r.pos.y + r.size.h }, p.y)
end

function mt.rect.proto.collides(r, s)
  return inside(r, s.pos) or
    inside(r, s.pos + s.size) or
    inside(r, s.pos + geo.vec2(s.size.w, 0)) or
    inside(r, s.pos + geo.vec2(0, s.size.h))
end

return geo
