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

-- load scenetemplate.lua
composer.gotoScene( "app.MenuScene" )

print('```````````````````````````````````````````````````````')


print("SYSTEM "..system.getInfo('platformName'))


-- if hub then
-- hub:subscribe({
-- 	channel = "ping-channel";
-- 	callback = function(message)  
-- 		print("message received  = "..json.encode(message));
-- 		-- print("message full received  = "..message);
		



-- 		if(message.action == "ping")   then ----------------------------------
-- 			print ("pong sent");
-- 			hub:publish({
-- 				message = {
-- 					action  =  "pong",
-- 					id = message.id,
-- 					original_timestamp = message.timestamp,
-- 					timestamp = system.getTimer()
-- 				}
-- 			});			

-- 		end;----------------------------------------------------------------


-- 		if (message.action == "pong"  )   then ----------------------------------
-- 			print ("pong id "..message.id.." received on "..system.getTimer().."; summary:   latency=" .. (system.getTimer() - message.original_timestamp)   );
-- 			table.insert( latencies,  ( (system.getTimer() - message.original_timestamp)   )     );

-- 			local sum = 0;
-- 			local count = 0;
-- 			for i,lat in ipairs(latencies) do
-- 				sum = sum + lat;
-- 				count =  count+1;
-- 			end
			
-- 			print("---------- "..count..') average =  '..(sum/count)  );
-- 		end;----------------------------------------------------------------



-- 		if (message.action == "invite") then 
-- 			-- print( ... )
-- 			-- 
-- 		end;



-- 		if (message.action == "move" and message.id ~= uniq_id) then 
-- 			-- print( ... )
-- 			-- move object with message.id to message.x, message.y
-- 			if not gamers[message.id] then
-- 				-- create object with this uniq_id
-- 				local myRectangle = display.newRect( 0, 0, 50, 50 )
-- 				myRectangle.strokeWidth = 3
-- 				myRectangle.anchorX = 0.5
-- 				myRectangle.anchorY = 1
-- 				myRectangle:setFillColor( math.random(1,10)/10 )
-- 				myRectangle:setStrokeColor( 1, 0, 0 )
-- 				myRectangle.x = message.x;
-- 				myRectangle.y = message.y;
-- 				myRectangle.uniq_id = message.id;
-- 				gamers[message.id] = myRectangle;
-- 			end;

-- 			gamers[message.id].x = message.x;
-- 			gamers[message.id].y = message.y;
-- 		end;



-- 		if (message.action == "new_user") then 
-- 			-- print( ... )
-- 			-- creaete object with message.uniq_id
-- 		end;


-- 		-- print("mess action "..message.action)
-- 	end;
-- });
-- end
-- print("MOVE")
-- hub:move({
-- 				id = 1,
-- 	    		x = 2,
-- 	   			y = 3
-- 			});



