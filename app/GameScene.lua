---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = GameScene

local composer = require( "composer" )
local tileMap = require("app.map.TileMap")
local player = require("app.obj.Player")
-- local Duck = require("app.obj.Duck")
local objControl = require("app.ObjectControl")
local movingControl = require("app.MovingControl")
local barControl = require("app.BarControl")

local hunter = nil

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
end

function scene:onHunterMove(event)
	if event.phase == "moved" or event.phase == "began" then
		hunter:move(event.x - tileMap.mapCont.x,event.y - tileMap.mapCont.y)
	end
end

function scene:worldTick( event )
    movingControl:tick(event)
    tileMap:tick(event)
    objControl:tick(event)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc


        tileMap:create(sceneGroup)
        objControl:create(tileMap.mapCont)
        movingControl:init(tileMap.mapCont)

        hunter = player:new()
        hunter:create(tileMap.mapCont, "hero")
        tileMap:setHero(hunter)
        objControl:setHero(hunter)
        movingControl:addPlayer(hunter)

        barControl:create(sceneGroup)

        for i=1,4 do
            local duck = player:new()
            duck:create(tileMap.mapCont, "bot")
            duck:randomMove()
            movingControl:addPlayer(duck)
        end


        local function moveTouch(event)
        	self:onHunterMove(event)
        end
        local function onTick(event)
        	self:worldTick(event)
        end
        tileMap.mapCont:addEventListener( "touch", moveTouch )
      	Runtime:addEventListener( "enterFrame", onTick )
    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
        -- Called when the scene is now off screen
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
