var/datum/world_slave_system/atom_initializer/SSAtomInitializer

/*
	This guy handles initialization which is just a proc we have after New() that gets called
	As to why that is important, you got no control over when New() is called sometimes
	A good example is when the server first starts up,
	You'd have to use spawns to disjoint the instructions provided in New() if it comes in before the data it needs on something else
*/


/*
	This is the list new shit crams itself into, the atom initializer will then proceed to work through it all
	Considering everything made ever is interacting with these, then the speed may be worth the sloppiness
*/
var/global/list/atoms_init_queue = list()
var/total_atoms_initialized = 0 // I could put it on this datum but globals are 2x faster....
// Mapload is ogre
var/mapload_ogre = FALSE

/datum/world_slave_system/atom_initializer
	name = "Atom Initializer"

	initialize_order = SS_INIT_ATOM_INITIALIZER
	tick_usage_priority = SS_PRIORITY_ATOM_INITIALIZER
	stat_panel_display_rank = SS_DISPLAY_ATOM_INITIALIZER
	tickdelay_before_next_work = 20
	does_work = TRUE // this guy only does his work once for now

	



/datum/world_slave_system/atom_initializer/New()
	SSAtomInitializer = src

/datum/world_slave_system/atom_initializer/Initialize_Slave_System()
	mapload_ogre = TRUE
	..()

// We currently have the contents of the world trapped into a list
// Initialize it now so we never worry about the order of things in New() at worldstart again
/datum/world_slave_system/atom_initializer/Initialize_Work()
	set waitfor = FALSE // There is a sleep somewhere in fucking there

	// Simplistic for now, we shall see if something needs to be done when there is more load
	for(var/atom/cur_target as anything in atoms_init_queue)
		atoms_init_queue.Remove(cur_target)
		cur_target.Initialize()
		total_atoms_initialized++

	
// I CBA to poke at the map shit loading super late right now
/datum/world_slave_system/atom_initializer/Do_Work()
	for(var/atom/cur_target as anything in atoms_init_queue)
		atoms_init_queue.Remove(cur_target)
		cur_target.Initialize()
		total_atoms_initialized++
	does_work = FALSE

/datum/world_slave_system/atom_initializer/stats_display()
	var/msg = "Init Queue: [atoms_init_queue.len] |MAP INIT OVER: [mapload_ogre] Total Init: [total_atoms_initialized]"
	..(msg)

