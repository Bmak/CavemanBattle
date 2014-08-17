local MovingControl = require("app.MovingControl")
local BarControl = require("app.BarControl")

local Hunter = {}

local container = nil
local view = nil

local speed = nil
local vx = nil
local vy = nil
local lastTime = nil
local targetX = nil
local targetY = nil
local distToTarget = nil
local currentDistToTarget = nil
local pauseMove = nil
local name = nil


local bulletsCount = nil
local shootDelay = nil
local currentDelay = nil


function Hunter:create(group)
	self.container = group
	self.view = display.newImage("i/skin_1.png",0,0)
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
	self.name = "hero"

	self.bulletsCount = 0
	self.shootDelay = 1000
	self.currentDelay = 1000
end

function Hunter:tick(delta)
	self.currentDelay = self.currentDelay + delta
	if self.bulletsCount > 0 and self.currentDelay >= self.shootDelay then
		local target = MovingControl:getTarget(self)
		if target ~= nil then
			self.currentDelay = 0
			MovingControl:shoot(self,target)
		end
	end
end

function Hunter:addBullet(value)
	self.bulletsCount = self.bulletsCount + value
	BarControl:setWeapCount(self.bulletsCount)
end
function Hunter:removeBullet(value)
	self.bulletsCount = self.bulletsCount - value
	BarControl:setWeapCount(self.bulletsCount)
end

function Hunter:stopMoving()
	self.pauseMove = true
	self.vx = 0
	self.vy = 0
end

function Hunter:move(x,y)
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


return Hunter