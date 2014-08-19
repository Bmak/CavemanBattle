local Stone = require("app.obj.Stone")
local ObjectControl = {}

local container = nil
local objects = nil
local hero = nil

local addObjectTimer = nil
local currentAddObjectTime = nil
local lastTime = nil

function ObjectControl:create(group)
	self.container = group

	self.addObjectTimer = 2000
	self.currentAddObjectTime = 2000
	self.lastTime = 0

	self.objects = {}
	self:initStones()
end

function ObjectControl:setHero(obj)
	self.hero = obj
end

function ObjectControl:initStones()
	for i=1,15 do
		self:addObject()
	end
end

function ObjectControl:addObject()
	local stone = Stone:new()
	stone:create(self.container)
	stone.view.x = math.round(math.random(50, self.container.width-50))
	stone.view.y = math.round(math.random(50, self.container.height-50))
	stone.view.xScale = 0.3
	stone.view.yScale = 0.3
	transition.to( stone.view, {time=500,xScale=1.5,yScale=1.5,transition=easing.inOutBack} )
	table.insert( self.objects, stone )
end

function ObjectControl:tick(event)
	if table.maxn( self.objects ) >= 30 then return end

	if self.lastTime == 0 then self.lastTime = event.time end
	local delta = event.time - self.lastTime
	self.lastTime = event.time

	self.currentAddObjectTime = self.currentAddObjectTime - delta
	if self.currentAddObjectTime <= 0 then
		self:addObject()
		self.currentAddObjectTime = self.addObjectTimer
	end
end

function ObjectControl:destroy()
	for k,obj in pairs(self.objects) do
		obj:destroy()
	end
	self.objects = nil
	self.hero = nil
end

return ObjectControl