-- osc-toggle
-- Toggles the osc from never to always.
-- 
-- Expects osc to be set to never by default.


-- OSC visibility set to always by default.
mp.command("script-message osc-visibility always")

local is_never = false  -- no way to read the osc mode, so we assume it starts in never mode.
mp.add_key_binding("b", "osc-toggle", function()
    mp.command("script-message osc-visibility " .. (is_never and "always" or "never"))
    is_never = not is_never
end)
