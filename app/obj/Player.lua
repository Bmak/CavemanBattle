local Player = {}


local bar = require("app.BarControl")
local MovingControl = require("app.MovingControl")
local F = require("app.F")
local SC = require("app.SocketControl")
local AnimBuild = require("app.animation.PlayerAnimBuilder")



function Player:new( ... )
	local params = {
		id = nil,
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
		isDead = nil,
		maxBullets = nil,
		animContainer = nil,
		isAnimating = nil,
		currentAnim = nil,
		nextAnimName = nil,
		isBack = nil,
		colors = nil,
		logout = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end


local function getSkin(stype)
	local skin = display.newImage("i/skin_1.png")
	-- if stype == "hero" then
	-- 	skin = "i/skin_1.png"
	-- else
	-- 	local id = math.round(math.random(2,4))
	-- 	skin = "i/mskin_"..id..".png"
	-- end
	return skin
end

function Player:create(group, type, id)
	self.container = group
	self.name = type
	self.id = id
	self.logout = false
	
	self.speed = 10
	self.vx = 0
	self.vy = 0
	self.lastTime = 0
	self.distToTarget = 0
	self.currentDistToTarget = 0
	self.pauseMove = true

	self.maxBullets = 20
	self.bulletsCount = 0
	self.shootDelay = 1000
	self.currentDelay = 1000

	self.R_Time = 2500
	self.C_Time = 2500
	self.isDead = false

	self.colors = { math.random()*0.9,math.random()*0.9,math.random()*0.9 }


	self.isAnimating = false

	if self.name ~= "player" then
		self.colors = {1,1,1}
		self:respawn()
	end
end

function Player:tick(delta)
	if self.isDead == true and self.name ~= "player" then 
		self:checkForResp(delta)
		return
	end

	if self.name == "player" then
		return
	end


	self.currentDelay = self.currentDelay + delta
	if self.bulletsCount > 0 and self.currentDelay >= self.shootDelay and self.isDead == false and self.view.alpha == 1 then
		local target = MovingControl:getTarget(self)
		if target ~= nil then
			local x,y = target.view:localToContent( 0, 0 )
			if x < 0 or y < 0 then return end
			self.currentDelay = 0
			-- MovingControl:shoot(self.view.x,self.view.y,target.view.x,target.view.y)
			self:throw(target.view.x,target.view.y)
			SC:throw(target.view.x,target.view.y)
		end
	end
end

function Player:throw(x,y)
	-- local function doThrow()
	MovingControl:shoot(self,x,y)
	self:removeBullet(1)
	-- end
	-- timer.performWithDelay( 100, doThrow, 1 )
	
	self:play("throw",self.isBack)
end

function Player:checkForResp(delta)
	self.C_Time = self.C_Time - delta
	if self.C_Time <= 0 then
		self.C_Time = self.R_Time
		self:respawn()
	end
end

function Player:respawn(x,y)
	self.isDead = false
	if self.view ~= nil then
		transition.cancel(self.view)
		self.view:removeSelf( )
	end
	
	self.view = display.newGroup( )
	self.view.x = x
	self.view.y = y
	self.animContainer = display.newGroup( )
	self.view:insert(self.animContainer)
	self.isBack = 0
	self:play("stay",self.isBack)
	self.view.alpha = 0.1
	transition.to( self.view, {time=2000, alpha=1} )
	-- local function complete( ... )
		-- transition.cancel(self.view)
	-- end
	-- transition.blink( self.view, { time=1000, onComplete=complete() } )
	self.container:insert(self.view)
	local function killTouch(event)
		return true
	end
	self.view:addEventListener( "touch", killTouch )

	if self.name == "player" and x ~= nil and y ~= nil then
		self.view.x = x
		self.view.y = y
	else
		local maxX = self.container.width - 100
		local maxY = self.container.height - 100
		self.view.x = math.random(150,maxX)
		self.view.y = math.random(150,maxY)
	end

	if self.name == "hero" then
		SC:reborn(self.view.x,self.view.y)
	elseif self.name == "bot" then
		self:smartBotStrategy()
	end
end

function Player:play(name,back)
	if self.currentAnim then
		local anim = self:getAnimByName(name,back)
		-- if self.currentAnim.name ~= anim.name and self.currentAnim.isBack ~= anim.isBack then
			if anim.playOnce == true then
				self.nextAnimName = self.currentAnim.name
			end
			self:playAnimation(anim)
		-- end
	else
		self:playAnimation(self:getAnimByName("stay",back))
	end
end

function Player:playAnimation(anim)
	if self.view == nil or self.animContainer == nil then
		anim.anim:removeSelf( )
		anim = nil
		return
	end

	if self.currentAnim and self.currentAnim.priority > anim.priority then
		self.nextAnimName = anim.name
		anim.anim:removeSelf( )
		anim = nil
		return
	elseif self.currentAnim and self.currentAnim.name == anim.name and self.currentAnim.isBack == anim.isBack then
		-- and self.currentAnim.playOnce == true 
		anim.anim:removeSelf( )
		anim = nil
		return
	end
	self:removeCurrentAnim()
	self.currentAnim = anim
	self.currentAnim.anim:setFillColor(self.colors[1],self.colors[2],self.colors[3])
	print("animepta "..self.name)
	print(self.view)
	print(self.animContainer)
	print(self.currentAnim)
	print(self.currentAnim.anim)
	print(self.currentAnim.anim.parent)
	print(self.nextAnimName)
	self.animContainer:insert(self.currentAnim.anim)
	self.currentAnim.anim:play()
	self.isAnimating = true

	if self.currentAnim.playOnce then
		local function onEndAnim(event)
			if event.phase == "loop" then
				self.currentAnim.anim:removeEventListener( "sprite", onEndAnim )

				if self.nextAnimName then
					self:removeCurrentAnim()
					self:play(self.nextAnimName,self.isBack)
					self.nextAnimName = nil
				end
			end
		end
		self.currentAnim.anim:addEventListener( "sprite", onEndAnim )
	end
end

function Player:removeCurrentAnim()
	if self.currentAnim ~= nil then
		-- print("remove animepta")
		-- print(self.view)
		-- print(self.currentAnim)
		-- print(self.currentAnim.anim)
		-- print(self.currentAnim.anim.parent)
		if self.currentAnim.anim.parent then
			self.currentAnim.anim:removeSelf()
		end
		
		self.currentAnim = nil
	end
end

function Player:getAnimByName(name, back)
	if name == "stay" then
		return AnimBuild:createAnimStay(back)
	elseif name == "move" then
		return AnimBuild:createAnimMove(back)
	elseif name == "throw" then
		return AnimBuild:createAnimThrow(back)
	elseif name == "pick" then
		return AnimBuild:createAnimPick(back)
	end
end

function Player:smartBotStrategy()
	if self.bulletsCount < 5 then
		local wep = self:findWeapon()
		if wep ~= nil then
			self:move(wep.view.x,wep.view.y)
		else 
			self:randomMove()
		end
	else
		self:randomMove()
	end
end

function Player:randomMove()
	local maxX = self.container.width - 100
	local maxY = self.container.height - 100
	self:move(math.random(100,maxX),math.random(100,maxY))
end

function Player:findWeapon()
	local minDist = nil
	local currentWeapon = nil
	local weapons = MovingControl.weapons
	for k,wep in pairs(weapons) do
		local d = F:getDistance(wep,self.view.x,self.view.y)
		if minDist == nil or minDist > d then
			minDist = d
			currentWeapon = wep
		end
	end
	return currentWeapon
end

function Player:addBullet(value,x,y)
	self.bulletsCount = self.bulletsCount + value
	self:play("pick",self.isBack)
	if self.name == "hero" then
		SC:pick(x,y)
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
		self:smartBotStrategy()
	end

	self:play("stay",self.isBack)

	if self.tap ~= nil then
		self.tap:removeSelf()
		self.tap = nil
	end
end

function Player:kill(bullet)
	-- if self.name == "hero" then return end
	
	-- if self.isDead == false then
	-- 	self:dead()
	-- end

	-- local kills = 0
	-- if bullet.parent.name == "hero" then
	-- 	kills = bar:getKills() + 1
	-- 	bar:setKills(kills)
	-- elseif self.name == "hero" then
	-- 	kills = bar:getKills() - 1
	-- 	bar:setKills(kills)
	-- 	SC:dead()
	-- end

	-- local kills = 0
	if self.name == "player" or self.name == "bot" then
		-- kills = bar:getKills() + 1
		-- bar:setKills(kills)
	elseif self.name == "hero" then
		-- kills = bar:getKills() - 1
		-- bar:setKills(kills)
		SC:dead(bullet.parent.id)
		self:dead()
	end
end

function Player:addPoint()
	kills = bar:getKills() + 1
	bar:setKills(kills)
end

function Player:dead()
	self.isDead = true
	self:stopMoving()
	local x = self.view.x
	local y = self.view.y
	self:removeCurrentAnim()
	self.view:removeSelf( )
	self.view = display.newImage("i/dead.png",x,y)
	self.container:insert(self.view)
	transition.to( self.view, {delay=100,time=300,y=self.view.y+50} )
	transition.to( self.view, {time=1000,alpha=0.1} )
end

function Player:move(x,y,action)
	if self.isDead == true then return end

	if action == nil then
		SC:move(x,y)
	end

	if self.name == "hero" then
		if self.tap ~= nil then
			self.tap:removeSelf()
		end
		self.tap = display.newImage("i/tap.png",x,y)
		self.tap.alpha = 0.7
		self.container:insert(self.tap)
		self.view:toFront()
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

	if dx > 0 then
		self.view.xScale = -1
	else
		self.view.xScale = 1
	end

	if dy > 0 then
		self:play("move",0)
		self.isBack = 0
	else
		self:play("move",1)
		self.isBack = 1
	end
end

function Player:destroy()
	self.logout = true
	local function complete( ... )
		if self.view then
			self.view:removeSelf( )
		end
		self.view = nil
		self.container = nil
	end
	transition.to( self.view, {time=1000,alpha=0,onComplete=complete()} )
end

return Player