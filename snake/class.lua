local META = {
  NAME = 'l2d.class',
  AUTHOR = 'Nelson Crosby <nelsonc@sourcecomb.com>',
  LICENSE = [[
The MIT License (MIT)

Copyright (c) 2016, Nelson Crosby <nelsonc@sourcecomb.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
  ]]
}


local fc = {}

function fc.new(cls, ...)
  local o = {}
  setmetatable(o, cls)
  if o.init == nil then o.init = function() end end
  return o:init(...) or o
end

function fc.class(proto, ...)
  proto.__index = proto

  for _, super in ipairs({...}) do
    for k, v in pairs(super) do
      if proto[k] == nil then proto[k] = v end
    end
  end

  return proto
end

if class_commons and common == nil then
  common = { instance = fc.new }
  function common.class(_, ...) return fc.class(...) end
  return common
else
  local new = {}
  setmetatable(new, { __call = function(_, ...) return fc.new(...) end })
  function new.class(...) return fc.class({}, ...) end
  return new
end
