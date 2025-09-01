/*
	This is just a datum full of data that is crammed into Loaded_player_persistence_data which is a global list.
	Its key is the ckey of the person related to it
*/

/datum/player_persistence_data
	// Lets start with the pref vars
	var/client_fps = 0 // The client fps we are currently at, at 0 it just jumps straight to the recommended on client join
	var/client_game_volume = CONFIG_PREF_DEFAULT_GAME_VOLUME // the volume of the game sound obviously
	var/OOC_text_color
	var/IC_text_color
	var/EMOTE_text_color

	//To note this is also held on the client, so keep that in mind.
	// Actual Key input - Actual action
	var/list/input_keymap = list(
	)

//Do you want to put everything in twice? We need a way to reset this shit back to defaults anyways.
/datum/player_persistence_data/proc/all_persistence_data_to_defaults()
	persistence_misc_pref_to_default()
	persistence_inputmap_to_default()

/datum/player_persistence_data/proc/persistence_misc_pref_to_default()
	client_fps = 0
	client_game_volume = CONFIG_PREF_DEFAULT_GAME_VOLUME
	OOC_text_color = "#5f2dd4" //The color of our ooc text
	IC_text_color = "#cef257"
	EMOTE_text_color = "#69e6ff" //TODO

/datum/player_persistence_data/proc/persistence_inputmap_to_default()
	input_keymap = build_a_default_keymap_list()
	
