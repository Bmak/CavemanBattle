local Stone = require("app.obj.Stone")
local ObjectControl = {}

local container = nil
local objects = nil
local hero = nil

function ObjectControl:create(group)
	self.container = group

	self.objects = {}
	self:initStones()
end

function ObjectControl:setHero(obj)
	self.hero = obj
end

function ObjectControl:initStones()
	for i=1,15 do
		local stone = Stone:new()
		stone:create(self.container)
		stone.view.x = math.round(math.random(50, self.container.width-50))
		stone.view.y = math.round(math.random(50, self.container.height-50))
		-- stone.view.x = math.round(math.random(50, 250))
		-- stone.view.y = math.round(math.random(50, 250))
		table.insert( self.objects, stone )
	end
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
	-- for k,obj in pairs(self.objects) do
	-- 	if self:hasCollided(obj.view,self.hero.view) then
	-- 		table.remove(self.objects,k)
	-- 		obj.view:removeSelf( )
	-- 		obj = nil
	-- 		self.hero:addBullet(5)
	-- 	end
	-- end
end



return ObjectControl