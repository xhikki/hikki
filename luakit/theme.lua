--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "terminus 8"
theme.fg   = "#d3d3d3"
theme.bg   = "#000"

-- Genaral colours
theme.success_fg = "#d3d3d3"
theme.loaded_fg  = "#d3d3d3"
theme.error_fg = "#d3d3d3"
theme.error_bg = "#f00"

-- Warning colours
theme.warning_fg = "#f00"
theme.warning_bg = "#fff"

-- Notification colours
theme.notif_fg = "#d3d3d3"
theme.notif_bg = "#000"

-- Menu colours
theme.menu_fg                   = "#d3d3d3"
theme.menu_bg                   = "#000000"
theme.menu_selected_fg          = "#000000"
theme.menu_selected_bg          = "#d3d3d3"
theme.menu_title_bg             = "#d3d3d3"
theme.menu_primary_title_fg     = "#000000"
theme.menu_secondary_title_fg   = "#000000"

-- Proxy manager
theme.proxy_active_menu_fg      = "#000000"
theme.proxy_active_menu_bg      = "#d3d3d3"
theme.proxy_inactive_menu_fg    = "#d3d3d3"
theme.proxy_inactive_menu_bg    = "#000000"

-- Statusbar specific
theme.sbar_fg         = "#d3d3d3"
theme.sbar_bg         = "#000000"

-- Downloadbar specific
theme.dbar_fg         = "#d3d3d3"
theme.dbar_bg         = "#000000"
theme.dbar_error_fg   = "#ff0000"

-- Input bar specific
theme.ibar_fg           = "#d3d3d3"
theme.ibar_bg           = "#000000"

-- Tab label
theme.tab_fg            = "#d3d3d3"
theme.tab_bg            = "#000000"
theme.tab_ntheme        = "#ff0000"
theme.selected_fg       = "#000000"
theme.selected_bg       = "#d3d3d3"
theme.selected_ntheme   = "#000000"
theme.loading_fg        = "#000000"
theme.loading_bg        = "#ffffff"

-- Trusted/untrusted ssl colours
theme.trust_fg          = "#0f0"
theme.notrust_fg        = "#f00"

return theme
-- vim: et:sw=4:ts=8:sts=4:tw=80
