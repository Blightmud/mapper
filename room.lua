local Util = require "util"
local info = Util.info
local format = string.format

local Room = {}
Room.__index = Room

function Room.new()
	local ret = setmetatable({}, Room)
	ret.name = nil
	ret.id = nil
	ret.exits = {}
	ret.pos = {}
	ret.moving = false
	ret.label = " "
	return ret
end

function Room.load(obj)
	local ret = setmetatable({}, Room)
	ret.name = obj.name
	ret.id = obj.id
	ret.exits = obj.exits
	ret.pos = obj.pos
	ret.moving = obj.moving or false
	ret.label = obj.label or " "
	return ret
end

function Room:save()
	return {
		name=self.name,
		id=self.id,
		exits=self.exits,
		moving=self.moving,
		pos=self.pos,
		label=self.label,
	}
end

function Room:set_name(name)
	info("ROOM", format("Setting name '%s'", name))
	self.name = name
end

function Room:get_name()
	return self.name
end

function Room:set_id(id)
	info("ROOM", format("Setting id '%s'", id))
	self.id = id
end

function Room:get_id()
	return self.id
end

function Room:set_label(label)
	info("ROOM", format("Setting label '%s'", label))
	self.label = label
end

function Room:remove_label()
	self.label = " "
end

function Room:add_exit(dir, area, pos)
	local ndir = Util.parse_exit(dir)
	if not self.exits[ndir] then
		info("ROOM", format("Adding exit '%s'", ndir))
		self.exits[ndir] = {}
	end
	self.exits[ndir].area=area
	self.exits[ndir].pos=pos
end

function Room:add_exit_cmd(dir, cmd)
	local ndir = Util.parse_exit(dir)
	info("ROOM", format("Setting command '%s' for '%s'", cmd, ndir))
	if not self.exits[ndir] then
		self.exits[ndir] = {}
	end
	self.exits[ndir].cmd=cmd
end

function Room:get_exit_cmd(dir)
	local ndir = Util.parse_exit(dir)
	if self.exits[ndir] then
		if self.exits[ndir].cmd then
			return self.exits[ndir].cmd, true
		else
			return ndir, false
		end
	end
	return dir, false
end

function Room:set_exit_door(dir, door)
	local ndir = Util.parse_exit(dir)
	info("ROOM", format("Marking '%s' as door", ndir))

	if not self.exits[ndir] then
		self.exits[ndir] = {}
	end
	self.exits[ndir].door = door
end

function Room:is_exit_door(dir)
	local ndir = Util.parse_exit(dir)
	if self.exits[ndir] then
		return self.exits[ndir].door
	end
	return false
end


function Room:set_moving(moving)
	info("ROOM", "Marking room as 'moving'")
	self.moving = moving
end

function Room:is_moving()
	return self.moving or false
end

function Room:add_undiscovered_exit(dir)
	local ndir = Util.parse_exit(dir)
	if not self.exits[ndir] then
		self.exits[ndir] = {}
	end
end

function Room:rename_area(old_name, new_name)
	for _,exit in pairs(self.exits) do
		if exit.area == old_name then
			exit.area = new_name
		end
	end
end

return Room
