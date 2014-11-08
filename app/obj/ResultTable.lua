local composer = require("composer")
local Anim = require("app.animation.AnimItem")

local ResultTable = {}

local group = nil


function ResultTable:show(data)
	local stage = composer.stage
	self.group = display.newGroup()
	
	function showWindow( ... )
		local window = Anim:new( )
	    local options = nil
	    options = {
	        back = false,
	        frames = 14,
	        w = 1024,
	        h = 768,
	        img = "i/anim/result_anim.png",
	        cw = 4096,
	        ch = 3072,
	        scale = 1.0,
	        loop = 1
	    }
	    window:create("results",options,0,false,1200)
	    -- bkgAnim.anim.xScale = 2
	    -- bkgAnim.anim.yScale = 2
	    window.anim:play()
	    self.group:insert( window.anim )






	    local function onEndAnim( event )
            -- pb("phase.."..event.phase)
            if event.phase == "ended" then
                window.anim:pause()

                local txtGroup = display.newGroup()
                local title = display.newText( "RESULTS", 0, 0, STONE, 40 )
				title:setFillColor( 1,0,0 )
				title.x = - 50
				title.y = - 120
			 	txtGroup:insert(title)

			 	local nameTitle = display.newText( "NAME", 0, 0, STONE, 28 )
		    	nameTitle:setFillColor( black )
				nameTitle.x = - 250
				nameTitle.y = - 60
			    txtGroup:insert(nameTitle)
			    local killsTitle = display.newText( "KILLS", 0, 0, STONE, 28 )
			    killsTitle:setFillColor( black )
				killsTitle.x = - 50
				killsTitle.y = - 60
			    txtGroup:insert(killsTitle)
			    local deathsTitle = display.newText( "DEATHS", 0, 0, STONE, 28 )
			    deathsTitle:setFillColor( black )
				deathsTitle.x = 150
				deathsTitle.y = - 60
			    txtGroup:insert(deathsTitle)



			    if data == nil then return end
			    for k,info in pairs(data) do
			    	local box = display.newGroup( )
					local nameTxt = display.newText(info.name, nameTitle.x, 0, STONE, 23 )
					box:insert(nameTxt)
					local killsTxt = display.newText(info.kills, killsTitle.x, 0, STONE, 23 )
					box:insert(killsTxt)
					local deathsTxt = display.newText(info.deaths, deathsTitle.x, 0, STONE, 23 )
					box:insert(deathsTxt)

					if info.name == composer.player then
						nameTxt:setFillColor( 0.0,1,0.0 )
						killsTxt:setFillColor( 0.0,1,0.0 )
						deathsTxt:setFillColor( 0.0,1,0.0 )
					else
						nameTxt:setFillColor( gray )
						killsTxt:setFillColor( gray )
						deathsTxt:setFillColor( gray )
					end
					
			    	box.y = nameTitle.y + 40*k
			    	txtGroup:insert(box)
			    end

			    local againTxt = display.newText( "AGAIN", 0, 0, STONE, 33 )
		    	againTxt:setFillColor( black )
				againTxt.x = - 50
				againTxt.y = 220
			    txtGroup:insert(againTxt)

			    local function onMenu(event)
			        local phase = event.phase
			        if "ended" == phase then
			       		self:destroy()
			            composer.gotoScene( "app.MenuScene", { effect = "crossFade", time = 500 } )
			        end
			    end
			    window.anim:addEventListener( "touch", onMenu )

			    self.group:insert(txtGroup)
            end
        end

        window.anim:addEventListener( "sprite", onEndAnim )
	end

	timer.performWithDelay( 100, showWindow )

	






	-- data = {{name="killer",kills=10,deaths=5},{name="bigmac",kills=2,deaths=15},{name="player",kills=5,deaths=3}}

	-- local rect = display.newRect( 100, 100, display.pixelHeight-100, display.pixelWidth-100 )
	-- local rect = display.newRect( 0, 0, 600, 500 )



	-- local rect = display.newImage("i/window.png",0,0)
	-- rect.alpha = 0.8
	-- self.group:insert(rect)

	-- local title = display.newText( "RESULTS", 0, 0, "STONE", 50 )
	-- title:setFillColor( 1,0,0 )
	-- title.x = rect.x
	-- title.y = rect.y - rect.height/2 + title.height
 --    self.group:insert(title)

 --    local nameTitle = display.newText( "NAME", 0, 0, "STONE", 35 )
 --    nameTitle:setFillColor( black )
	-- nameTitle.x = rect.x - rect.width/3
	-- nameTitle.y = rect.y - rect.height/2 + 130
 --    self.group:insert(nameTitle)
 --    local killsTitle = display.newText( "KILLS", 0, 0, "STONE", 35 )
 --    killsTitle:setFillColor( black )
	-- killsTitle.x = rect.x
	-- killsTitle.y = rect.y - rect.height/2 + 130
 --    self.group:insert(killsTitle)
 --    local deathsTitle = display.newText( "DEATHS", 0, 0, "STONE", 35 )
 --    deathsTitle:setFillColor( black )
	-- deathsTitle.x = rect.x + rect.width/3
	-- deathsTitle.y = rect.y - rect.height/2 + 130
 --    self.group:insert(deathsTitle)

 --    if data == nil then return end
 --    for k,info in pairs(data) do
 --    	local box = display.newGroup( )
	-- 	local nameTxt = display.newText(info.name, nameTitle.x, 0, "STONE", 30 )
	-- 	box:insert(nameTxt)
	-- 	local killsTxt = display.newText(info.kills, killsTitle.x, 0, "STONE", 30 )
	-- 	box:insert(killsTxt)
	-- 	local deathsTxt = display.newText(info.deaths, deathsTitle.x, 0, "STONE", 30 )
	-- 	box:insert(deathsTxt)

	-- 	if info.name == composer.player then
	-- 		nameTxt:setFillColor( 0.0,1,0.0 )
	-- 		killsTxt:setFillColor( 0.0,1,0.0 )
	-- 		deathsTxt:setFillColor( 0.0,1,0.0 )
	-- 	else
	-- 		nameTxt:setFillColor( gray )
	-- 		killsTxt:setFillColor( gray )
	-- 		deathsTxt:setFillColor( gray )
	-- 	end
		
 --    	box.y = nameTitle.y + 40*k + 20
 --    	self.group:insert(box)
 --    end



 --    local menuBtn = display.newImage("i/againBtn.png")
 --    menuBtn.x = rect.x
 --    menuBtn.y = rect.y + rect.height/2 - menuBtn.height
 --    self.group:insert(menuBtn)

 --    local function onMenu(event)
 --        local phase = event.phase
 --        if "ended" == phase then
 --       		self:destroy()
 --            composer.gotoScene( "app.MenuScene", { effect = "crossFade", time = 500 } )
 --        end
 --    end
 --    menuBtn:addEventListener( "touch", onMenu )

 --    self.group.xScale = display.pixelHeight/self.group.width - 0.1
 --    self.group.yScale = display.pixelWidth/self.group.height - 0.1
 	self.group.xScale = 2
    self.group.yScale = 2
    self.group.x = display.contentCenterX
	self.group.y = display.contentCenterY

    stage:insert(self.group)
end

function ResultTable:destroy()
	self.group:removeSelf( )
end


return ResultTable

