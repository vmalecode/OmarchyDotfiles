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
hl.unbind("SUPER + SHIFT + P")
o.bind("SUPER + SHIFT + P", nil, "helium-browser --incognito")
local workspaces = {
    A = 11, B = 12, --C = 13,
    D = 14, E = 15,
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
    o.bind("SUPER + " .. key, nil, hl.dsp.focus({ workspace = ws_str }))

    -- SUPER + SHIFT + Key to Move Active Window
    o.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. ws_str, hl.dsp.window.move({ workspace = ws_str }))
end
