---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = "MenuScene"

local composer = require( "composer" )

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view

    local bkg = display.newImage( "i/bkg.png", 0, 0 )
    bkg.width = 960
    bkg.height = 540
   	bkg.x = display.contentCenterX
   	bkg.y = display.contentCenterY
    sceneGroup:insert( bkg )


    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
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
        
        -- we obtain the object by id from the scene's object hierarchy
        local nextSceneButton = display.newImage("i/btn1.png",0,0)
        nextSceneButton.width = nextSceneButton.width*2
        nextSceneButton.height = nextSceneButton.height*2
        nextSceneButton.x = display.contentCenterX*2 - nextSceneButton.width/2
        nextSceneButton.y = display.contentCenterY*2 - nextSceneButton.height 
        sceneGroup:insert( nextSceneButton )

    	function nextSceneButton:touch ( event )
    		local phase = event.phase
    		if "ended" == phase then
    			composer.gotoScene( "app.GameScene", { effect = "fade", time = 300 } )
    		end
    	end
    	-- add the touch event listener to the button
    	nextSceneButton:addEventListener( "touch", nextSceneButton )
        
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
