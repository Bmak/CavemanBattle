require("noobhub")
local MC = require("app.MovingControl")
local results = require("app.obj.ResultTable")

SocketControl = {}

local hub = nil
local uniq_id = nil
local listener = nil
local pingTimer = nil
local playerName = nil

function SocketControl:connect(name)
	local hserver = "198.211.120.236"
	local hport = 8080
	self.hub = noobhub.new({ server = hserver; port = hport; })
	self.playerName = name

	self.uniq_id = system.getInfo('deviceID')
	self.listener = display.newGroup( )

	pb("PLAYER NAME "..self.playerName)
	self:setCallBack()
	self:login()

	-- results:show()
	

	local function ping()
		self:ping()
	end
	self.pingTimer = timer.performWithDelay( 50, ping, 0)
end

function SocketControl:login()
	pb("send login")
	if self.hub then
		self.hub:publish({action="login",id=self.uniq_id,name=self.playerName,time=os.time()})
	end
end

function SocketControl:setCallBack()
	self.hub:subscribe({
        channel = "ping-channel";
        callback = function(buffer) 
        	if buffer == nil then return end
            -- print("parse  "..json.encode(buffer))
            
            for k,message in pairs(buffer) do

            	if message.action == "time" then
            		self.listener:dispatchEvent( {name="setTimeLeft", time=message.time_left} )
            	end

            	if message.action == "result" then
            		results:show(message.data)
            		self:disconnect()
            		self.listener:dispatchEvent( {name="worldStop"} )
            		-- return
            	end

            	if message.action == "stone_added" then
            		MC:addWeapon(message.x,message.y)
            	elseif message.action == "stone_removed" then
            		MC:removeWeapon(message.x,message.y)
            	end

            	local player = nil
            	if message.action == "login" then
            		self.listener:dispatchEvent( {name="showMe"} )
            	else
            		player = MC:getPlayer(message.id)

            		if player then
	            		if message.action == "reborn" then
	            			player:respawn(message.x,message.y)
	            		end
	            		if message.action == "move" then
	            			player:move(message.x,message.y,1)
	            		end
	            		if message.action == "throw" then
	            			player:throw(message.x,message.y)
	            		end
	            		if message.action == "dead" then
	            			local killer = MC:getPlayer(message.killer)
	            			if killer.name == "hero" then
	            				killer:addPoint()
	            			end
	            			player:dead(message.x,message.y)
	            		end
	            		if message.action == "logout" then
	            			MC:removePlayer(player)
	            		end
	            	elseif message.action == "reborn" then
	            		self.listener:dispatchEvent( {name="addNewPlayer",id=message.id} )
	            		player = MC:getPlayer(message.id)
	            		player:respawn(message.x,message.y)
	            	end 
            	end
            end
        end
    });
end

function SocketControl:move(px,py)
	pb("send move "..os.time())
	if self.hub then
		self.hub:publish({action="move",id=self.uniq_id,x=math.round(px),y=math.round(py)})
	end
end

function SocketControl:throw(px,py)
	pb("send throw "..os.time())
	if self.hub then
		self.hub:publish({action="throw",id=self.uniq_id,x=math.round(px),y=math.round(py)})
	end
end

function SocketControl:dead(killer_id)
	pb("send dead "..os.time())
	if self.hub then
		self.hub:publish({action="dead",id=self.uniq_id,killer=killer_id})
	end
end

function SocketControl:reborn(px,py)
	pb("send reborn "..os.time())
	if self.hub then
		self.hub:publish({action="reborn",id=self.uniq_id,x=math.round(px),y=math.round(py)})
	end
end

function SocketControl:pick(px,py)
	pb("send pick "..os.time())
	if self.hub then
		self.hub:publish({action="pick",id=self.uniq_id,x=math.round(px),y=math.round(py)})
	end
end

function SocketControl:ping()
	-- print("ping")
	if self.hub then
		self.hub:publish({action="ping",id=self.uniq_id})
	end
end

function SocketControl:disconnect()
	pb("disconnect")
	if self.pingTimer then
		timer.cancel( self.pingTimer )
	end
	if self.hub then
		self.hub:unsubscribe()
	end
end

return SocketControl