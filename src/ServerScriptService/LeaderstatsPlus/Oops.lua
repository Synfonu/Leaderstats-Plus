local oops = {}

function oops:__call(...)
    local object = {}
    setmetatable(object, self)
   
    if self.__init then
        self.__init(object, ...)
    end

    return object
end

function oops.class(nc)
    nc.__index = nc
    return setmetatable(nc, oops)
end

return oops