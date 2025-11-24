-- reload-file.lua
--
-- yank media-title to clipboard

mp.add_key_binding("R", "reload-file", function()
    path = mp.get_property("path")
    time_pos = mp.get_property("time-pos")
    mp.commandv("loadfile", path, "replace", -1, "start=+" .. time_pos)
end)
