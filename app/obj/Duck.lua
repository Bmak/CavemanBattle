local Duck = {}



function Duck:new( ... )
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
		name = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end


function Duck:create(group)
	self.container = group
	local id = math.round(math.random(2,4))
	self.view = display.newImage("i/skin_2.png",0,0)
	self.view.xScale = 0.5
	self.view.yScale = 0.5
	self.view.x = display.contentCenterX
	self.view.y = display.contentCenterY

	self.container:insert(self.view)
	self.speed = 3
	self.vx = 0
	self.vy = 0
	self.lastTime = 0
	self.distToTarget = 0
	self.currentDistToTarget = 0
	self.pauseMove = true
	self.name = "duck"..math.round(math.random()*4)
end

function Duck:tick( ... )
	
end

function Duck:stopMoving()
	self.pauseMove = true
	self.vx = 0
	self.vy = 0
end

function Duck:move(x,y)
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

return Duck