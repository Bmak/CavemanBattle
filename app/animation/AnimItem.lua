
local AnimItem = {}

function AnimItem:new()
	local params = {
		name = nil,
		anim = nil,
		animBack = nil,
		priority = nil,
		playOnce = nil,
        isBack = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end

function AnimItem:create(name,options,priority,playOnce,ftime)
	self.name = name
	self.priority = priority
	self.playOnce = playOnce
    self.isBack = options.back
    local t = 500
    if ftime ~= nil then t = ftime end
 
	local seqData_f = 
	{
        { name="running", start=1, count=options.frames, time=t }
    }
    local sheetData_f = {
    	width=options.w,
    	height=options.h,
    	numFrames=options.frames,
    	sheetContentWidth=options.cw,
    	sheetContentHeight=options.ch
    }
    local sheet_f = graphics.newImageSheet( options.img, sheetData_f )
    self.anim = display.newSprite( sheet_f, seqData_f )
    if options.scale ~= nil then
    	self.anim.xScale = options.scale
    	self.anim.yScale = options.scale
    end
    -- self.anim:toBack( )
    -- anim:play( )

    -- if back == nil then return self end

	-- local seqData_b = 
	-- {
 --        { name="running", start=1, count=back.frames, time=500 }
 --    }
 --    local sheetData_b = {
 --    	width=back.w,
 --    	height=back.h,
 --    	numFrames=back.frames,
 --    	sheetContentWidth=back.cw,
 --    	sheetContentHeight=back.ch
 --    }
 --    local sheet_b = graphics.newImageSheet( back.img, sheetData_b )
 --    self.animBack = display.newSprite( sheet_b, seqData_b )
 --    if back.scale ~= nil then
 --    	self.animBack.xScale = back.scale
 --    	self.animBack.yScale = back.scale
 --    end
    -- self.animBack:toBack( )
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