---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

-- hide the status bar
-- display.setStatusBar( display.HiddenStatusBar )

-- require the composer library
local composer = require "composer"

composer.recycleOnSceneChange = true

-- load scenetemplate.lua
composer.gotoScene( "app.MenuScene" )

print('```````````````````````````````````````````````````````')


print("SYSTEM "..system.getInfo('platformName'))

