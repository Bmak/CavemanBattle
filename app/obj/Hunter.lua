local Hunter = {}

local container = nil
local view = nil

local speed = nil
local vx = nil
local vy = nil
local changeTime = nil
local targetX = nil
local targetY = nil
local distToTarget = nil
local currentDistToTarget = nil
local pauseMove = nil

function Hunter:create(sceneGroup)
	self.container = sceneGroup
	self.view = display.newImage("i/skin_1.png",0,0)
	self.view.x = display.contentCenterX
	self.view.y = display.contentCenterY

	sceneGroup:insert(self.view)
	self.speed = 100
	self.vx = 0
	self.vy = 0
	self.changeTime = 0
	self.distToTarget = 0
	self.currentDistToTarget = 0
	self.pauseMove = false
end

function Hunter:tick(event)
	if self.targetX == nil or self.targetY == nil then return end
	if self.pauseMove == true then return end


	self.changeTime = event.time - self.changeTime
	local coef = self.changeTime / 30 / 1000


	local dx = self.targetX - self.view.x
	local dy = self.targetY - self.view.y
	local d = math.sqrt( dx*dx + dy*dy )

	if (d ~= 0) then
		self.vx = (dx / d) * self.speed;
		self.vy = (dy / d) * self.speed;
	end
	self.currentDistToTarget = d

	self.distToTarget = self.distToTarget - math.abs(self.distToTarget - self.currentDistToTarget);
    if (self.distToTarget <= 0) then
		self:stopMoving()
	end


	-- print (coef .. " delta time." )
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
	-- transition.cancel(self.view)
	-- transition.to(self.view, { time=d/self.speed*1000,x=dx,y=dy })
	self.pauseMove = false
	self.targetX = x
	self.targetY = y
	self.distToTarget = self:getDistance(x,y)

end


--         _dstToTarget -= Math.abs(_dstToTarget - _currentDstToTarget);
--         if (_dstToTarget <= 0)
--          this.stopMoving();
-- _dstToTarget -- это мы сохраняем когда начинаем движение
-- _currentDstToTarget -- это каждый тик высчитывается

return Hunter