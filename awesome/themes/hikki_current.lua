----------------------------------
--     "hikki" awesome theme    --
--  by Eugene hikki Udovychenko --
----------------------------------

-- BASICS
theme = {}
theme.font          = "terminus 8"

theme.bg_focus      = "#d3d3d3"
theme.bg_normal     = "#000000"
theme.bg_urgent     = "#ff0000"

theme.fg_normal     = "#d3d3d3"
theme.fg_focus      = "#d3d3d3"
theme.fg_urgent     = "#d3d3d3"

theme.border_width  = "1"
theme.border_normal = "#111111"
theme.border_focus  = "#d3d3d3"
theme.border_marked = "#ff0000"

-- from default for now...
theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

-- MISC
theme.wallpaper_cmd         = { "xsri --set --color=black" }
theme.taglist_squares       = "true"
theme.titlebar_close_button = "false"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
