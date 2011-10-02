----------------------------------
--     "hikki" awesome theme    --
--  by Eugene hikki Udovychenko --
----------------------------------

-- BASICS
theme = {}
theme.font          = "terminus 8"

theme.bg_focus      = "cyan"
theme.bg_normal     = "#ffffff"
theme.bg_urgent     = "#ff0000"

theme.fg_normal     = "#000000"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#000000"

theme.border_width  = "1"
theme.border_normal = "#cccccc"
theme.border_focus  = "cyan"
theme.border_marked = "#ff0000"

-- from default for now...
theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarew.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarefw.png"

-- MISC
theme.wallpaper_cmd         = { "xsri --set --color=white" }
theme.taglist_squares       = "true"
theme.titlebar_close_button = "false"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
