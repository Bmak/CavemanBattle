local MovingControl = {}

local objects = nil
local lastTime = nil

function MovingControl:init( ... )
	self.objects = {}
	self.lastTime = 0
end

function MovingControl:tick(event)
	local coef = (event.time - self.lastTime) / display.fps
	self.lastTime = event.time
	for i,obj in pairs(self.objects) do
		
		-- if obj.targetX == nil or obj.targetY == nil then return end
		-- if obj.pauseMove == true then return end

		if (obj.targetY ~= nil or obj.targetY ~= nil) and obj.pauseMove == false then
			local currentDistToTarget = self:getDistance(obj,obj.targetX,obj.targetY)

			obj.distToTarget = obj.distToTarget - math.abs(obj.distToTarget - currentDistToTarget);
		    if (obj.distToTarget <= 0) then
				obj:stopMoving()
			end

			obj.view.x = obj.view.x + obj.vx * coef;
			obj.view.y = obj.view.y + obj.vy * coef;
		end
		obj.tick(event)
	end
end

function MovingControl:getDistance(obj,x,y)
	local dx = x - obj.view.x
	local dy = y - obj.view.y
	local delta = math.sqrt( dx*dx + dy*dy )
	return delta
end

function MovingControl:add(obj)
	table.insert( self.objects, obj )
end

function MovingControl:remove(obj)
	table.remove( self.objects, table.indexOf( self.objects, obj) )
end

return MovingControl