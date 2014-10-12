local aspectRatio = display.pixelHeight / display.pixelWidth

print("aspectRatio: "..aspectRatio)
print("pxH pxW "..display.pixelHeight, display.pixelWidth)

-- pxH pxW 2048    1536

application = {
	content = {
		width = 0,
		height = 0, 
		scale = "zoomEven",
		fps = 50,
		
		--[[
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
