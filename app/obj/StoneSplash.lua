local StoneSplash = {}

function StoneSplash:new()
	local params = {
		container = nil,
		group = nil,
		view = nil,
		list = nil,
		counter = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end

function StoneSplash:create(cont,x,y)
	self.container = cont
	self.group = display.newGroup( )
	self.group.x = x
	self.group.y = y

	self.container:insert(self.group)

	self.counter = 0
	local function destroy(e)
		self.counter = self.counter + 1
		if self.counter >= 4 then
			self.group:removeSelf( )
		end
	end


	self.list = {}
	for i=1,4 do
		local stone = display.newImage("i/stone.png",0,0)
		stone.xScale = 0.5
		stone.yScale = 0.5
		self.group:insert(stone)

		local nX = self:getOffSetX(i)
		local nY = self:getOffSetY(i)
		transition.to( stone, {time=500,x=stone.x+nX,y=stone.y+nY,alpha=0.3, onComplete=destroy} )
	end
	self.group.rotation = math.random( )*360
end

function StoneSplash:getOffSetX(index)
	if index == 1 then
		return -50
	elseif index == 2 then
		return 50
	elseif index == 3 then
		return 0
	elseif index == 4 then
		return 0
	end
end

function StoneSplash:getOffSetY(index)
	if index == 1 then
		return 0
	elseif index == 2 then
		return 0
	elseif index == 3 then
		return -50
	elseif index == 4 then
		return 50
	end
end

return StoneSplash