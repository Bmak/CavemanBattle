
local AnimItem = {}

function AnimItem:new()
	local params = {
		name = nil,
		anim = nil,
		animBack = nil,
		priority = nil,
		playOnce = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end

function AnimItem:create(name,forward,back,priority,playOnce)
	self.name = name
	self.priority = priority
	self.playOnce = playOnce

	local seqData_f = 
	{
        { name="running", start=1, count=forward.frames, time=500 }
    }
    local sheetData_f = {
    	width=forward.w,
    	height=forward.h,
    	numFrames=forward.frames,
    	sheetContentWidth=forward.cw,
    	sheetContentHeight=forward.ch
    }
    local sheet_f = graphics.newImageSheet( forward.img, sheetData_f )
    self.anim = display.newSprite( sheet_f, seqData_f )
    if forward.scale ~= nil then
    	self.anim.xScale = forward.scale
    	self.anim.yScale = forward.scale
    end
    self.anim:toBack( )
    -- anim:play( )

    if back == nil then return self end

	local seqData_b = 
	{
        { name="running", start=1, count=back.frames, time=500 }
    }
    local sheetData_b = {
    	width=back.w,
    	height=back.h,
    	numFrames=back.frames,
    	sheetContentWidth=back.cw,
    	sheetContentHeight=back.ch
    }
    local sheet_b = graphics.newImageSheet( back.img, sheetData_b )
    self.animBack = display.newSprite( sheet_b, seqData_b )
    if back.scale ~= nil then
    	self.animBack.xScale = back.scale
    	self.animBack.yScale = back.scale
    end
    self.animBack:toBack( )
    -- self.animBack:play( )

    return self
end

function AnimItem:stop()
	anim:pause()
	if (animBack) then
		animBack:pause()
	end
end

return AnimItem