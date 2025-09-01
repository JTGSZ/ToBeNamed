/*
	I pumped this entire ui out in literally like 3 to 5 minutes literally
	Thank u browser datums
*/

/client/verb/display_pref_ui()
	set name = ".display_pref_ui"
	set hidden = 1

	var/datum/ui/pref_ui/ass = new()
	ass.requestor = src
	ass.display_pref_ui_menu()

/datum/ui/pref_ui

/datum/ui/pref_ui/proc/display_pref_ui_menu()
	var/datum/player_persistence_data/persist_data = player_persistence_data_cache["[requestor.ckey]"]
	var/html = ""
	
	html += "<a href='?src=\ref[src];reset_prefs_to_defaults=1'>Reset To Defaults</a><hr>"

	html += {"Current OOC Color: <span style='border:1px solid #161616; background-color: [persist_data.OOC_text_color];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<a href='?src=\ref[src];change_ooc_color=1'>Change</a><br>"}

	html += {"Current IC Color: <span style='border:1px solid #161616; background-color: [persist_data.IC_text_color];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<a href='?src=\ref[src];change_ic_color=1'>Change</a><br>"}

	html += {"Current EMOTE Color: <span style='border:1px solid #161616; background-color: [persist_data.EMOTE_text_color];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<a href='?src=\ref[src];change_emote_color=1'>Change</a><br>"}

	var/shown_fps
	if(persist_data.client_fps == 0)
		shown_fps = world.fps
	else
		shown_fps = persist_data.client_fps
	html += "Current Client FPS: <a href='?src=\ref[src];change_client_fps=1'>[shown_fps]</a><br>"
	html += "Current Game Volume: <a href='?src=\ref[src];change_client_game_volume=1'>[persist_data.client_game_volume]%</a><br>"

	our_window = new(requestor, "pref_ui", "Pref UI", 600, 450, src)
	our_window.html_content = html
	our_window.quickset_stylesheet(STYLESHEET_SS13_COMMON)
	our_window.fire_browser()

/datum/ui/pref_ui/Topic(href, href_list)
	. = ..()
	if(href_list["reset_prefs_to_defaults"])
		player_persistence_data_cache["[requestor.ckey]"].persistence_misc_pref_to_default()
		display_pref_ui_menu()

	if(href_list["change_ooc_color"])
		var/new_ooc_color = input(usr, "Choose your OOC color:", "OOC Color") as color|null
		if(new_ooc_color)
			player_persistence_data_cache["[requestor.ckey]"].OOC_text_color = new_ooc_color


		display_pref_ui_menu()
	if(href_list["change_ic_color"])
		var/new_ic_color = input(usr, "Choose your IC color:", "IC Color") as color|null
		if(new_ic_color)
			player_persistence_data_cache["[requestor.ckey]"].IC_text_color = new_ic_color

		display_pref_ui_menu()

	if(href_list["change_emote_color"])
		var/new_emote_color = input(usr, "Choose your EMOTE color:", "EMOTE Color") as color|null
		if(new_emote_color)
			player_persistence_data_cache["[requestor.ckey]"].EMOTE_text_color = new_emote_color

		display_pref_ui_menu()

	if(href_list["change_client_fps"])
		var/desiredfps = input(usr, "Choose your desired fps.\n-1 means recommended value (currently:[CONFIG_PREF_RECC_CLIENT_FPS])\n0 means world fps (currently:[world.fps])", "FPS", requestor.fps)  as null|num
		if(desiredfps)
			requestor.fps = desiredfps

			var/datum/player_persistence_data/found_data = Persistence_Controller.get_player_data(requestor.ckey)
			found_data.client_fps = desiredfps
			display_pref_ui_menu()

	if(href_list["change_client_game_volume"])
		var/datum/player_persistence_data/found_data = Persistence_Controller.get_player_data(requestor.ckey)
		var/desired_vol = input(usr, "Choose your new game volume. \n1-100 (currently: [found_data.client_game_volume]%)", "Game Volume", found_data.client_game_volume) as null|num
		desired_vol = clamp(desired_vol,0 ,100)
		if(desired_vol)
			found_data.client_game_volume = desired_vol
		display_pref_ui_menu()
			