local Stone = require("app.obj.Stone")
local ObjectControl = {}

local container = nil
local objects = nil

function ObjectControl:create(group)
	self.container = group

	self.objects = {}
	self:initStones()
end

function ObjectControl:initStones()
	for i=1,20 do
		local stone = Stone:new()
		stone:create()
		math.random( )
		stone.view.x = math.round(math.random(50, self.container.width-50))
		stone.view.y = math.round(math.random(50, self.container.height-50))
		self.container:insert(stone.view)
		table.insert( self.objects, stone )

	end
end

return ObjectControl