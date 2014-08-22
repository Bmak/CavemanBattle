local composer = require("composer")


local ResultTable = {}


function ResultTable:show(data)
	local group = composer.stage
	-- data = {{name="killer",kills=10,deaths=5},{name="bigmac",kills=2,deaths=15},{name="player",kills=5,deaths=3}}

	local rect = display.newRect( 100, 100, display.pixelHeight-100, display.pixelWidth-100 )
	rect.x = display.contentCenterX
	rect.y = display.contentCenterY
	rect.alpha = 0.8
	rect:setFillColor( 0.2 )
	group:insert(rect)

	local title = display.newText( "RESULTS", 0, 0, native.systemFont, 50 )
	title.x = rect.x
	title.y = rect.y - rect.height/2 + title.height
    group:insert(title)

    local nameTitle = display.newText( "NAME", 0, 0, native.systemFont, 30 )
	nameTitle.x = rect.x - rect.width/3
	nameTitle.y = rect.y - rect.height/2 + 150
    group:insert(nameTitle)
    local killsTitle = display.newText( "KILLS", 0, 0, native.systemFont, 30 )
	killsTitle.x = nameTitle.x + 200
	killsTitle.y = rect.y - rect.height/2 + 150
    group:insert(killsTitle)
    local deathsTitle = display.newText( "DEATHS", 0, 0, native.systemFont, 30 )
	deathsTitle.x = killsTitle.x + 200
	deathsTitle.y = rect.y - rect.height/2 + 150
    group:insert(deathsTitle)

    if data == nil then return end
    for k,info in pairs(data) do
    	local box = display.newGroup( )
		local nameTxt = display.newText(info.name, 0, 0, native.systemFont, 25 )
		box:insert(nameTxt)
		local killsTxt = display.newText(info.kills, 200, 0, native.systemFont, 25 )
		box:insert(killsTxt)
		local deathsTxt = display.newText(info.deaths, 400, 0, native.systemFont, 25 )
		box:insert(deathsTxt)

		if info.name == composer.player then
			nameTxt:setFillColor( 0.2,1,0.2 )
			killsTxt:setFillColor( 0.2,1,0.2 )
			deathsTxt:setFillColor( 0.2,1,0.2 )
		end
		
    	box.x = nameTitle.x
    	box.y = nameTitle.y + 40*k + 50
    	group:insert(box)
    end
end


return ResultTable