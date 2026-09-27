local utils = require "mp.utils"

local descriptions = utils.parse_json(os.getenv("CHILL_INTERNAL_STATION_DESCRIPTIONS") or "[]") or {}
local station_count = #descriptions

local function set_station_title(_, position)
    position = position or mp.get_property_number("playlist-pos", 0)
    local description = descriptions[position + 1]
    if description then
        mp.set_property("force-media-title", description)
    end
end

local function change_station(offset)
    if station_count == 0 then
        return
    end

    local position = mp.get_property_number("playlist-pos", 0)
    local next_position = (position + offset + station_count) % station_count
    mp.commandv("playlist-play-index", next_position)
end

mp.add_forced_key_binding(",", "chill-previous-station", function()
    change_station(-1)
end)

mp.add_forced_key_binding(".", "chill-next-station", function()
    change_station(1)
end)

mp.observe_property("playlist-pos", "number", set_station_title)
mp.register_event("file-loaded", set_station_title)
