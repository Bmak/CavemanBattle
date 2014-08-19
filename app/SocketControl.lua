require("noobhub")
local MC = require("app.MovingControl")

SocketControl = {}

local hub = nil
local uniq_id = nil
local listener = nil

function SocketControl:connect()
	local hserver = "198.211.120.236"
	local hport = 8080
	self.hub = noobhub.new({ server = hserver; port = hport; })

	self.uniq_id = system.getInfo('deviceID')
	self.listener = display.newGroup( )

	print("connect")
	self:setCallBack()
	self:login()
end

function SocketControl:login()
	print("send login")
	self.hub:publish({action="login",id=self.uniq_id})
end

function SocketControl:setCallBack()
	self.hub:subscribe({
        channel = "ping-channel";
        callback = function(buffer)  
            print("message received  = "..json.encode(buffer));
            
            for k,message in pairs(buffer) do
            	-- print("MESSAGE "..k)
            	local player = nil
            	if message.action == "login" then
            		self.listener:dispatchEvent( {name="addNewPlayer",id=message.id} )
            	else
            		player = MC:getPlayer(message.id)

            		if message.action == "reborn" then
            			player:respawn(message.x,message.y)
            		end
            		if message.action == "move" then
            			player:move(message.x,message.y)
            		end
            		if message.action == "throw" then
            			player:throw(message.x,message.y)
            		end
            		if message.action == "dead" then
            			player:dead(message.x,message.y)
            		end
            	end
            end
        end
    });
end

function parse(data)
	
end

function SocketControl:move(px,py)
	--print("send move")
	self.hub:publish({action="move",id=self.uniq_id,x=math.round(px),y=math.round(py)})
end

function SocketControl:throw(px,py)
	--print("send throw")
	self.hub:publish({action="throw",id=self.uniq_id,x=math.round(px),y=math.round(py)})
end

function SocketControl:dead()
	--print("send dead")
	self.hub:publish({action="dead",id=self.uniq_id})
end

function SocketControl:reborn(px,py)
	--print("send reborn")
	self.hub:publish({action="reborn",id=self.uniq_id,x=math.round(px),y=math.round(py)})
end

function SocketControl:pickUpStone(px,py)
	--print("send pickUpStone")
	self.hub:publish({action="pick",id=self.uniq_id,x=math.round(px),y=math.round(py)})
end

function SocketControl:disconnect()
	--print("disconnect")
	self.hub:unsubscribe()
end

return SocketControl