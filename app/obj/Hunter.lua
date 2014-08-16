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
end

function Hunter:tick(event)
	local coef = (event.time - self.lastTime) / display.fps
	self.lastTime = event.time
	if self.targetX == nil or self.targetY == nil then return end
	if self.pauseMove == true then return end
	

	self.currentDistToTarget = self:getDistance(self.targetX,self.targetY)

	self.distToTarget = self.distToTarget - math.abs(self.distToTarget - self.currentDistToTarget);
    if (self.distToTarget <= 0) then
		self:stopMoving()
	end

	local newX = self.view.x + self.vx * coef;
	local newY = self.view.y + self.vy * coef;

	self.view.x = newX
	self.view.y = newY
end

function Hunter:stopMoving()
	self.pauseMove = true
	self.vx = 0
	self.vy = 0
end


function Hunter:getDistance(x,y)
	local dx = x - self.view.x
	local dy = y - self.view.y
	local delta = math.sqrt( dx*dx + dy*dy )
	return delta
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