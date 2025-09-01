/*
	just some stuff related to saving the player persistence data
*/


//If we are periodically saving all the data, prob should code a way to skip dealing with data thats laying there from a client that has been logged off forever.
/datum/Persistence_JSON/proc/save_all_player_persistence_data()
	for(var/ckey in player_persistence_data_cache)
		save_player_data_to_json_via_ckey(ckey)

/datum/Persistence_JSON/proc/save_player_data_to_json_via_ckey(target_ckey)
	var/datum/player_persistence_data/target_data = player_persistence_data_cache["[target_ckey]"]

	if(!target_data)// Theres literally nothing there for us to work with, and we sure as hell ain't gonna save a default or some dumb shit
		return FALSE

	if(fexists("[CONFIG_PERSIST_PLAYERDATA_FOLDER][target_ckey]/[target_ckey].json")) //check if the file already exists
		if(!fdel("[CONFIG_PERSIST_PLAYERDATA_FOLDER][target_ckey]/[target_ckey].json")) //delete the old file.
			world_msg("Save Error: unable to clear [target_ckey]'s old file!") //Something fucked up happened
			return FALSE //stop here right now

	var/writing = file("[CONFIG_PERSIST_PLAYERDATA_FOLDER][target_ckey]/[target_ckey].json")
	var/list/data_to_save = list()
	
	//First thing in is the data version, this is important since it'll be auto modified if its different next load.
	data_to_save["version"] = CONFIG_PERSIST_PLAYER_DATA_VERSION

	//Now we handle the preference stuffs
	data_to_save["client_fps"] = target_data.client_fps
	data_to_save["client_game_volume"] = target_data.client_game_volume

	//the input map, which is their keybinds
	data_to_save["input_keymap"] = target_data.input_keymap

	// Some text colors
	data_to_save["OOC_text_color"] = target_data.OOC_text_color
	data_to_save["IC_text_color"] = target_data.IC_text_color
	data_to_save["EMOTE_text_color"] = target_data.EMOTE_text_color



	writing << json_encode(data_to_save)

