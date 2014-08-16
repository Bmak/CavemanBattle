local TileMap = {}

local tiles = nil
local mapCont = nil
local container = nil

function TileMap:create(group)
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





return TileMap