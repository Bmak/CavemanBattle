---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = "MenuScene"

local composer = require( "composer" )
local bezier = require("app.bezier")
local stone = require("app.obj.Stone")
local socket = require("socket")

require("app.noobhub")

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

    -- hub = noobhub.new({ server = "http://get-id.ru/websocket"; port = 8080; });

    -- -- local client = socket.connect( "www.apple.com", 80 )
    -- local client = socket.connect( "http://get-id.ru/websocket", 80 )
    -- local client = socket.connect( "get-id.ru", 8080 )
    
    
    -- Get IP and port from client
    -- local ip, port = client:getsockname()

    -- -- Print the IP address and port to the terminal
    -- print( "IP Address:", ip )
    -- print( "Port:", port )

    -- function networkListener( event )
    --     print( "address", event.address )
    --     print( "isReachable", event.isReachable )
    --     print( "isConnectionRequired", event.isConnectionRequired )
    --     print( "isConnectionOnDemand", event.isConnectionOnDemand )
    --     print( "IsInteractionRequired", event.isInteractionRequired )
    --     print( "IsReachableViaCellular", event.isReachableViaCellular )
    --     print( "IsReachableViaWiFi", event.isReachableViaWiFi )
    --     -- If you want to remove the listener, call network.setStatusListener( "www.apple.com", nil ) 
    -- end

    -- if ( network.canDetectNetworkStatusChanges ) then
    --     network.setStatusListener( "get-id.ru", networkListener )
    -- else
    --     print( "Network reachability not supported on this platform." )
    -- end

    -- local st = stone:new()
    -- st:create(sceneGroup)
    -- st.view.x = 100
    -- st.view.y = 100
    -- local curve = bezier:curve({100, 200, 300}, {100, 200, 100})

    -- local i = 0.01
    -- local function onTick( ... )
    --     local x, y = curve(i)
    --     i = i + 0.01
    --     st.view.x = x
    --     st.view.y = y
    --     if i >= 1 then
    --         i = 0.01
    --     end
    -- end
    -- Runtime:addEventListener( "enterFrame", onTick )


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
