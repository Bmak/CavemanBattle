---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local tileMap = require("app.map.TileMap")
local player = require("app.obj.Player")
-- local Duck = require("app.obj.Duck")
local objControl = require("app.ObjectControl")
local movingControl = require("app.MovingControl")
local barControl = require("app.BarControl")
local SC = require("app.SocketControl")

local hunter = nil

-- Load scene with same root filename as this file
local scene = composer.newScene(  )

---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view
    

    local uniq_id = system.getInfo('deviceID')
    print("ID "..uniq_id)

    print("TRY TO CONNECT")

    SC:connect()

    local function addP(e)
        print("ADD NEW PLAYER "..e.id)
        local pl = player:new()
        pl:create(tileMap.mapCont, "player", e.id)
        movingControl:addPlayer(pl)
        -- SC.listener:removeEventListener( "addNewPlayer", addP )
        -- SC:reborn(hunter.view.x,hunter.view.y)
        -- SC:move(hunter.targetX, hunter.targetY)
    end
    SC.listener:addEventListener( "addNewPlayer", addP )

    local function showMe(e)
        print("SHOW ME ")
        SC:reborn(hunter.view.x,hunter.view.y)
    end
    SC.listener:addEventListener( "showMe", showMe )

    print( "CREATE SCENE" )

    tileMap:create(sceneGroup)
    objControl:create(tileMap.mapCont)
    movingControl:init(tileMap.mapCont)

    hunter = player:new()
    hunter:create(tileMap.mapCont, "hero", system.getInfo('deviceID'))
    tileMap:setHero(hunter)
    objControl:setHero(hunter)
    movingControl:addPlayer(hunter)

    barControl:create(sceneGroup)

    SC:login()

    -- for i=1,1 do
    --     local duck = player:new()
    --     duck:create(tileMap.mapCont, "bot")
    --     duck:randomMove()
    --     movingControl:addPlayer(duck)
    -- end


    local function moveTouch(event)
        self:onHunterMove(event)
    end
    local function onTick(event)
        self:worldTick(event)
    end
    tileMap.mapCont:addEventListener( "touch", moveTouch )
    Runtime:addEventListener( "enterFrame", onTick )


    self:onShowMem()
end

function scene:onShowMem()
    local sceneGroup = self.view
    local text = display.newText( "mem: "..collectgarbage( "count" )/1000 .. " MB", 0, 0, native.systemFont, 20 )
    local text2 = display.newText( "texture: "..system.getInfo( "textureMemoryUsed" )*0.000001 .. " MB", 0, 0, native.systemFont, 20 )
    text.anchorX = 0
    text.anchorY = 0
    text.x = 10
    text.y = display.pixelWidth - 50
    text2.anchorX = 0
    text2.anchorY = 0
    text2.x = 10
    text2.y = display.pixelWidth - 25

    text:setFillColor(0, 0, 0)
    text2:setFillColor(0, 0, 0)
    sceneGroup:insert(text)
    sceneGroup:insert(text2)

    local function showMem()
        collectgarbage()
        text.text = "mem: "..collectgarbage( "count" )/1000 .. " MB"
        text2.text = "texture: "..system.getInfo( "textureMemoryUsed" )*0.000001 .. " MB"
    end

    timer.performWithDelay( 1000, showMem, 0 )
end

function scene:onHunterMove(event)
	-- if event.phase == "moved" or event.phase == "began" then
    if event.phase == "began" then
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
        print( "SHOW SCENE" )


        
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

        print( "HIDE SCENE" )

        tileMap.mapCont:removeEventListener( "touch", moveTouch )
        Runtime:removeEventListener( "enterFrame", onTick )

    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    tileMap.mapCont:removeEventListener( "touch", moveTouch )
    Runtime:removeEventListener( "enterFrame", onTick )


    print( "DESTORY SCENE" )

    movingControl:destroy()
    movingControl = nil
    objControl:destroy()
    objControl = nil
    tileMap:destroy()
    tileMap = nil
    barControl:destroy()
    barControl = nil
    hunter = nil


    noobhub:unsubscribe()


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
