# Blightmud Mapper

This plugin provides mapping functionality to Blightmud. However it's not as
easy as dropping the plugin in and starting to walk around in your mud.  This
plugin provides the foundation for storing and rendering rooms as well as offer
an API to be able to extend and modify the created map.

## API

The base mod has two functions.

```lua
-- Creates a new map
local map = Mapper.create("name")

-- Util function to reverse a direction ('sw' in this case)
local revdir = Mapper.revdir("ne")
```

## The Map Object

***Map.new(name)***
Creates a new map (prefer to use `Mapper.create(name)`)

- Returns the `Map`

***Map:add_area(name)***
Adds a new area to the map and places 'you' inside the first room of that area.

- `name`    The name of the area
- Returns an `Area` or `nil` on conflicting names.

***Map:replace_area(name)***
Does the same as `Map:add_area` with reverse conditions

- `name`    The name of the area
- Returns an `Area` or `nil` if no name conflict was found.

***Map:track(dir)***
Moves your position on the map. This is what you would call in sync with your
movement in the actual game world to keep the map tracking your position.

- `dir` The direction to track
- Returns the `Exit` used or `nil` if directions isn't mapped.

***Map:go_back()***
Moves you back to the last room you were in. Good to use when tracking and
accidentally walking into a closed door or non-existing exit.

- Returns the new current `Room`

***Map:set_position(id)***
Attempts to find a room in the map based on `id` and places you in that room.

- `id`      A `Room` id
- Returns a boolean representing success

***Map:find_room(id)***
Find a `Room` in the map based on `id`

- `id`      A `Room` id
- Returns `Room` and `Area.name` or nil

***Map:get_area()***
Returns your current `Area` or `nil`

***Map:get_room()***
Returns your current `Room` or `nil`

***Map:move(dir)***
Move your position on the map and create/link rooms as needed.

- `dir`     The direction you are moving in
- Returns the new `Room`

***Map:unmove()***
Undo the last move you did (deleting the room and resetting the exit).
This is most useful when you accidentally walk into a closed door when
mapping.

- Returns the new current `Room`

***Map:drop_last_exit()***
Deletes the last exit created in the current room. This can be used in
conjunction with `Map:unmove()` when you accidentally created a non-existing
exit.

***Map:save(path, [suffix])***
Saves the map to file. The filename is generated based on the map name.

`path`      The path to save to (eg. `/home/user/maps/`)
`suffix`    An optional suffix to add to the file name (eg. a date string for versioning)

```lua
local map = Map.create("mymud")
map:save(
    "/home/user/muds/maps/",
    "." .. os.date("%Y-%m-%d_%H:%M"))
```

***Map:load(path, [suffix])***
Loads the map from file

`path`      The path to load from (eg. `/home/user/maps/`)
`suffix`    An optional suffix to add to the file name (eg. a date string for versioning)

***Map:print()***
Returns a list of lines which render the current map around your position.

## The Area Object

Documentation still needed. Look at source for reference

## The Room Object

Documentation still needed. Look at source for reference
