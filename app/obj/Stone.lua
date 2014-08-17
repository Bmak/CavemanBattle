local Stone = {}

function Stone:new()
	local params = {
		parent = nil,

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

function Stone:create(group)
	self.container = group
	self.view = display.newImage("i/stone.png",0,0)
	self.container:insert(self.view)

	self.speed = 15
	self.vx = 0
	self.vy = 0
	self.lastTime = 0
	self.distToTarget = 0
	self.currentDistToTarget = 0
	self.pauseMove = true
	self.name = "bullet"
end

function Stone:tick(event)
	if self.pauseMove then return end

	
end

function Stone:stopMoving()
	self.pauseMove = true
	self.vx = 0
	self.vy = 0

	-- TODO removeStone
	self.view:removeSelf( )
end

function Stone:move(x,y)
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


return Stone