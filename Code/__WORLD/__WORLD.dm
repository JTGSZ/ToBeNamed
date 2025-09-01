/*
	These are simple defaults for your project.
 */

/world
	name = "First Light"
	mob = /mob/new_player
	turf = /turf/floor

	fps = CONFIG_WORLD_FPS		// 25 frames per second
	icon_size = CONFIG_WORLD_ICON_SIZE	// 32x32 icon size by default

	//view = 6		// show up to 6 tiles outward from center (13x13 view)
	view = CONFIG_WORLD_VIEW
	movement_mode = PIXEL_MOVEMENT_MODE

	sleep_offline = CONFIG_WORLD_SLEEP_OFFLINE
	
// Make objects move 8 pixels per tick when walking
/*
	Area 
	Turf
	Atom/Movable news occur here
	Basically the map loads in before this is called
*/
/world/New()
	. = ..()
	GLOB = new() // basically the global holder lol
	sortInstance = new() //sorting interface shit
	AUDIO_TRACKER = new() // jus looks nice in stats and provides IDs

	Persistence_Controller = new() //Saving and loading handler
	Persistence_Controller.admin_json_directory_to_datumlist() //Admin datum loadin of all of them.

	build_bindcomm_data_cache() // Build the command cache for user inputted keybinds to be held against

	Setup_World_Slave_Systems() // Setup the world slave systems

/*
	When the world is told to shutdown this gets called, everything is still there for you to fucks with
	after it returns everythings dumped out of memory and everything goes byebye
*/
/world/Del()



