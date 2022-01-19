local Area = require("area")
local Util = require "util"
local serpent = require("serpent")

local format = string.format
local info = Util.info

local Map = {}
Map.__index = Map

local function expand_tilde(path)
	if path:find("^~") ~= nil then
		return format("%s%s", os.getenv("HOME"), path:sub(2))
	else
		return path
	end
end

function Map.new(name)
	local ret = setmetatable({}, Map)

	ret.name = name
	ret.currentArea = nil
	ret.currentRoom = nil
	ret.areas = {}
	ret.save_location = nil

	return ret
end

function Map:add_area(name)
	if not self.areas[name] then
		self.areas[name] = Area.new(name)
		self.currentArea = self.areas[name]
		self.currentRoom = self.currentArea:get_room()
		return self.areas[name]
	end
	return nil
end

function Map:replace_area(name)
	if self.areas[name] then
		self.areas[name] = Area.new(name)
		self.currentArea = self.areas[name]
		self.currentRoom = self.currentArea:get_room()
		return self.areas[name]
	end
	return nil
end

function Map:rename_area(old_name, new_name)
	self.areas[new_name] = self.areas[old_name]
	self.areas[old_name] = nil
	for _,area in pairs(self.areas) do
		area:rename_area(old_name, new_name)
	end
end

function Map:track(dir)
	if not self.currentArea then
		return false
	end
	local exit = self.currentArea:track(dir)
	if exit then
		self.currentArea = self.areas[exit.area]
		self.currentArea:set_pos(table.unpack(exit.pos))
		self.currentRoom = self.currentArea:get_room()
		return exit
	else
		self.currentArea = nil
		self.currentRoom = nil
		return nil
	end
end

function Map:set_position(id)
	self.currentArea = nil
	self.currentRoom = nil
	for _,area in pairs(self.areas) do
		local room = area:find_room(id)
		if room then
			self.currentArea = area
			self.currentRoom = room
			self.currentArea:set_pos(table.unpack(room.pos))
			return true
		end
	end
	return false
end

function Map:find_room(id)
	for name,area in pairs(self.areas) do
		local room = area:find_room(id)
		if room then
			return room, name
		end
	end
	return nil
end

function Map:get_area()
	return self.currentArea
end

function Map:get_room()
	return self.currentRoom
end

function Map:move(dir)
	if self.currentArea then
		self.currentRoom = self.currentArea:move(dir)
	end
	return self.currentRoom
end

function Map:unmove()
	if self.currentArea then
		self.currentRoom = self.currentArea:unmove()
	end
	return self.currentRoom
end

function Map:go_back()
	if self.currentArea then
		self.currentRoom = self.currentArea:go_back()
	end
	return self.currentRoom
end

function Map:drop_last_exit()
	if self.currentArea then
		self.currentArea:drop_last_exit()
	end
end

local function table_len(obj)
	local count = 0
	for _,_ in pairs(obj) do count = count + 1 end
	return count
end

function Map:save(path, suffix)
	tasks.spawn(function ()
		suffix = suffix or ""
		local area_count = table_len(self.areas)
		local obj = {}
		local data_to_save = false
		path = expand_tilde(path)
		local fname = format("%s.map_%s%s.lua", path, self.name, suffix)
		info("MAP", format("Saving to '%s'", fname))
		if area_count > 10 then
			info("MAP", format("Saving %d areas", area_count))
		end
		for _,area in pairs(self.areas) do
			local name = area.name
			if area_count <= 10 then
				info("MAP", "Saving area '" .. name .. "'")
			end
			obj[name] = area:save()
			data_to_save = true
		end
		if not data_to_save then
			print("[**] Nothing to save")
			return
		end
		local file = io.open(fname, "w")
		io.output(file)
		io.write(serpent.block(obj))
		io.output(nil)
		file:close()
	end)
end

function Map:load(path, suffix)
	self.areas = {}
	suffix = suffix or ""
	path = expand_tilde(path)
	local fname = format("%s.map_%s%s.lua", path, self.name, suffix)
	info("MAP", format("Loading from '%s'", fname))
	local ok, obj = false, {}
	local file = io.open(fname, "r")
	if file then
		ok, obj = serpent.load(file:read("*a"))
		file:close()
	end
	if ok then
		local area_count = table_len(obj)
		for name,area in pairs(obj) do
			if area_count < 10 then
				info("MAP", format("Loading area '%s'", name))
			end
			self.areas[name] = Area.load(area)
		end

		info("MAP", format("Loaded %d areas", area_count))
	end
	return ok
end

function Map:print()
	if self.currentArea then
		return self.currentArea:print()
	end
	return { "", cformat("<red>-- No map available<reset>") }
end

return Map
