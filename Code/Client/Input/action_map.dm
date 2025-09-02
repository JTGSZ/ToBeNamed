/*
	The inputmap on the client is the one used for actual inputs
	The inputmap on the persistence_data is just the one thats saved/loaded and referenced from.
	This is a reminder to not avoid adding in-between functions sometimes.
*/
var/global/list/bindcomm_data_cache = list()

/*
	We build the cache
*/
/proc/build_bindcomm_data_cache()
	var/list/bindcomm_data_paths = sub_typesof(/datum/bindcomm_data)

	for(var/juicy_phatties in bindcomm_data_paths)
		var/datum/bindcomm_data/anime_thigh_inner_musculature = new juicy_phatties
		bindcomm_data_cache[anime_thigh_inner_musculature.command_name] = anime_thigh_inner_musculature



/proc/build_a_default_keymap_list()
	var/list/default_persist_keymap = list()
	for(var/cock in bindcomm_data_cache)
		default_persist_keymap[cock] = bindcomm_data_cache[cock].default_keybind

	return default_persist_keymap


//List of movement shits, im sleepy and checking via assc key feels ok
var/global/list/movement_commands = list(
	"movement_key 1" = TRUE,
	"movement_key 2" = TRUE,
	"movement_key 4" = TRUE,
	"movement_key 8" = TRUE,
	"movement_key 5" = TRUE,
	"movement_key 9" = TRUE,
	"movement_key 6" = TRUE,
	"movement_key 10" = TRUE
)

