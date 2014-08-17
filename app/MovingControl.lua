local MovingControl = {}

local container = nil

local players = nil
local bullets = nil
local allMovingObjects = nil
local lastTime = nil
local Stone = require("app.obj.Stone")
local ObjectControl = require("app.ObjectControl")


function MovingControl:init(group)
	self.container = group

	self.players = {}
	self.bullets = {}
	self.allMovingObjects = {}
	self.lastTime = 0
end

function MovingControl:tick(event)
	local delta = event.time - self.lastTime
	local coef = (event.time - self.lastTime) / display.fps
	self.lastTime = event.time
	for i,obj in pairs(self.allMovingObjects) do
		
		if (obj.targetY ~= nil or obj.targetY ~= nil) and obj.pauseMove == false then
			local currentDistToTarget = self:getDistance(obj,obj.targetX,obj.targetY)

			obj.distToTarget = obj.distToTarget - math.abs(obj.distToTarget - currentDistToTarget);
		    if (obj.distToTarget <= 0) then
				obj:stopMoving()
				if (obj.name == "bullet") then
					self:removeBullet(bullet)
				end
			end

			if obj.pauseMove == false then
				obj.view.x = obj.view.x + obj.vx * coef
				obj.view.y = obj.view.y + obj.vy * coef
			end
		end
		obj:tick(delta)
		if obj.name == "bullet" and obj.pauseMove == false then
			self:checkHitBullet(obj)
		end
	end
end

function MovingControl:checkHitBullet(bullet)
	for k,obj in pairs(self.players) do
		if bullet.parent ~= nil and bullet.parent ~= obj then 
			if ObjectControl:hasCollided( obj.view, bullet.view ) then
				self:removeBullet(bullet)
				self:removePlayer(obj)
				bullet:stopMoving()
				obj:kill()
			end
		end
	end
end

function MovingControl:getDistance(obj,x,y)
	local dx = x - obj.view.x
	local dy = y - obj.view.y
	local delta = math.sqrt( dx*dx + dy*dy )
	return delta
end

function MovingControl:addPlayer(obj)
	table.insert( self.players, obj )
	table.insert( self.allMovingObjects, obj )
end

function MovingControl:removePlayer(obj)
	table.remove( self.players, table.indexOf( self.players, obj) )
	table.remove( self.allMovingObjects, table.indexOf( self.allMovingObjects, obj) )
end

function MovingControl:addBullet(obj)
	table.insert( self.bullets, obj )
	table.insert( self.allMovingObjects, obj )
end

function MovingControl:removeBullet(obj)
	table.remove( self.bullets, table.indexOf( self.bullets, obj) )
	table.remove( self.allMovingObjects, table.indexOf( self.allMovingObjects, obj) )
end

function MovingControl:getTarget(obj)
	local minDist = nil
	local currentVictim = nil
	for k,victim in pairs(self.players) do
		if victim ~= obj then
			local dist = self:getDistance(victim,obj.view.x,obj.view.y)
			if minDist == nil or minDist > dist then
				minDist = dist
				currentVictim = victim
			end
		end
	end
	return currentVictim
end

function MovingControl:shoot(fromObj,toObj)
	local bullet = Stone:new()
	bullet:create(self.container)
	bullet.view.x = fromObj.view.x
	bullet.view.y = fromObj.view.y
	bullet:move(toObj.view.x,toObj.view.y)
	self:addBullet(bullet)
	fromObj:removeBullet(1)
	bullet.parent = fromObj
end

return MovingControl