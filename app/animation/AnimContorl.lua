
local AnimControl = {}

animations = nil

function AnimControl:create()
	self.animations = {}

	self:addPlayerAnimations()
end

function AnimControl:addPlayerAnimations()
	
end

function addAnimation(animation)
	if self.animations == nil then
		self.animations = {}
	end
	table.insert( self.animations, animation )
end



return AnimControl