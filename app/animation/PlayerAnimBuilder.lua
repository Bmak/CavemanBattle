local anim = require("app.animation.AnimItem")
local PlayerAnimBuilder = {}

function PlayerAnimBuilder:createAnimMove()
	local animation = anim:new()
	local forward = {
		frames = 12,
		w = 60,
		h = 96,
		img = "i/anim/run_f.png",
		cw = 256,
		ch = 512,
		scale = 1.2
	}
	local back = {
		frames = 13,
		w = 60,
		h = 96,
		img = "i/anim/run_b.png",
		cw = 256,
		ch = 512,
		scale = 1.2
	}
	return animation:create("move",forward,back,0,false)
end


return PlayerAnimBuilder