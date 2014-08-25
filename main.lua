---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- require the composer library
local composer = require "composer"

composer.recycleOnSceneChange = true

-- load scenetemplate.lua
composer.gotoScene( "app.MenuScene" )

local flag = true
-- flag = false
pb = function (mess)
	if flag then
		print(mess)
	end
end

pb('```````````````````````````````````````````````````````')

pb("SYSTEM "..system.getInfo('platformName'))