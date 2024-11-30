Object = {}

function Object:new (o)
    o = {me = o or {}}
    o.__super = self
    self.__index = self
    setmetatable(o, self)
    return o
end
