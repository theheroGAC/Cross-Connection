--[[ 
	ONElua.
	Lua Interpreter for PlayStation®Vita.
	
	Licensed by GNU General Public License v3.0
	
	Copyright (C) 2014-2018, ONElua Team
	http://onelua.x10.mx/staff.html
	
	Designed By:
	- DevDavisNunez (https://twitter.com/DevDavisNunez).
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

buttons.read() -- Flush?

--[[
	Basic operations of the ad hoc:
	- Select Mode!
	- Init Adhoc by Mode 
	- Handle Adhoc Pair by Mode
	- Adhoc Chat Room, ready send | recv!
]]

color.loadpalette()

local modes = {
	{label = "Server Mode", type = __ADHOC_CONN, timeout = 0},
	{label = "Client Mode", type = __ADHOC_JOIN, timeout = 10 * 1000 * 1000}
}
local mode = nil
local sel = 1;

-- Select Mode!
while not mode do
	buttons.read()
	if back then back:blit(0,0) end
	screen.print(480, 10, "Cross Connection", 1, color.white, color.green, __ACENTER)
	screen.print(10,30,"Please select a mode from the following with X button:")
	local y = 50
	for i=1, #modes do
		local c = color.white
		if i == sel then
			screen.print(5, y, ">");
			c = color.green;
		end
		screen.print(30, y, modes[i].label, 1, c)
		y += 20
	end
	screen.print(10,544-60,"Press triangle button to return")
	screen.flip()
	
	if buttons.up and sel > 1 then sel -= 1
	elseif buttons.down and sel < #modes then sel += 1
	end
	if buttons.cross then mode = modes[sel]; end
	if buttons.triangle then return adhoc.term(); end
end

-- Init Adhoc by Mode
local state = adhoc.init(mode.type, mode.timeout);
if state then
	-- Handle Adhoc Pair by Mode
	if mode.type == __ADHOC_CONN then -- Server
		while not adhoc.getrequest() do
			buttons.read()
			if back then back:blit(0,0) end
			screen.print(480, 10, "Cross Connection Adhoc", 1, color.white, color.green, __ACENTER)
			screen.print(10,30,"Waiting for a client!")
			screen.print(10,544-60,"Press start button to return")
			screen.print(10,544-30,string.format("Your MAC is: %s",tostring(adhoc.getmac())))
			screen.flip()
			if buttons.cross then mode = modes[sel]; end
			if buttons.start then return adhoc.term(); end
		end
	else -- Client
		local over = 1;
		local list = {}
		local success = false
		while not success do
			buttons.read()
			if back then back:blit(0,0) end
			screen.print(480, 10, "Cross Connection Adhoc", 1, color.white, color.green, __ACENTER)
			screen.print(10,30,"Searching a server!, try connect with X button:")
			screen.print(10,50,string.format("List of server´s # %d",tostring(adhoc.available())))
			screen.print(10,70,"Name | Mac")
			
			screen.print(10,544-60,"Press triangle button to return")
			screen.print(10,544-30,string.format("Your MAC is: %s",tostring(adhoc.getmac())))
			
			list = adhoc.scan()
			if adhoc.available() > 0 then
				if over > #list then over = 1 end
				local y = 90
				for i=1, #list do
					local c = color.white
					if i == over then
						screen.print(5, y, ">");
						c = color.green;
					end
					local x = 30
					x += screen.print(x,y,list[i].name, 1, c) + 30
					x += screen.print(x,y,list[i].mac, 1, c) + 30
					y += 20
				end
				
				if buttons.up and over > 1 then over -= 1
				elseif buttons.down and over < #list then over += 1 end
				
				if buttons.cross then
					success = adhoc.sendrequest(list[over].addr)
					os.message("Send Request!: "..tostring(success))
				end
				
			end
			screen.flip()
			if buttons.triangle then return adhoc.term(); end
		end
	end
end

