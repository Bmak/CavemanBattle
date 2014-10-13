local Window = {}

local composer = require("composer")

local shadow = nil
local window = nil

function Window:showInfoWindow(message)
	self.window = display.newGroup( )
	local rect = display.newImage("i/window.png",0,0)
	if rect.width > display.pixelHeight - 100 then
		rect.xScale = display.pixelHeight/rect.width - 0.2
	end
	if rect.height > display.pixelWidth - 100 then
		rect.yScale = display.pixelWidth/rect.height - 0.2
	end
	rect.x = display.contentCenterX
	rect.y = display.contentCenterY
	self.window:insert(rect)

	local title = display.newText( message, 0, 0, "ARIAL", 55 )
	title:setFillColor( 0,0,0 )
	title.x = display.contentCenterX
	title.y = display.contentCenterY
	self.window:insert(title)

	self:setOptions()
	self.window.alpaha=0
	self.window.y = self.window.y - 50

	composer.stage:insert(self.window)

	self:show()
end

function Window:setOptions()
	self.shadow = display.newRect(0,0,display.pixelHeight,display.pixelWidth)
	self.shadow:setFillColor(0,0.75)
	self.shadow.x = display.contentCenterX
	self.shadow.y = display.contentCenterY

	local function killTouches(event)
		return true
	end
	self.shadow:addEventListener( "touch", killTouches )
	self.shadow:addEventListener( "tap", killTouches )


	composer.stage:insert(self.shadow)

	local function close(event)
		if event.phase == "began" then
			self:hide()
		end
		return true
	end
	self.window:addEventListener( "touch", close )
end

function Window:show()
  transition.to( self.window, {time=200,alpha=1,y = self.window.y + 50} )
end

function Window:hide()
	local function destr()
		self:destroy()
	end
  transition.to( self.window, {time=200,alpha=0,y = self.window.y - 50,onComplete=destr} )
end

function Window:destroy()
	self.window:removeSelf()
	self.shadow:removeSelf( )
end

return Window