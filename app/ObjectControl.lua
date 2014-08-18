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

	self.addObjectTimer = 4000
	self.currentAddObjectTime = 4000
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
	stone.view.xScale = 0.1
	stone.view.yScale = 0.1
	transition.to( stone.view, {time=500,xScale=1.5,yScale=1.5,transition=easing.inOutBack} )
	table.insert( self.objects, stone )
end

--rectangle-based collision detection
function ObjectControl:hasCollided( obj1, obj2 )
   if ( obj1 == nil ) then  --make sure the first object exists
      return false
   end
   if ( obj2 == nil ) then  --make sure the other object exists
      return false
   end

   local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
   local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
   local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
   local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

   return (left or right) and (up or down)
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
	-- body
end

return ObjectControl