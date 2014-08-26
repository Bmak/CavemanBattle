---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local tileMap = require("app.map.TileMap")
local player = require("app.obj.Player")
-- local Duck = require("app.obj.Duck")
local movingControl = require("app.MovingControl")
local barControl = require("app.BarControl")
local SC = require("app.SocketControl")
local results = require("app.obj.ResultTable")

local hunter = nil
local gameTimer = nil
local timerTxt = nil
local timerData = nil

local memTimer = nil

-- Load scene with same root filename as this file
local scene = composer.newScene(  )

---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view


    local uniq_id = system.getInfo('deviceID')
    pb("ID "..uniq_id)

    pb("GAME TYPE "..composer.gameType)
    if composer.gameType == "multi" then
        pb("TRY TO CONNECT")
        SC:connect(composer.player)

        local function addP(e)
            pb("ADD NEW PLAYER "..e.id)
            local pl = player:new()
            pl:create(tileMap.mapCont, "player", e.id)
            movingControl:addPlayer(pl)
            -- SC.listener:removeEventListener( "addNewPlayer", addP )
            -- SC:reborn(hunter.view.x,hunter.view.y)
            -- SC:move(hunter.targetX, hunter.targetY)
        end
        SC.listener:addEventListener( "addNewPlayer", addP )

        local function showMe(e)
            SC:reborn(hunter.view.x,hunter.view.y)
        end
        SC.listener:addEventListener( "showMe", showMe )
        local function setTime(e)
            self:setGameTime(e.time)
        end
        SC.listener:addEventListener( "setTimeLeft", setTime )
    end
    
    pb( "CREATE SCENE" )

    tileMap:create(sceneGroup)
    movingControl:init(tileMap.mapCont)

    hunter = player:new()
    hunter:create(tileMap.mapCont, "hero", system.getInfo('deviceID'))
    tileMap:setHero(hunter)
    movingControl:addPlayer(hunter)

    barControl:create(sceneGroup)

    -- SC:login()
    if composer.gameType == "single" then
        for i=1,3 do
            local duck = player:new()
            duck:create(tileMap.mapCont, "bot", i)
            duck:randomMove()
            movingControl:addPlayer(duck)
        end
        movingControl:initWeapons()

        self:setGameTime(10)
    end
    

    function moveTouch(event)
        self:onHunterMove(event)
    end
    function onTick(event)
        self:worldTick(event)
    end
    tileMap.mapCont:addEventListener( "touch", moveTouch )
    Runtime:addEventListener( "enterFrame", onTick )


    if composer.gameType == "multi" then
        local function onStopWorld(e)
            tileMap.mapCont:removeEventListener( "touch", moveTouch )
            Runtime:removeEventListener( "enterFrame", onTick )
        end
        SC.listener:addEventListener( "worldStop", onStopWorld )
    end

    self:onShowMem()
end

function scene:setGameTime(data)
    self.timerData = data
    local timeText = math.floor(self.timerData/60)..":"..math.round(self.timerData % 60)
    self.timerTxt = display.newText(timeText, 0, 0, native.systemFont, 30 )
    self.timerTxt.x = display.pixelHeight - self.timerTxt.width
    self.timerTxt.y = display.pixelWidth - self.timerTxt.height
    self.timerTxt:setFillColor(1, 0, 0)
    self.view:insert(self.timerTxt)

    local function recountTimer()
        self.timerData = self.timerData - 1
        sec = self.timerData % 60
        if sec < 10 then
            sec = "0"..sec
        end
        local t = math.floor(self.timerData/60)..":"..sec
        self.timerTxt.text = t

        if self.timerData <= 0 and composer.gameType == "single" then
            if self.gameTimer then
                timer.cancel( self.gameTimer )
            end
            self:showGameResult()
        end
    end

    self.gameTimer = timer.performWithDelay( 1000, recountTimer, 0)
end

function scene:showGameResult()
    local data = {}

    for k,pl in pairs(movingControl.players) do
        local d = {}
        d.kills = pl.kills
        d.deaths = pl.deaths
        d.name = pl.nick
        table.insert( data, d )
    end

    results:show(data)
    tileMap.mapCont:removeEventListener( "touch", moveTouch )
    Runtime:removeEventListener( "enterFrame", onTick )
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

    self.memTimer = timer.performWithDelay( 1000, showMem, 0 )
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
        pb( "SHOW SCENE" )


        
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

        pb( "HIDE SCENE" )

        tileMap.mapCont:removeEventListener( "touch", moveTouch )
        Runtime:removeEventListener( "enterFrame", onTick )

    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    tileMap.mapCont:removeEventListener( "touch", moveTouch )
    Runtime:removeEventListener( "enterFrame", onTick )


    pb( "DESTORY SCENE" )

    movingControl:destroy()
    movingControl = nil
    tileMap:destroy()
    tileMap = nil
    barControl:destroy()
    barControl = nil
    hunter = nil

    if self.memTimer then
        timer.cancel( self.memTimer )
    end
    if self.gameTimer then
        timer.cancel( self.gameTimer )
    end
    

    SC:disconnect()
    SC = nil


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
