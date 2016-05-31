local new = require 'class'


local EV_HANDLER_IFNONE = -1
local EV_HANDLER_ALWAYS = -2

local State = new.class()

function State:init(m)
  self.m = m
  self.events = {}
end

function State:enter()
end

function State:leave()
end

function State:pause()
end

function State:resume()
end

function State:update(dt)
end

function State:draw()
end

function State:keypressed(k, s, r)
  self:_evhandle('keypressed', k, r)
end

function State:bind(evtype, evdetail, f)
  return self:_evbind(evtype, evdetail, f)
end

function State:_evget(evtype, evdetail)
  local evc = self.events[evtype]
  if not evc then
    evc = {}
    self.events[evtype] = evc
  end

  local ev = evc[evdetail]
  if not ev then
    ev = {}
    evc[evdetail] = ev
  end

  return ev
end

function State:_evbind(evtype, evdetail, f)
  table.insert(self:_evget(evtype, evdetail), f)
end

function State:_evhandle(evtype, evdetail, ...)
  local ev = self:_evget(evtype, evdetail)
  local handled = false

  local function callall(ft, ...)
    if ft then
      for _, f in ipairs(ft) do
        if type(f) == 'string' then f = self[f] end
        if type(f) == 'function' then
          f(self, ...)
          handled = true
        end
      end
    end
  end

  callall(ev, ...)

  if not handled then
    ev = self:_evget(evtype, EV_HANDLER_IFNONE)
    callall(ev, ...)
  end

  ev = self:_evget(evtype, EV_HANDLER_ALWAYS)
  callall(ev, ...)

  return handled or self._mp:_evhandle(evtype, evdetail, ...)
end


State.Machine = new.class(State)

function State.Machine:init()
  State.init(self)
  self.stack = {}
end

function State.Machine:push(s)
  local current = self:activeState()
  if current then current:pause() end
  table.insert(self.stack, s)
  s._mp = current or new.nilop
  s:enter()
end

function State.Machine:pop()
  local old = table.remove(self.stack)
  old:leave()
  old._mp = nil
  self:activeState():resume()
end

function State.Machine:pushnew(st, ...)
  self:push(new(st, self, ...))
end

function State.Machine:switch(s)
  self:pop()
  self:push(s)
end

function State.Machine:switchnew(...)
  self:pop()
  self:pushNew(...)
end

function State.Machine:activeState()
  return self.stack[#self.stack]
end


return State
