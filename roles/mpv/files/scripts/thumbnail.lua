-- thumbnail.lua
--
-- create a new thumbnail based on currect frame


function convert_to_time(tenths)
  local hh = (tenths / (60 * 60)) % 24
  local mm = (tenths / (60)) % 60
  local ss = (tenths) % 60

  return string.format("%02d:%02d:%02d", hh, mm, ss)
end

mp.add_key_binding("T", "thumbnail", function()
    path = mp.get_property("path")
    time_pos = convert_to_time(mp.get_property("playback-time"))
    os.execute(([[thumbnailer -f '%s' '%s']]):format(path, time_pos));
end)
