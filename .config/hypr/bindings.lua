-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

--------------------------------------------------------------------------------
-- Personal Custom Additions (Non-conflicting)
--------------------------------------------------------------------------------
o.bind("SUPER + SHIFT + Q", "CopyQ", "copyq toggle")
o.bind("SUPER + CTRL + SHIFT + 1", "Move workspace to monitor 0", "hyprctl dispatch movecurrentworkspacetomonitor 0")
o.bind("SUPER + CTRL + SHIFT + 2", "Move workspace to monitor 1", "hyprctl dispatch movecurrentworkspacetomonitor 1")
