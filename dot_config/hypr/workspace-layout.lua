-- Per-workspace layout: dwindle by default, Hyprland's scrolling layout on
-- workspaces toggled with SUPER + / (scrolling options are in looknfeel.lua).
--
-- Mouse focus: hover-to-focus on dwindle, click-to-focus on scrolling. Hovering
-- a neighbour's strip on a scrolling workspace would otherwise focus it, slide
-- the next strip under the cursor, and cascade along the row.

local M = {}

local normal_follow_mouse = hl.get_config("input.follow_mouse")

local function active_is_scrolling()
  local ws = hl.get_active_workspace()
  return ws ~= nil and ws.tiled_layout == "scrolling", ws
end

local function apply_follow_mouse(is_scrolling)
  local want = is_scrolling and 2 or normal_follow_mouse
  if hl.get_config("input.follow_mouse") ~= want then
    hl.config({ input = { follow_mouse = want } })
  end
end

-- Apply now, then re-check shortly after: right after a layout change Hyprland
-- can still report the old layout.
local function sync_follow_mouse(is_scrolling)
  if is_scrolling == nil then
    is_scrolling = active_is_scrolling()
  end
  apply_follow_mouse(is_scrolling)
  hl.timer(function()
    apply_follow_mouse(active_is_scrolling())
  end, { timeout = 100, type = "oneshot" })
end

hl.on("workspace.active", function()
  sync_follow_mouse()
end)
hl.on("window.active", function()
  sync_follow_mouse()
end)
sync_follow_mouse()

-- Switch the active workspace between dwindle and scrolling. Saved the same way
-- as Omarchy's own layout toggle, so it survives config reloads.
function M.toggle()
  local is_scrolling, ws = active_is_scrolling()
  if not ws or ws.special then
    return
  end

  local layout = is_scrolling and "dwindle" or "scrolling"
  hl.workspace_rule({ workspace = tostring(ws.id), layout = layout })
  sync_follow_mouse(layout == "scrolling")

  local dir = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/omarchy/workspace-layouts"
  os.execute("mkdir -p '" .. dir .. "'")
  local file = io.open(dir .. "/" .. ws.id .. ".lua", "w")
  if file then
    file:write(string.format('hl.workspace_rule({ workspace = "%d", layout = "%s" })\n', ws.id, layout))
    file:close()
  end

  hl.dispatch(hl.dsp.exec_cmd("omarchy-notification-send -g 󱂬 'Workspace layout set to " .. layout .. "'"))
end

return M
