--[[ 
	ONElua.
	Lua Interpreter for PlayStation®Vita.
	
	Licensed by GNU General Public License v3.0
	
	Copyright (C) 2014-2018, ONElua Team
	http://onelua.x10.mx/staff.html
	
	Designed By:
	- Gdljjrod (https://twitter.com/gdljjrod).
	- DevDavisNunez (https://twitter.com/DevDavisNunez).

]]

color.loadpalette() -- Load Defaults colors

-- ## IMMAGINE DI SFONDO ##
back = image.load("resources/back.png")

local wstrength = wlan.strength()
if wstrength then
    if wstrength > 55 then dofile("git/updater.lua") end
end

dofile("resources/crossconnection.lua")
dofile("resources/usb.lua")

while true do
	buttons.read()
	if back then back:blit(0,0) end
	
	screen.print(10,20,"To create a cross connection press Triangle to start USB+FTP.",1,color.red)
	screen.print(360,160,"Press CROSS to start FTP only.",1,color.white,color.blue)
       screen.print(360,190,"Press CIRCLE to start USB only.",1,color.white,color.black)
	screen.print(360,220,"Press TRIANGLE to cross connection (FTP+USB).",1,color.white,color.green)
	screen.print(360,250,"Press SQUARE to restart/reset APP.",1,color.white,color.blue)
	screen.print(360,280,"Press START to exit.",1,color.white,color.red)
	screen.print(360,320, "Mac: "..tostring(os.mac()))

	if ftp.state() then	screen.print(360,350,"Connect to:\nftp://"..tostring(wlan.getip())..":1337",1,color.green) end

	screen.flip() -- Show Buff

	if buttons.cross then
		wlan.connect()
		ftp.init()
end

	if buttons.circle then usbMassStorage()

	end

	if buttons.triangle then crossconnection()

 end

	if buttons.square then
		ftp.term()
		os.restart()
	end

	if buttons.released.start then break end -- Exit

end
ftp.term()
