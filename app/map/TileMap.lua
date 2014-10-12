local TileMap = {}

local tiles = nil
local randomObjects = nil
local mapCont = nil
local container = nil
local lastTime = nil
local hero = nil

function TileMap:create(group)
	self.lastTime = 0

	self.container = group
	self.mapCont = display.newGroup( )
	local mapData = {}

	for i=1,10 do
		local mtrx = {}
		for i=1,6 do
			table.insert( mtrx, 0 )
		end
		table.insert( mapData, mtrx )
	end

	self:createByMap(mapData,15,15)
	self:addRandomObjects()
end

function TileMap:createByMap(map, width, height)
	self.tiles = {}

	for i=1,width do
		local subtiles = {}
		for j=1,height do
			local tile = display.newImage("i/ground.png",0,0)
			tile.x = tile.width*i - tile.width/2
			tile.y = tile.height*j - tile.height/2
			table.insert( subtiles, tile )
			self.mapCont:insert(tile)
		end
		table.insert( self.tiles, subtiles )
	end

	self.container:insert(self.mapCont)
end

function TileMap:addRandomObjects()
	self.randomObjects = {}

	local maxX = self.container.width - 50
	local maxY = self.container.height - 50

	for i=1,20 do
		local dot = display.newImage("i/dot.png",0,0)
		dot.x = math.random(50,maxX)
		dot.y = math.random(50,maxY)
		table.insert( self.randomObjects, dot )
		self.mapCont:insert(dot)
	end

	for i=1,1 do
		local pool = display.newImage("i/pool.png",0,0)
		pool.x = self.container.width/2
		pool.y = self.container.height/2
		-- pool.x = math.random(250,maxX-200)
		-- pool.y = math.random(250,maxY-200)
		table.insert( self.randomObjects, pool )
		self.mapCont:insert(pool)
	end
end

function TileMap:setHero(obj)
	self.hero = obj
end

local function checkEndMap(self)
	if self.mapCont.x < display.pixelHeight - self.mapCont.width then
	 	self.mapCont.x = display.pixelHeight - self.mapCont.width
	end
	if self.mapCont.x > 0 then self.mapCont.x = 0 end
	if self.mapCont.y > 0 then self.mapCont.y = 0 end
	if self.mapCont.y < display.pixelWidth - self.mapCont.height then 
		self.mapCont.y = display.pixelWidth - self.mapCont.height
	end
end

function TileMap:tick(event)
	local coef = (event.time - self.lastTime) / display.fps
	self.lastTime = event.time
	-- if self.hero.vx == 0 and self.hero.vy == 0 and self.hero.isDead == false then return end

	local lookAtX = 0
	local lookAtY = 0
	-- local a_x, a_y = self.hero.view:localToContent(0, 0)
	local a_x = self.hero.view.x
	local a_y = self.hero.view.y
	if a_x < display.pixelHeight/2 then
		lookAtX = 0
	elseif a_x > self.mapCont.width - display.pixelHeight/2 then
		lookAtX = self.mapCont.width - display.pixelHeight
	else
		lookAtX = -display.pixelHeight/2 + a_x
	end

	if a_y < display.pixelWidth/2 then
		lookAtY = 0
	elseif a_y > self.mapCont.height - display.pixelWidth/2 then
		lookAtY = self.mapCont.height - display.pixelWidth
	else
		lookAtY = -display.pixelWidth/2 + a_y
	end

	self.mapCont.x = -lookAtX
	self.mapCont.y = -lookAtY

	checkEndMap(self)
end

function TileMap:destroy( ... )
	self.tiles = nil
	self.mapCont:removeSelf( )
	self.mapCont = nil
	self.container = nil
	self.hero = nil
end




return TileMap