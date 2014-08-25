---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local bezier = require("app.bezier")
local stone = require("app.obj.Stone")

local nickTxt = nil

-- Load scene with same root filename as this file
local scene = composer.newScene(  )

---------------------------------------------------------------------------------

local function onSave()
    local saveData = composer.player

    local path = system.pathForFile( "cavemaninfo.txt", system.DocumentsDirectory )

    -- pb("SAVE "..path)

    local file = io.open( path, "w" )
    file:write( saveData )

    io.close( file )
    file = nil
end

local function onLoad(txt)
    local path = system.pathForFile( "cavemaninfo.txt", system.DocumentsDirectory )

    -- pb("LOAD "..path)

    local file = io.open( path, "r" )
    if file then
        composer.player = file:read( "*a" )

        io.close( file )
        file = nil
    else
        onSave()
    end
    txt.text = composer.player
end


function scene:create( event )
    local sceneGroup = self.view

    local bkg = display.newImage( "i/bkg.png", 0, 0 )
    bkg.width = 960
    bkg.height = 540
   	bkg.x = display.contentCenterX
   	bkg.y = display.contentCenterY
    sceneGroup:insert( bkg )

    local multiSceneBtn = display.newImage("i/multi.png",0,0)
    multiSceneBtn.width = multiSceneBtn.width*3
    multiSceneBtn.height = multiSceneBtn.height*3
    multiSceneBtn.x = display.contentCenterX + (bkg.width - multiSceneBtn.width)/2
    multiSceneBtn.y = display.contentCenterY + (bkg.height - multiSceneBtn.height)/2 - 20
    sceneGroup:insert( multiSceneBtn )

    local singleSceneBtn = display.newImage("i/single.png",0,0)
    singleSceneBtn.width = singleSceneBtn.width*3
    singleSceneBtn.height = singleSceneBtn.height*3
    singleSceneBtn.x = display.contentCenterX + (bkg.width - singleSceneBtn.width)/2
    singleSceneBtn.y = display.contentCenterY + (bkg.height - singleSceneBtn.height)/2 - 40 - multiSceneBtn.height
    sceneGroup:insert( singleSceneBtn )

    function goToGame ( event )
        local phase = event.phase
        if "began" == phase then
            if event.target == singleSceneBtn then
                composer.gameType = "single"
            elseif event.target == multiSceneBtn then
                composer.gameType = "multi"
            end

            composer.gotoScene( "app.GameScene", { effect = "fade", time = 300 } )

            onSave()
        end
    end
    -- add the touch event listener to the button
    multiSceneBtn:addEventListener( "touch", goToGame )
    -- add the touch event listener to the button
    singleSceneBtn:addEventListener( "touch", goToGame )




    
    local function textListener( event )
        pb(event.phase)
        if ( event.phase == "began" ) then
            -- user begins editing text field
            pb( event.text )
        elseif ( event.phase == "ended" or event.phase == "submitted" ) then
            -- text field loses focus
            -- do something with nickTxt's text
            pb( event.text )
        elseif ( event.phase == "editing" ) then
            pb( event.newCharacters )
            pb( event.oldText )
            pb( event.startPosition )
            pb( event.text )
            composer.player = event.text
        end
    end
    self.nickTxt = native.newTextField( display.contentCenterX, display.contentCenterY, 250, 70 )
    self.nickTxt.x = bkg.x - bkg.width/2 + self.nickTxt.width/2 + 20
    self.nickTxt.text = "player"
    self.nickTxt:addEventListener( "userInput", textListener )
    composer.player = "player"
    sceneGroup:insert(self.nickTxt)
    local titleText = display.newText( "Input your name:", display.contentCenterX, display.contentCenterY - 50, native.systemFont, 30 )
    titleText.x = self.nickTxt.x
    sceneGroup:insert(titleText)

    onLoad(self.nickTxt)





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
        composer.prevScene = composer.getSceneName("current")
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    sceneGroup:removeSelf( )
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
