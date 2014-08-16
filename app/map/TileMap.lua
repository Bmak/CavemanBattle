local TileMap = {}

local tiles = nil
local mapCont = nil
local container = nil
local lastTime = nil
local paralaxSpeed = nil
local hero = nil

function TileMap:create(group)
	self.lastTime = 0
	self.paralaxSpeed = 0.5

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

	self:createByMap(mapData,9,6)

end

function TileMap:createByMap(map, width, height)
	self.tiles = {}

	for i=1,width do
		local subtiles = {}
		for j=1,height do
			local tile = display.newImage("i/ground1.png",0,0)
			tile.x = tile.width*i - tile.width/2
			tile.y = tile.height*j - tile.height/2
			table.insert( subtiles, tile )
			self.mapCont:insert(tile)
		end
		table.insert( self.tiles, subtiles )
	end
	self.container:insert(self.mapCont)
end

function TileMap:setHero(obj)
	self.hero = obj
end

function TileMap:tick(event)
	local coef = (event.time - self.lastTime) / display.fps
	self.lastTime = event.time
	if self.hero.vx == 0 and self.hero.vy == 0 then return end

	local dx, dy = self.hero.view:localToContent(0, 0)
	-- print(dx,dy)
	-- if math.round(dx) < display.pixelHeight/2 + 10 and math.round(dx) > display.pixelHeight/2 - 10 then 
		self.mapCont.x = self.mapCont.x - self.hero.vx*coef
		-- print("CHANGE X")
	-- end
	-- if math.round(dy) < display.pixelWidth/2 + 10 and math.round(dy) > display.pixelWidth/2 - 10 then 
		self.mapCont.y = self.mapCont.y - self.hero.vy*coef
		-- print("CHANGE Y")
	-- end

	if self.mapCont.x < display.pixelHeight - self.mapCont.width then
	 	self.mapCont.x = display.pixelHeight - self.mapCont.width
	end
	if self.mapCont.x > 0 then self.mapCont.x = 0 end
	if self.mapCont.y > 0 then self.mapCont.y = 0 end
	if self.mapCont.y < display.pixelWidth - self.mapCont.height then 
		self.mapCont.y = display.pixelWidth - self.mapCont.height
	end

end




return TileMap