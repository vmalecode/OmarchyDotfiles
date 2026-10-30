-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
-- SUPER+SHIFT+F was "File manager". (SUPER+SHIFT+P is free because
-- omarchy_preinstalled_bindings = false in hyprland.lua.)
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + P", nil, "helium-browser --incognito")
o.bind("SUPER + SHIFT + F", nil, "firefox")
-- SUPER+F was "Full screen"; now maximizes (bar and browser UI stay visible).
hl.unbind("SUPER + F")
o.bind("SUPER + F", "Maximize", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- SUPER+ALT+F was "Full width" (maximize); now true fullscreen.
hl.unbind("SUPER + ALT + F")
o.bind("SUPER + ALT + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Letter workspaces: SUPER + letter goes there, SUPER + SHIFT + letter moves the
-- window there. Ids 11-36 map to A-Z; the bar widget
-- (omarchy/plugins/aaron.workspaces) derives the letter from the id, so keep
-- that mapping if you change this table.
--
-- Free up keys that Omarchy binds to something else. Omarchy's app shortcuts
-- are already off via omarchy_preinstalled_bindings = false in hyprland.lua.
hl.unbind("SUPER + G")         -- was: Toggle window grouping
hl.unbind("SUPER + L")         -- was: Toggle workspace layout
hl.unbind("SUPER + SHIFT + B") -- was: Browser
hl.unbind("SUPER + SHIFT + N") -- was: Editor

local workspaces = {
    -- A = 11 and D = 14 are taken by focus left/right below.
    B = 12, --C = 13,
    E = 15,
    -- F = 16,
    G = 17, H = 18, I = 19,
    -- J = 20, K = 21,
    L = 22, M = 23, N = 24,
    -- O = 25, P = 26,
    Q = 27, R = 28,
    -- S = 29, T = 30,
    U = 31, --V = 32, W = 33,
    -- X = 34,
    Y = 35, Z = 36
}

for key, ws in pairs(workspaces) do
    local ws_str = tostring(ws)

    -- SUPER + Key to Focus Workspace
    o.bind("SUPER + " .. key, "Workspace " .. key, hl.dsp.focus({ workspace = ws_str }))

    -- SUPER + SHIFT + Key to Move Active Window
    o.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. key, hl.dsp.window.move({ workspace = ws_str }))
end

-- WASD focus. Arrow keys still work too.
hl.unbind("SUPER + W") -- was: Close window (now SUPER + SHIFT + X)
hl.unbind("SUPER + S") -- was: Toggle scratchpad
o.bind("SUPER + A", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + D", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + W", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + S", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + SHIFT + X", "Close window", hl.dsp.window.close())

-- Toggle the workspace between dwindle and scrolling (see workspace-layout.lua).
-- Monitor scaling keys removed.
local workspace_layout = require("hypr.workspace-layout")
hl.unbind("SUPER + SLASH")       -- was: Monitor scaling up
hl.unbind("SUPER + ALT + SLASH") -- was: Monitor scaling down
o.bind("SUPER + SLASH", "Toggle scrolling layout", workspace_layout.toggle)
