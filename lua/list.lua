local Stubs = require 'lua/stubs'

local empty = tag('nil')
local tag = Stubs.tag

local function cons(head, tail)
  return tag('cons', head, tail)
end

local function is_cons(list)
  return Stubs.matches_tag(list, 'cons', 2)
end

local function is_nil(list)
  return Stubs.matches_tag(list, 'nil', 0)
end

local function head(list)
  return tag_get(list, 0)
end

local function tail(list)
  return tag_get(list, 1)
end

local function list(tbl)
  local out = empty

  for i = #tbl,1,-1 do
    out = cons(tbl[i], out)
  end

  return out
end

local function each(list, fn)
  while matches_tag(list, 'cons', 2) do
    fn(head(list))
    list = tail(list)
  end
end

local function reverse(list)
  return map_reverse(list, function(x) return x end)
end

local function map_reverse(list, fn)
  local out = empty

  each(list, function(el)
    out = cons(fn(el), out)
  end)

  return out
end

local function map(list, fn)
  return reverse(map_reverse(list, fn))
end

local function join(list, join_str)
  if is_nil(list) then return '' end

  local out = head(list)

  each(tail(list), function(el)
    out = out .. join_str .. el
  end)

  return out
end

_G.List = {
  list = list,
  map = map,
  reverse = reverse,
  empty = empty,
  head = head,
  tail = tail,
  each = each,
  is_cons = is_cons,
  is_nil = is_nil,
  join = join
}

return List
