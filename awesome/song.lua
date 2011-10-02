song_widget = widget ({ type = "textbox", name = "tb_song", align = "right" })

function get_song ()
	local f = io.popen("mpc current")
	local t0 = f:read()
	f:close()

	f = io.popen("mpc")
	local t1 = f:read("*all")
	f:close()

	t1 = string.find(t1, "[paused]", 1, true)
	if t1 then
		t0 = "..paused.."
	end

	return t0
end

function update_song (widget)
	song = get_song() or ""
	if #song > 83 then
		song = string.sub(song, 1, 40) .. "..." .. string.sub(song, -40)
	end
	song = " " .. song .. " "
	
	widget.text = song
end

--coroutine.create(update_song)

update_song(song_widget)
awful.hooks.timer.register(1, function () update_song(song_widget) end)
