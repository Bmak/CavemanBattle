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

xK = display.pixelHeight/1024
-- yK = display.pixelWidth/768

-- local flag = true
flag = false
pb = function (mess)
	if flag then
		print(mess)
	end
end

composer.gotoScene( "app.MenuScene" )

-- pb("window options "..xK.."/"..yK)
pb('```````````````````````````````````````````````````````')

pb("SYSTEM "..system.getInfo('platformName'))


