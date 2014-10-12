


local Stone = {}

local Splash = require("app.obj.StoneSplash")

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
		name = nil,
		isDead = nil,
		angle = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end

function Stone:create(group,weaponFlag)
	self.container = group
	if weaponFlag~=nil then
		self.view = display.newImage("i/stone_bunch.png",0,0)
	else
		self.view = display.newImage("i/stone.png",0,0)
	end
	self.container:insert(self.view)

	self.speed = 15
	self.vx = 0
	self.vy = 0
	self.lastTime = 0
	self.distToTarget = 0
	self.currentDistToTarget = 0
	self.pauseMove = true
	self.name = "bullet"
	self.isDead = false
	self.angle = 0
end

function Stone:tick(event)
	if self.pauseMove then return end

	-- self.view.angle = self.view.angle + 5
	self.view.rotation = self.view.rotation + 20
end

function Stone:stopMoving()
	self.pauseMove = true
	self.vx = 0
	self.vy = 0

	self.isDead = true
	-- TODO removeStone
	local function complete( ... )
		local spl = Splash:new()
		spl:create(self.container,self.view.x,self.view.y)
		self.view:removeSelf( )
	end
	transition.to( self.view, {time=1000,alpha=0,onComplete=complete()} )
end

function Stone:move(x,y)
	self.pauseMove = false
	self.targetX = x
	self.targetY = y
	
	local dx = self.targetX - self.view.x
	local dy = self.targetY - self.view.y
	local d = math.sqrt( dx*dx + dy*dy )

	if (d ~= 0) then
		self.vx = (dx / d) * self.speed
		self.vy = (dy / d) * self.speed
	end

	self.distToTarget = d
end

function Stone:destroy()
	if self.view and self.view.parent then
		self.view:removeSelf()
	end
	self.view = nil
	self.container = nil
end


return Stone