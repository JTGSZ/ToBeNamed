/*
	This is just a marker on the map for reasons or whatever the fuck
*/
/*
	Map_Marker_lists - I imagine jus seperating all of these into their own lists would be more coder friendly
	But instead Ill jus handle it in the most lazy manner I can and automate it on their New()
	CONTENTS:
		"marker_name" = list(its full of /atom/mapmarkers that share the same name)

*/
GLOB_LIST(map_mark_list) = list()


/obj/map_mark
	name = "Map Marker"
	desc = "A marker for a MAP HEH"
	// The map marker spirit cannot be seen, perceived, or interacted with
	invisibility = INVISIBILITY_DEBUGGING_REALITY

/obj/map_mark/New(loc)
	handle_map_markers_list()
	..()

//For futures sake im gonna stick this here
/obj/map_mark/proc/handle_map_markers_list()
	//If we find a key, and the thing attached to it is a list we r good to go
	if( (GLOB.map_mark_list["[name]"]) && (islist(GLOB.map_mark_list["[name]"])) )
		GLOB.map_mark_list["[name]"] += src
	else //In the offchance we can't find the key, and a list isn't in there we handle it ourselves
		GLOB.map_mark_list["[name]"] = list()
		GLOB.map_mark_list["[name]"] += src


/obj/map_mark/new_player_start
	name = MAPMARK_NEWPLAYERSTART