/*
	Spawn something
	I will try my best to offer u something other than just straight up putting a actual path in ok
	It might not be the best around but it will hopefully work
*/
/client/proc/spawn_atom()
	set name = "Spawn Atom"
	set desc = "Spawn a fuckin A T O M aka MAKE IT APPEAR FROM THIN AIR"
	set category = "Admin"

	if(!check_admin_rights(ADMIN_RIGHTS_ADMIN))
		return

	var/user_input = input("Enter type to find (blank for all, cancel to cancel)", "Search for type") as null|text
	if(isnull(user_input))
		return

	var/chosen_type_path_str = input("Spawn one of these") as null|anything in find_type_and_close_types(user_input)
	if(chosen_type_path_str)
		var/actual_path = text2path(chosen_type_path_str)
		var/atom/A
		if(isturf(actual_path))
			TODO("Make spawn atom work with turfs, as we have to swap one turf out for another and make sure everything is handled")
		else
			A = new actual_path(get_turf(usr))
		admin_msg("Admin [usr.key] has spawned [A.type].")


/*
	So we need to get a list of possible things and offer them in a input box retard
*/
// this thing may get retardedly nasty, and yea I could just port but im supposed to be attempting it on my own
var/global/list/retard_spawn_cache
var/global/list/retarded_all_types_cache

// Incase you want a retarded shortcut, it just crams the last thing in the path and slams it into the spawn cache for results
// Also the key isn't type sensitive in usage, so you can have both ScReEN ObJeCt and SCREEN OBJECT reach each other
var/global/list/retarded_shortcuts = list(
	"screen object" = /atom/movable/screen_object
)

/proc/find_type_and_close_types(THE_STRING_WORD)
	// We got a total list of all atoms here, now... we were also given a string, it could be anything in there man also let us only do this once
	if(isnull(retarded_all_types_cache))
		retarded_all_types_cache = typesof(/atom)

	// Now we need to see if they typed in something exact, and if not we need to give them the most relevant options my retarded ass can muster
	. = list()

	// Make sure they didn't give us a exact existing path,
	// Make sure there is no accidental / at the end too so we can help our nigga trying to be precise out
	if(THE_STRING_WORD[length(THE_STRING_WORD)] == "/")
		THE_STRING_WORD = copytext(THE_STRING_WORD, 1, length(THE_STRING_WORD)-1)
	var/test_check = text2path(THE_STRING_WORD)
	if(test_check in retarded_all_types_cache)
		. += THE_STRING_WORD
		return

	// If the retard spawn cache is feeling kinda empty, it is time for us to be the seed to fulfill the garden of retarded types
	if(isnull(retard_spawn_cache))
		retard_spawn_cache = list()
		// They did not give us a exact path, time to do the needful sir
		for(var/real_type_path in retarded_all_types_cache)
			// Convert the real type path to a string of the path
			var/string_type_path = "[real_type_path]"

			// Split the real type path into segments
			var/list/splitted_text = splittext(string_type_path, "/")
			// Go through all the segments, and cache the actual type to each possible retarded word they can put in
			for(var/text in splitted_text)
				// The string key of a segment of a type path didn't already exist, time to make it
				if(isnull(retard_spawn_cache[text]))
					retard_spawn_cache[text] = list()

				// Now insert the type path as a possibility if you provide the text
				retard_spawn_cache[text] += string_type_path
		

	// well we gotta find whether we gots a shortcut regardless of if its case sensitive or not
	for(var/shortcut_keywords in retarded_shortcuts)
		if(lowertext(shortcut_keywords) == lowertext(THE_STRING_WORD))
			var/shortcut_value_path_str = "[retarded_shortcuts[shortcut_keywords]]"
			var/list/splitted_shortcut_pathvalue = splittext(shortcut_value_path_str, "/")
			var/LAST_WORD = splitted_shortcut_pathvalue[length(splitted_shortcut_pathvalue)]
			. |= retard_spawn_cache[LAST_WORD]
			return

	// If they gave us a path once again split it up and then we just check every part and give them the results
	var/list/splitted_string_word = splittext(THE_STRING_WORD, "/")
	// Now, see if the word can be found in mister cache, if so add the contents of whats under its list to a possibility
	for(var/text_words in splitted_string_word)
		if(retard_spawn_cache?[THE_STRING_WORD])
			. |= retard_spawn_cache[THE_STRING_WORD]
			