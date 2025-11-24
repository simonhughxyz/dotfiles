-- yank-title
-- 
-- yank media-title to clipboard

mp.add_key_binding("y", "yank-title", function()
    title = mp.get_property('media-title')
    command = 'printf "%s" "' .. title .. '" | wl-copy &'
    os.execute(command)
end)
