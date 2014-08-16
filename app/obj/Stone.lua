local Stone = {}

function Stone:new()
	local params = {
		view = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end

function Stone:create()
	self.view = display.newImage("i/stone.png",0,0)
end



return Stone