-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- 1. Remove borders when there's only one tiled window on the workspace
hl.window_rule({
  name = "smart-borders-single",
  match = { float = false, workspace = "w[tv1]" },
  border_size = 0,
})

-- 2. Optional: Remove borders if a window is fully fullscreened
hl.window_rule({
  name = "smart-borders-fullscreen",
  match = { float = false, workspace = "f[1]" },
  border_size = 0,
})

hl.config({
  general = {
    -- No gaps between windows or borders.
    gaps_in = 0,
    gaps_out = 0,
    border_size = 1,
    col = {
      -- Active window color (Bright white/cyan hex example)
      active_border = "rgba(ffffffee)",

      -- Keep the inactive border dark or transparent so the active one stands out
      inactive_border = "rgba(00000000)",
    },

    -- Change to niri-like side-scrolling layout.
    layout = "scrolling",
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    -- Use round window corners.
    rounding = 2,

    -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
    dim_inactive = true,
    dim_strength = 0.15,
    active_opacity = 100,
    inactive_opacity = 100,
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
hl.config({
  layout = {
    -- Avoid overly wide single-window layouts on wide screens.
    single_window_aspect_ratio = { 1, 1 },
  },
})

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })
