-- notify
-- Sends a desktop notification when file loaded or failed to load.


mp.register_event('file-loaded', function()
    local title, msg

    title = mp.get_property('media-title');  
    title = (title == mp.get_property('filename') and mp.get_property('path') or title);

    os.execute(("notify-send -u low 'MPV' '%s'"):format(string.gsub(title, "'", "'\"'\"'")));

end)

-- Send notification when failed to open file.
mp.register_event('end-file', function(event) 
    if event.reason == "error" then
        os.execute("notify-send 'MPV' 'ERROR: failed to open file!'")
    end
end)
