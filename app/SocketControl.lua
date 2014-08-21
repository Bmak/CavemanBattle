require("noobhub")
local MC = require("app.MovingControl")
local OC = require("app.ObjectControl")
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

	print("PLAYER NAME "..self.playerName)
	self:setCallBack()
	-- self:login()

	-- results:show()

	local function ping()
		self:ping()
	end
	-- self.pingTimer = timer.performWithDelay( 50, ping, 0)
end

function SocketControl:login()
	print("send login")
	if self.hub then
		self.hub:publish({action="login",id=self.uniq_id})
	end
end

function SocketControl:setCallBack()
	self.hub:subscribe({
        channel = "ping-channel";
        callback = function(buffer) 
            print("message received  = "..json.encode(buffer));
            
            for k,message in pairs(buffer) do

            	if message.action == "stone_added" then
            		OC:addObject(message.x,message.y)
            	elseif message.action == "stone_removed" then
            		OC:removeObject(message.x,message.y)
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

function parse(data)
	
end

function SocketControl:move(px,py)
	-- print("send move")
	if self.hub then
		self.hub:publish({action="move",id=self.uniq_id,x=math.round(px),y=math.round(py)})
	end
end

function SocketControl:throw(px,py)
	-- print("send throw")
	if self.hub then
		self.hub:publish({action="throw",id=self.uniq_id,x=math.round(px),y=math.round(py)})
	end
end

function SocketControl:dead()
	-- print("send dead")
	if self.hub then
		self.hub:publish({action="dead",id=self.uniq_id})
	end
end

function SocketControl:reborn(px,py)
	-- print("send reborn")
	if self.hub then
		self.hub:publish({action="reborn",id=self.uniq_id,x=math.round(px),y=math.round(py)})
	end
end

function SocketControl:pick(px,py)
	--print("send pick")
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
	--print("disconnect")
	timer.cancel( self.pingTimer )
	if self.hub then
		self.hub:unsubscribe()
	end
end

return SocketControl