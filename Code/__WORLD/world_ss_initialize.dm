

/*
	Setup all the world SS
	Basically they need made and prepped before the initialize stage
*/
// We could have two lists, instead have one list of all the slave systems ordered by how they should init
var/global/list/world_slave_systems

// Ordered list of the order they should fire
var/global/list/world_slave_system_firing_order

// Ordered list of the order they should be displayed
var/global/list/world_slave_system_display_order

/world/proc/Setup_World_Slave_Systems()
	set waitfor = FALSE
	// Make the lists lol
	world_slave_systems = list()
	world_slave_system_firing_order = list()
	world_slave_system_display_order = list()

	for(var/path in child_typesof(/datum/world_slave_system))
		var/datum/world_slave_system/slave_to_the_system
		slave_to_the_system = new path()
		world_slave_systems += slave_to_the_system
		world_slave_system_firing_order += slave_to_the_system
		world_slave_system_display_order += slave_to_the_system

	// Time to sort these guys now that we are locked and loaded
	sortTim(world_slave_systems, /proc/cmp_slavesystem_init) // unordered generi-list is sorted for init so it actually is ordered
	sortTim(world_slave_system_firing_order, /proc/cmp_slavesystem_priority) // Next up we have our tick usage priority
	sortTim(world_slave_system_display_order, /proc/cmp_slavesystem_display) // And now we have the display order
	
	sleep(1 SECONDS)
	//mapload_ogre 
	Initialize_World_Slave_Systems()
/*
	Initialize all the world SS
	They need to sort themselves into the proper order here too
*/
/world/proc/Initialize_World_Slave_Systems()
	set waitfor = FALSE
	CURRENT_SS_STATUS = WORLD_SS_INITIALIZING

	world_msg("Time to Initialize the world!")
	var/initialize_start_time = world.timeofday
	// SSS
	for(var/datum/world_slave_system/SSS in world_slave_systems)
		SSS.Initialize_Slave_System()
		CURRENT_SS_TICK_LIMIT = 100 - WORLD_RESERVED_TICK_USAGE - world.map_cpu

	initialize_start_time = world.timeofday - initialize_start_time
	world_msg("Initializations complete in [initialize_start_time / 10] seconds!")
	dd_msg("Initializations complete. Took [initialize_start_time / 10] seconds.")

	CURRENT_SS_STATUS = WORLD_SS_RUNNING



	


