local Player = {}


local bar = require("app.BarControl")
local MovingControl = require("app.MovingControl")


function Player:new( ... )
	local params = {
		container = nil,
		view = nil,
		speed = nil,
		vx = nil,
		vy = nil,
		lastTime = nil,
		targetX = nil,
		targetY = nil,
		distToTarget = nil,
		currentDistToTarget = nil,
		pauseMove = nil,
		bulletsCount = nil,
		name = nil,
		shootDelay = nil,
		currentDelay = nil,
		tap = nil,
		R_Time = nil,
		C_Time = nil,
		isDead = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end


function Player:create(group, type)
	self.container = group
	local id = math.round(math.random(2,4))
	local skin = "i/mskin_"..id..".png"
	if type == "hero" then
		skin = "i/skin_1.png"
	end
	self.view = display.newImage(skin,0,0)
	self.view.x = display.contentCenterX
	self.view.y = display.contentCenterY

	self.container:insert(self.view)
	self.speed = 10
	self.vx = 0
	self.vy = 0
	self.lastTime = 0
	self.distToTarget = 0
	self.currentDistToTarget = 0
	self.pauseMove = true

	self.bulletsCount = 0
	self.shootDelay = 1000
	self.currentDelay = 1000


	self.R_Time = 2500
	self.C_Time = 2500
	self.isDead = false

	self.name = type

	local function killTouch(event)
		return true
	end
	self.view:addEventListener( "touch", killTouch )
end

local function checkForResp(self, delta )
	if self.isDead == true then
		self.C_Time = self.C_Time - delta
		if self.C_Time <= 0 then
			self.C_Time = self.R_Time
			self.isDead = false
			transition.cancel(self.view)
			self.view:removeSelf( )
			local id = math.round(math.random(2,4))
			local skin = "i/mskin_"..id..".png"
			self.view = display.newImage(skin,x,y)
			self.view.alpha = 1
			self.container:insert(self.view)

			if self.name == "bot" then
				self:initBotStrategy()
			end
		end
	end
end

function Player:tick(delta)
	checkForResp(self,delta)

	self.currentDelay = self.currentDelay + delta
	if self.bulletsCount > 0 and self.currentDelay >= self.shootDelay and self.isDead == false then
		local target = MovingControl:getTarget(self)
		if target ~= nil then
			local x,y = target.view:localToContent( 0, 0 )
			if x < 0 or y < 0 then return end
			self.currentDelay = 0
			MovingControl:shoot(self,target)
		end
	end
end

function Player:initBotStrategy()
	local maxX = self.container.width - 100
	local maxY = self.container.height - 100
	self.view.x = math.random(150,maxX)
	self.view.y = math.random(150,maxY)

	self:randomMove()
end

function Player:randomMove()
	local maxX = self.container.width - 100
	local maxY = self.container.height - 100
	self:move(math.random(100,maxX),math.random(100,maxY))
end

function Player:addBullet(value)
	self.bulletsCount = self.bulletsCount + value
	if self.name == "hero" then
		bar:setWeapCount(self.bulletsCount)
	end 
end
function Player:removeBullet(value)
	self.bulletsCount = self.bulletsCount - value
	if self.name == "hero" then
		bar:setWeapCount(self.bulletsCount)
	end 
end

function Player:stopMoving()
	self.pauseMove = true
	self.vx = 0
	self.vy = 0

	if self.name == "bot" and self.isDead == false then
		self:randomMove()
	end

	if self.tap ~= nil then
		self.tap:removeSelf()
		self.tap = nil
	end
end

function Player:kill(bullet)
	if self.name == "hero" then return end

	self.isDead = true
	self:stopMoving()
	local x = self.view.x
	local y = self.view.y
	self.view:removeSelf( )
	self.view = display.newImage("i/md_enemy.png",x,y)
	self.container:insert(self.view)
	transition.to( self.view, {time=1000,alpha=0} )
	
	if bullet.parent.name == "hero" then
		local kills = bar:getKills() + 1
		bar:setKills(kills)
	end
end

function Player:move(x,y)
	if self.name == "hero" then
		if self.tap ~= nil then
			self.tap:removeSelf()
		end
		self.tap = display.newImage("i/tap.png",x,y)
		self.tap.alpha = 0.7
		self.container:insert(self.tap)
		self.view:toFront( )
	end

	self.pauseMove = false
	self.targetX = x
	self.targetY = y
	
	local dx = self.targetX - self.view.x
	local dy = self.targetY - self.view.y
	local d = math.sqrt( dx*dx + dy*dy )

	if (d ~= 0) then
		self.vx = (dx / d) * self.speed;
		self.vy = (dy / d) * self.speed;
	end

	self.distToTarget = d
end

function Player:destroy()
	-- body
end

return Player