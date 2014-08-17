local BarControl = {}

local container = nil

local weaponGroup = nil
local weaponView = nil
local weaponTxt = nil
local weaponCount = nil

local killsGroup = nil
local killsView = nil
local killsTxt = nil
local killsCount = nil

local function createWeaponBar(self)
	self.weaponGroup = display.newGroup( )
	local bar = display.newImage("i/bar.png",0,0)
	bar.alpha = 0.6
	self.weaponView = display.newImage("i/weapon.png",-bar.width/2 - 10,0)
	self.weaponTxt = display.newText( "0", 10, 0, native.systemFont, 24 )
	self.weaponTxt:setFillColor( 0, 0, 0 )

	self.weaponGroup:insert(bar)
	self.weaponGroup:insert(self.weaponView)
	self.weaponGroup:insert(self.weaponTxt)
	self.weaponGroup.x = display.pixelHeight - self.weaponGroup.width/2
	self.weaponGroup.y = self.weaponGroup.height - 15

	self.container:insert(self.weaponGroup)
end

local function createKillsBar(self)
	self.killsGroup = display.newGroup( )
	local bar = display.newImage("i/bar.png",0,0)
	bar.xScale = -1
	bar.alpha = 0.6
	self.killsView = display.newImage("i/kills.png",bar.width/2 + 10,0)
	self.killsTxt = display.newText( "0", -10, 0, native.systemFont, 24 )
	self.killsTxt:setFillColor( 0, 0, 0 )
	self.killsCount = 0

	self.killsGroup:insert(bar)
	self.killsGroup:insert(self.killsView)
	self.killsGroup:insert(self.killsTxt)
	self.killsGroup.x = self.killsGroup.width/2
	self.killsGroup.y = self.killsGroup.height - 15

	self.container:insert(self.killsGroup)
end

function BarControl:setWeapCount(value)
	self.weaponTxt.text = value
end

function BarControl:getKills()
	return self.killsCount
end

function BarControl:setKills(value)
	self.killsCount = value
	self.killsTxt.text = self.killsCount
end

function BarControl:create(group)
	self.container = group

	createWeaponBar(self)
	createKillsBar(self)
end



return BarControl