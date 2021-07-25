local mod = {}

function mod.parse_exit(dir)
	local ndir = ""
	local rdir = ""
	local dx = 0
	local dy = 0
	local dz = 0

	if dir == "n" or dir == "north" then
		dy = -1
		rdir = "s"
		ndir = "n"
	elseif dir == "s" or dir == "south" then
		dy = 1
		rdir = "n"
		ndir = "s"
	elseif dir == "e" or dir == "east" then
		dx = 1
		rdir = "w"
		ndir = "e"
	elseif dir == "w" or dir == "west" then
		dx = -1
		rdir = "e"
		ndir = "w"
	elseif dir == "ne" or dir == "northeast" then
		dy = -1
		dx = 1
		rdir = "sw"
		ndir = "ne"
	elseif dir == "nw" or dir == "northwest" then
		dy = -1
		dx = -1
		rdir = "se"
		ndir = "nw"
	elseif dir == "se" or dir == "southeast" then
		dy = 1
		dx = 1
		rdir = "nw"
		ndir = "se"
	elseif dir == "sw" or dir == "southwest" then
		dy = 1
		dx = -1
		rdir = "ne"
		ndir = "sw"
	elseif dir == "u" or dir == "up" then
		dz = 1
		rdir = "d"
		ndir = "u"
	elseif dir == "d" or dir == "down" then
		dz = -1
		rdir = "u"
		ndir = "d"
	else
		info("MAPPER", "Unknown direction: " .. dir)
	end

	return ndir, { dx, dy, dz }, rdir
end

function mod.info(cat, ...)
	local msgs = {...}
	for _,msg in ipairs(msgs) do
		print(cformat(
				"<bwhite>[<reset><bgreen>%s<reset><bwhite>]:<reset> %s",
				cat:upper(),
				msg
				)
			)
	end
end

return mod
