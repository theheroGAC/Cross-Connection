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

function usbMassStorage()

	if not usb then os.requireusb() end

	while usb.actived() != 1 do
		buttons.read()
		power.tick()

		if back then back:blit(0,0) end
		if ftp.state() then	screen.print(10,10,"ftp.state(): "..tostring(ftp.state()),1,color.white,color.green) end

		local titlew = string.format("Connect a USB cable")
		local w,h = screen.textwidth(titlew,1) + 30,70
		local x,y = 480 - (w/2), 272 - (h/2)

		draw.fillrect(x, y, w, h, 0x64330066)
		draw.rect(x, y, w, h,color.white)
			screen.print(480,y+13, titlew,1,0xFFFFFFFF,0x64000000,__ACENTER)
			screen.print(480,y+40, "O Disconnect",1,0xFFFFFFFF,0x64000000,__ACENTER)
		screen.flip()

		if buttons.circle then
			return false
		end
	end

	buttons.read()--fflush

	--[[
		// 0:	USBDEVICE_MODE_MEMORY_CARD
		// 1:	USBDEVICE_MODE_GAME_CARD
		// 2:	USBDEVICE_MODE_SD2VITA
		// 3:	USBDEVICE_MODE_PSVSD
	]]
	local mode_usb = -1
	local title = string.format("USB Connection Mode")
	local w,h = screen.textwidth(title,1) + 120,145
	local x,y = 480 - (w/2), 272 - (h/2)
	while true do
		buttons.read()
		power.tick()
		if back then back:blit(0,0) end

		if ftp.state() then	screen.print(10,10,"ftp.state(): "..tostring(ftp.state()),1,color.white,color.green) end

		draw.fillrect(x, y, w, h, color.new(0x2f,0x2f,0x2f,0xff))
			screen.print(480, y+10, title,1,color.white,color.black, __ACENTER)
			screen.print(480,y+40, "Cross: Sd2Vita", 1,color.white,color.black, __ACENTER)
			screen.print(480,y+65, "Square: Memory Card", 1,color.white,color.black, __ACENTER)
			screen.print(480,y+90, "Triangle: Game Card", 1,color.white,color.black, __ACENTER)
			screen.print(480,y+115, "Circle: Cancel", 1,color.white,color.black, __ACENTER)
		screen.flip()

		if buttons.cross or buttons.square or buttons.triangle or buttons.circle then
			if buttons.cross then mode_usb = 2
			elseif buttons.square then mode_usb = 0
			elseif buttons.triangle then mode_usb = 1
			else return false end
			break
		end

	end--while

	buttons.homepopup(0) -- Block out to livearea.
	local conexion = usb.start(mode_usb)

	if conexion == -1 then
		buttons.homepopup(1) -- Enable out to livearea.
		os.message("Error... Conexion Failed",0)
		return false
	end

	local titlew = string.format("USB Connection Enabled")
	local w,h = screen.textwidth(titlew,1) + 30,70
	local x,y = 480 - (w/2), 272 - (h/2)
	while not buttons.circle do
		buttons.read()
		power.tick()
		if back then back:blit(0,0) end

		if ftp.state() then	screen.print(10,10,"ftp.state(): "..tostring(ftp.state()),1,color.white,color.green) end

		draw.fillrect(x,y,w,h,0x64330066)
		draw.rect(x,y,w,h,color.white)
			screen.print(480,y+13, "USB Connection Enabled",1,0xFFFFFFFF,0x64000000,__ACENTER)
			screen.print(480,y+40, "O Disconnect",1,0xFFFFFFFF,0x64000000,__ACENTER)
		screen.flip()
	end

	buttons.read()--fflush
	usb.stop()
	buttons.homepopup(1) -- Enable out to livearea.
	return true
end
