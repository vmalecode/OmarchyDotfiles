-- Accordion layout (AeroSpace-style), toggled per workspace with SUPER + /.
--
-- Windows sit in one row at the same size, stacked. The focused window is fully
-- visible on top; the others peek out as strips on its left and right.
-- Hyprland only re-lays out Lua layouts when windows are added or removed, so a
-- focus listener below asks for a refresh whenever focus changes.

local M = {}

M.layout = "lua:accordion"

-- Width of the strip that unfocused windows show on each side (logical px).
local PEEK = 40

-- Per-workspace window order and last focused window, rebuilt on every layout.
local order = {}
local last_focused = {}

local function index_of(list, value)
  for i, v in ipairs(list or {}) do
    if v == value then
      return i
    end
  end
end

hl.layout.register("accordion", {
  recalculate = function(ctx)
    local targets = ctx.targets
    local n = #targets
    if n == 0 then
      return
    end

    local area = ctx.area
    local ws_id = nil
    local ids = {}
    local focused = nil

    for i, target in ipairs(targets) do
      local window = target.window
      if window then
        ids[i] = window.stable_id
        ws_id = ws_id or (window.workspace and window.workspace.id)
        if window.active then
          focused = i
        end
      end
    end

    if ws_id then
      order[ws_id] = ids
      if focused then
        last_focused[ws_id] = ids[focused]
      else
        focused = index_of(ids, last_focused[ws_id])
      end
    end
    focused = focused or n

    local left = focused > 1 and PEEK or 0
    local right = focused < n and PEEK or 0
    local width = area.w - left - right

    for i, target in ipairs(targets) do
      local x
      if i < focused then
        x = area.x
      elseif i == focused then
        x = area.x + left
      else
        x = area.x + area.w - width
      end
      target:place({ x = x, y = area.y, w = width, h = area.h })
    end
  end,

  layout_msg = function(_, msg)
    if msg == "refresh" then
      return true
    end
    return "accordion: expected refresh"
  end,
})

local function active_is_accordion()
  local ws = hl.get_active_workspace()
  return ws ~= nil and ws.tiled_layout == M.layout, ws
end

-- Expand the newly focused window.
hl.on("window.active", function()
  if active_is_accordion() then
    hl.dispatch(hl.dsp.layout("refresh"))
  end
end)

-- Focus the previous/next window in accordion order; elsewhere, plain
-- directional focus.
function M.focus(direction, step)
  return function()
    local is_accordion, ws = active_is_accordion()
    local window = hl.get_active_window()

    if is_accordion and window and not window.floating then
      local ids = order[ws.id]
      local i = index_of(ids, window.stable_id)
      local next_id = i and ids[i + step]
      if next_id then
        for _, w in ipairs(hl.get_windows()) do
          if w.stable_id == next_id then
            hl.dispatch(hl.dsp.focus({ window = w }))
            return
          end
        end
      end
      return
    end

    hl.dispatch(hl.dsp.focus({ direction = direction }))
  end
end

-- Switch the active workspace between dwindle and accordion. The choice is saved
-- where Omarchy keeps workspace layouts, so it survives config reloads.
function M.toggle()
  local is_accordion, ws = active_is_accordion()
  if not ws or ws.special then
    return
  end

  local layout = is_accordion and "dwindle" or M.layout
  local rule = string.format('hl.workspace_rule({ workspace = "%d", layout = "%s" })', ws.id, layout)

  hl.workspace_rule({ workspace = tostring(ws.id), layout = layout })

  local dir = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/omarchy/workspace-layouts"
  os.execute("mkdir -p '" .. dir .. "'")
  local file = io.open(dir .. "/" .. ws.id .. ".lua", "w")
  if file then
    file:write(rule .. "\n")
    file:close()
  end

  local label = is_accordion and "dwindle" or "accordion"
  hl.dispatch(hl.dsp.exec_cmd("omarchy-notification-send -g 󱂬 'Workspace layout set to " .. label .. "'"))
end

return M
