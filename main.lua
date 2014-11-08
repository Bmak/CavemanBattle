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

local flag = true
-- flag = false
pb = function (mess)
	if flag then
		print(mess)
	end
end

composer.gotoScene( "app.MenuScene" )

if "Win" == system.getInfo( "platformName" ) then
    STONE = "HW Stone"
elseif "Android" == system.getInfo( "platformName" ) then
    STONE = "STONE"
else
    -- Mac and iOS
    STONE = "HW Stone"
end


-- local fonts = native.getFontNames()
-- count = 0
-- for i,fontname in ipairs(fonts) do
--     count = count+1
-- end
-- print( "\rFont count = " .. count )
-- local name = "pt"     -- part of the Font name we are looking for
-- name = string.lower( name )
-- for i, fontname in ipairs(fonts) do
--     print( "fontname = " .. tostring( fontname ) )
-- end

-- pb("window options "..xK.."/"..yK)
pb('```````````````````````````````````````````````````````')

pb("SYSTEM "..system.getInfo('platformName'))


