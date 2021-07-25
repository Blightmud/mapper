package.path = "/home/linus/ws/blightmud-scripts/global/mapper/?.lua;" .. package.path

local mod = {}

mod.Map = require "map"
mod.Area = require "area"
mod.Room = require "room"
mod.Util = require "util"

local Map = mod.Map

function mod.create(name)
	return Map.new(name)
end

function mod.revdir(dir)
	local _, _, rev = mod.Util.parse_exit(dir)
	return rev
end

Mapper = mod
