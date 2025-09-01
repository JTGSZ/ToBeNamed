/*
	Eh, theres no reason to split it right now. But my gut tells me I should.
	Maybe there will be multiple ways someone wants to retrieve this/handle it who knows.
*/

/datum/Persistence_JSON/proc/load_player_data_via_ckey(target_ckey)
	if(fexists("[CONFIG_PERSIST_PLAYERDATA_FOLDER][target_ckey]/[target_ckey].json")) //they got something stored with us, they've been here before.
		var/reading = file("[CONFIG_PERSIST_PLAYERDATA_FOLDER][target_ckey]/[target_ckey].json") //so we get the file
		var/list/retrieved_data = json_decode(file2text(reading)) //Now we convert said file into a list

		if(retrieved_data["version"] != CONFIG_PERSIST_PLAYER_DATA_VERSION) //The loaded in shit ain't on the same version ours is.
			retrieved_data = player_data_version_update(retrieved_data)


		var/datum/player_persistence_data/player_data = new()
		//And at this point heres where we like... stick all of it onto the datum.
		player_data.client_fps = retrieved_data["client_fps"]
		player_data.client_game_volume = retrieved_data["client_game_volume"]
		player_data.input_keymap = retrieved_data["input_keymap"]

		player_data.OOC_text_color = retrieved_data["OOC_text_color"]
		player_data.IC_text_color = retrieved_data["IC_text_color"]
		player_data.EMOTE_text_color = retrieved_data["EMOTE_text_color"]

		player_persistence_data_cache["[target_ckey]"] = player_data //heres where we actually set the assc key to the datum
		return TRUE // We return a true cause we have succeeded
	else //The file didn't exist
		return FALSE //So we return a false