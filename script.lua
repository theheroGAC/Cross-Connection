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

dofile("resources/usb.lua")

while true do
	buttons.read()
	if back then back:blit(0,0) end
	
	screen.print(10,20,"To create a cross connection press CROSS to start the FTP and press Triangle to start USB.",1,color.red)
	screen.print(360,160,"Press CROSS to start ftp.",1,color.white,color.blue)
	screen.print(360,190,"Press TRIANGLE to connect USB.",1,color.white,color.blue)
	screen.print(360,220,"Press SQUARE to restart HB.",1,color.white,color.blue)
	screen.print(360,250,"Press START to exit.",1,color.white,color.blue)
	screen.print(360,280, "Mac: "..tostring(os.mac()))

	if ftp.state() then	screen.print(360,320,"Connect to:\nftp://"..tostring(wlan.getip())..":1337",1,color.green) end

	screen.flip() -- Show Buff

	if buttons.cross then
		wlan.connect()
		ftp.init()
	end

	if buttons.triangle then usbMassStorage() end

	if buttons.square then
		ftp.term()
		os.restart()
	end

	if buttons.released.start then break end -- Exit

end
ftp.term()
