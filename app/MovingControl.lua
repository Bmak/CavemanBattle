local MovingControl = {}

local container = nil

local players = nil
local bullets = nil
local allMovingObjects = nil
local lastTime = nil
local Stone = require("app.obj.Stone")
local F = require("app.F")
local weapFlag = nil
local weapResp = nil
local weapCurrResp = nil


function MovingControl:init(group)
	self.container = group

	self.weapons = {}
	self.players = {}
	self.bullets = {}
	self.allMovingObjects = {}
	self.lastTime = 0
end

function MovingControl:initWeapons()
	self.weapFlag = true
	self.weapResp = 20000
	self.weapCurrResp = 20000

	for i=1,12 do
		self:addWeapon()
	end
end

function MovingControl:tick(event)
	if self.lastTime == 0 then self.lastTime = event.time end
	local delta = event.time - self.lastTime
	local coef = (event.time - self.lastTime) / display.fps
	self.lastTime = event.time
	for i,obj in pairs(self.allMovingObjects) do
		if (obj.targetY ~= nil or obj.targetY ~= nil) and obj.pauseMove == false then
			local currentDistToTarget = F:getDistance(obj,obj.targetX,obj.targetY)

			obj.distToTarget = obj.distToTarget - math.abs(obj.distToTarget - currentDistToTarget);
		    if (obj.distToTarget <= 0) then
				obj:stopMoving()
			end
			if obj.name == "bullet" and obj.isDead == true then
				table.remove( self.allMovingObjects, table.indexOf( self.allMovingObjects, obj) )
			end

			if obj.pauseMove == false then
				obj.view.x = obj.view.x + obj.vx * coef
				obj.view.y = obj.view.y + obj.vy * coef
			end
		end
		obj:tick(delta)
		if obj.name == "bullet" and obj.pauseMove == false then
			self:checkHitBullet(obj)
		elseif obj.name == "bot" or obj.name == "hero" then
			self:checkPickUpBullet(obj)
		end
		if obj.logout ~= nil and obj.logout == true then
			table.remove( self.allMovingObjects, table.indexOf( self.allMovingObjects, obj) )
		end
		if self.weapFlag == true then
			self:checkForAddWeapon(delta)
		end
	end
end


function MovingControl:checkForAddWeapon(delta)
	if table.maxn( self.weapons ) > 12 then return end
	self.weapCurrResp = self.weapCurrResp - delta
	if self.weapCurrResp <= 0 then
		self.weapCurrResp = self.weapResp
		self:addWeapon()
	end
end

function MovingControl:checkHitBullet(bullet)
	for k,obj in pairs(self.players) do
		if bullet.parent ~= nil and bullet.parent ~= obj and obj.isDead == false and obj.view.alpha == 1 then 
			if F:hasCollided( obj.view, bullet.view ) then
				self:removeBullet(bullet)
				bullet:stopMoving()
				-- self:removePlayer(obj)
				obj:kill(bullet)
			end
		end
	end
end

function MovingControl:checkPickUpBullet(obj)
	if obj.bulletsCount >= obj.maxBullets then return end

	for k,weapon in pairs(self.weapons) do
		if F:hasCollided(obj.view,weapon.view) and obj.isDead == false then
			table.remove(self.weapons,k)
			obj:addBullet(3,weapon.view.x,weapon.view.y)
			weapon:destroy()
			return
		end
	end
end

function MovingControl:addWeapon(x,y)
	local stone = Stone:new()
	stone:create(self.container,true)
	if x and y then
		stone.view.x = x
		stone.view.y = y
	else
		stone.view.x = math.round(math.random(50, self.container.width-50))
		stone.view.y = math.round(math.random(50, self.container.height-50))
	end
	stone.view.xScale = 0.3
	stone.view.yScale = 0.3
	transition.to( stone.view, {time=500,xScale=1.5,yScale=1.5,transition=easing.inOutBack} )
	table.insert( self.weapons, stone )
end

function MovingControl:removeWeapon(x,y)
	for k,wep in pairs(self.weapons) do
		if wep.view.x == x and wep.view.y == y then
			wep:destroy()
			table.remove( self.weapons, k )
			return
		end
	end
end

function MovingControl:addPlayer(obj)
	table.insert( self.players, obj )
	table.insert( self.allMovingObjects, obj )
end

function MovingControl:removePlayer(obj)
	table.remove( self.players, table.indexOf( self.players, obj) )
	obj:destroy()
	-- table.remove( self.allMovingObjects, table.indexOf( self.allMovingObjects, obj) )
end

function MovingControl:addBullet(obj)
	table.insert( self.bullets, obj )
	table.insert( self.allMovingObjects, obj )
end

function MovingControl:removeBullet(obj)
	table.remove( self.bullets, table.indexOf( self.bullets, obj) )
	-- table.remove( self.allMovingObjects, table.indexOf( self.allMovingObjects, obj) )
end

function MovingControl:getTarget(obj)
	local minDist = nil
	local currentVictim = nil
	for k,victim in pairs(self.players) do
		if victim ~= obj and victim.isDead == false and victim.view.alpha == 1 then
			local dist = F:getDistance(victim,obj.view.x,obj.view.y)
			if minDist == nil or minDist > dist then
				minDist = dist
				currentVictim = victim
			end
		end
	end
	return currentVictim
end

function MovingControl:shoot(fromObj,x2,y2)
	local bullet = Stone:new()
	bullet:create(self.container)
	bullet.view.x = fromObj.view.x
	bullet.view.y = fromObj.view.y
	bullet:move(x2,y2)
	self:addBullet(bullet)
	bullet.parent = fromObj
end

function MovingControl:destroy()
	self.allMovingObjects = nil
	for k,player in pairs(self.players) do
		player:destroy()
	end
	self.players = nil
	for i,bullet in pairs(self.bullets) do
		bullet:destroy()
	end
	self.bullets = nil
	for i,weapon in pairs(self.weapons) do
		weapon:destroy()
	end
	self.weapons = nil
end

function MovingControl:getPlayer(id)
	for k,player in pairs(self.players) do
		if id == player.id then
			return player
		end
	end
	return nil
end

return MovingControl