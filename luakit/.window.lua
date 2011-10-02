------------------
-- window class --
--   by hikki   --
------------------

window = {}

loaded = ""
scrolled = ""
link = ""

window.bywidget = setmetatable({}, {__mode = "k"})

local function entry() return widget{type = "entry"} end
local function eventbox() return widget{type = "eventbox"} end
local function hbox() return widget{type = "hbox"} end
local function label() return widget{type = "label"} end
local function notebook() return widget{type = "notebook"} end
local function vbox() return widget{type = "vbox"} end

function window.build()
	local w = {
		win = widget{type = "window"},
		ebox = eventbox(),
		layout = vbox(),
		tabs = notebook(),
		tbar = {
			layout = hbox(),
			ebox = eventbox(),
			tablist = lousy.widget.tablist(),
			buf = label()
		},
		menu = lousy.widget.menu(),
		ibar = {
			layout = hbox(),
			ebox = eventbox(),
			promt = label(),
			input = entry()
		}
	}

	w.ebox:set_child(w.layout)
	w.win:set_child(w.ebox)

	local t = w.tbar
	t.layout:pack_start(t.tablist.widget, false, false, 0)
	t.layout:pack_start(t.buf, false, false, 0)
	t.ebox:set_child(t.layout)
	w.layout:pack_start(t.ebox, false, false, 0)

	w.layout:pack_start(w.tabs, true, true, 0)

	w.layout:pack_start(w.menu.widget, false, false, 0);
	w.menu:hide()

	local i = w.ibar
	i.layout:pack_start(i.prompt, false, false, 0)
	i.layout:pack_start(i.input, true, true, 0)
	i.ebox:set_child(i.layout)
	w.layout:pack_start(i.ebox, false, false, 0)

	i.input.show_frame = false
	w.tabs.show_tabs = false

	window.bywidget[w.win] = w

	return w
end

window.init_funcs = {
	notebook_signals = function (w)
		w.tabs:add_signal("page-added", function (nbook, view,idx)
			w:update_tablist()
		end)
		w.tabs:add_signal("switch-page", function (nbook, view, idx)
			w:set_mode()
			w:update_progress(view)
			w:update_tablist(idx)
			w:update_buf()
			w:update_ssl(view)
			w:update_hist(view)
		end)
	end,

	last_win_check = function (w)
		w.win:add_signal("destroy", function (w)
			if #luakit.windows == 0 then luakit.quit() end
			if w.close_win then w:close_win() end
		end)
	end,

	key_press_match = function (w)
		w.win:add_signal("key-press", function (_, mods, key)
			local success, match = pcall(w.hit, w, mods, key)
			if not success then
				w:error("In bind call: " .. match)
			elseif match then
				return true
			end
		end)
	end,	

	apply_window_theme = function (w)
		local i, t = w.ibar, w.tbar

		for wi, v in pairs({
			[t.buf] = theme.buf_tbar_fg,
			[i.prompt] = theme.prompt_ibar_fg,
			[i.input] = theme.input_ibar_fg
		}) do wi.fg = v end

		for wi, v in pairs({
			[t.ebox] = theme.tbar_bg,
			[i.ebox] = theme.ibar_bg,
			[i.input] = theme.input_ibar_bg
		}) do wi.bg = v end

		for wi, v in pairs({
			[t.buf] = theme.buf_tbar_font,
			[i.prompt] = theme.prompt_ibar_font,
			[i.input] = theme.input_ibar_font
		}) do wi.font = v end
	end,

	set_default_size = function (w)
		local size = globals.default_window_size or "1280x800"
		if string.match(size, "^%d+x%d+$") then
			w.win:set_default_size(string.match(size, "^(%d+)x(%d+)$"))
		else
			warn("E: window.lua: invalid window size: %q", size)
		end
	end,

	window.methods = {
		get_current = function (w) return w.tabs:atindex(w.tabs:current()) end,
		is_current = function (w, wi) return w.tabs:indexof(wi) == w.tabs:current() end,
		get_tab_title = function (w, view)
			view = view or w:get_current()
			return view:get_property("title") or view.uri or "(Untitled)"
		end,
	}

	hit = function (w, mods, key, opts)
		local opts = lousy,util.table.join(opts or {}, {
			enable_buffer = w:is_mode("normal"),
			buffer = w.buffer
		})

		local caught, newbuf = lousy.bind.hit(w, w.binds, mods, key, opts)
		if w.win then
			w.buffer = newbuf
			w:update_buf()
		end
		return caught
	end,

	match_cmd = function (w, cmd, opts)
		w:set_mode("command")
		w:set_input(cmd, opts)
	end,

	insert_cmd = function (w, str)
		if not str then return end
		local i = w.ibar.input
		local text = i.text
		local pos = i.position
		local left, right = string.sub(text, 1, pos), string.sub(text, pos + 1)
		i.text = left .. str .. right
		i.position = pos + #str
	end,

	activate = function (w)
		w.ibar.input:emit_signal("activate")
	end,

	del_word = function (w)
		local i = w.ibar.input
		local text = i.text
		local pos = i.position
		if text and #text > 1 and pos > 1 then
			local left, right = string.sub(text, 2, pos), string.sub(text, pos+1)
			if not string.find(left, "%s") then
				left = ""
			elseif string.find(left, "%w+%s*$") then
				left = string.sub(left, 0, string.find(left, "%w+%s*$") - 1)
			elseif string.find(left, "%W+%s*$") then
				left = string.sub(left, 0, string.find(left, "%W+%s*$") - 1)
			end
			i.text =  string.sub(text, 1, 1) .. left .. right
			i.position = #left + 1
		end
	end,

	del_line = function (w)
		local i = w.ibar.input
		if not string.match(i.text, "^[:/?]$") then
			i.text = string.sub(i.text, 1, 1)
			i.position = -1
		end
	end,

	del_backward_char = function (w)
		local i = w.ibar.input
		local text = i.text
		local pos = i.position

		if pos > 1 then
			i.text = string.sub(text, 0, pos - 1) .. string.sub(text, pos + 1)
			i.position = pos - 1
		end
	end,

	del_forward_char = function (w)
		local i = w.ibar.input
		local text = i.text
		local pos = i.position
 
		i.text = string.sub(text, 0, pos) .. string.sub(text, pos + 2)
		i.position = pos
	end,

	beg_line = function (w)
		local i = w.ibar.input
		i.position = 1
	end,

	end_line = function (w)
		local i = w.ibar.input
		i.position = -1
	end,

	forward_char = function (w)
		local i = w.ibar.input
		i.position = i.position + 1
	end,

	backward_char = function (w)
		local i = w.ibar.input
		local pos = i.position
		if pos > 1 then
			i.position = pos - 1
		end
	end,
 
	forward_word = function (w)
		local i = w.ibar.input
		local text = i.text
		local pos = i.position
		if text and #text > 1 then
			local right = string.sub(text, pos+1)
			if string.find(right, "%w+") then
				local _, move = string.find(right, "%w+")
				i.position = pos + move
			end
		end
	end,

	backward_word = function (w)
		local i = w.ibar.input
		local text = i.text
		local pos = i.position
		if text and #text > 1 and pos > 1 then
			local left = string.reverse(string.sub(text, 2, pos))
			if string.find(left, "%w+") then
				local _, move = string.find(left, "%w+")
				i.position = pos - move
			end
		end
	end,

	motify = function (w, msg, set_mode)
		if set_mode then
			w:set_mode()
		end
		w:set_prompt(msg, { fg = theme.notif_fg, bg = theme.notif_bg })
	end,

	warning = function (w, msg, set_mode)
		if set_mode ~= false then w:set_mode() end
		w:set_prompt(msg, { fg = theme.warning_fg, bg = theme.warning_bg })
	end,

	error = function (w, msg, set_mode)
		if set_mode ~= false then w:set_mode() end
		w:set_prompt("Error: "..msg, { fg = theme.error_fg, bg = theme.error_bg })
	end,

	set_prompt = function (w, text, opts)
		local prompt, ebox, opts = w.ibar.prompt, w.ibar.ebox, opts or {}
		prompt:hide()
		fg, bg = opts.fg or theme.ibar_fg, opts.bg or theme.ibar_bg
		if prompt.fg ~= fg then prompt.fg = fg end
		if ebox.bg ~= bg then ebox.bg = bg end
		if text then
			prompt.text = lousy.util.escape(text)
			prompt:show()
		end
	end,

	set_input = function (w, text, opts)
		local input, opts = w.ibar.input, opts or {}
		input:hide()
		fg, bg = opts.fg or theme.ibar_fg, opts.bg or theme.ibar_bg
		if input.fg ~= fg then input.fg = fg end
		if input.bg ~= bg then input.bg = bg end
		if text then
			input.text = ""
			input:show()
			input:focus()
			input.text = text
			input.position = opts.pos or -1
		end
	end,

	update_win_title = function (w, view)
		view = view or w:get_current()
		if link == "" then
			local loaded = ( loaded ~= "" ) and "[" .. loaded .. "]" or ""
			local scrolled = "[" .. scrolled .. "]"
			title = loaded .. scrolled
		else
			title = link
		end
		-- set title
	end,

	update_progress = function (w, view, p)
		view = view or w:get_current()
		p = p or view:get_property("progress")
	end,
}
