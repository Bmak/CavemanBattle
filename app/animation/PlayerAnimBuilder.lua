local anim = require("app.animation.AnimItem")
local PlayerAnimBuilder = {}

function PlayerAnimBuilder:createAnimMove(a_type)
	local animation = anim:new()
	local options = nil
	if a_type == 0 then
		options = {
			back = false,
			frames = 12,
			w = 60,
			h = 96,
			img = "i/anim/run_f.png",
			cw = 256,
			ch = 512,
			scale = 1.2
		}
	elseif a_type == 1 then
		options = {
			back = true,
			frames = 13,
			w = 60,
			h = 96,
			img = "i/anim/run_b.png",
			cw = 256,
			ch = 512,
			scale = 1.2
		}
	end
	
	return animation:create("move",options,0,false)
end

function PlayerAnimBuilder:createAnimStay(a_type)
	local animation = anim:new()
	local options = nil
	if a_type == 0 then
		options = {
			back = false,
			frames = 3,
			w = 46.5,
			h = 91.5,
			img = "i/anim/stay_f.png",
			cw = 128,
			ch = 256,
			scale = 1.2
		}
	elseif a_type == 1 then
		options = {
			back = true,
			frames = 6,
			w = 47,
			h = 91.5,
			img = "i/anim/stay_b.png",
			cw = 256,
			ch = 256,
			scale = 1.2
		}
	end
	
	return animation:create("stay",options,0,false)
end

function PlayerAnimBuilder:createAnimThrow(a_type)
	local animation = anim:new()
	local options = nil
	if a_type == 0 then
		options = {
			back = false,
			frames = 7,
			w = 89,
			h = 90,
			img = "i/anim/throw_f.png",
			cw = 256,
			ch = 512,
			scale = 1.2
		}
	elseif a_type == 1 then
		options = {
			back = true,
			frames = 8,
			w = 89,
			h = 90,
			img = "i/anim/throw_b.png",
			cw = 256,
			ch = 512,
			scale = 1.2
		}
	end
	
	return animation:create("throw",options,1,true)
end

function PlayerAnimBuilder:createAnimPick(a_type)
	local animation = anim:new()
	local options = nil
	options = {
		back = false,
		frames = 7,
		w = 51,
		h = 91,
		img = "i/anim/pickup.png",
		cw = 256,
		ch = 256,
		scale = 1.2
	}
	
	
	return animation:create("pick",options,1,true)
end

return PlayerAnimBuilder