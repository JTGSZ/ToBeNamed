/*

	The systems are slaves to the world
	Such is the price of existing in the byond realm.

*/

// How many loads we take before we start replacing the old ones inside of our list
// Used to find a average percentage of how much of a tick we used across many work cycles
#define HOTLOADS_AVG_MAX_LIST_LENGTH 20

/datum/world_slave_system
	// A name for our slave system
	var/name = "World Slave System"
	// The order we are initialized in against all other systems
	var/initialize_order = SS_INIT_UNDEFINED
	// The priority we have as slaves in receiving the world's bountiful gift of tick segments
	var/tick_usage_priority = SS_PRIORITY_UNDEFINED 
	// The order we are displayed on the stat panel provided
	var/stat_panel_display_rank = SS_DISPLAY_UNDEFINED
	// How many ticks before we do work again
	var/tickdelay_before_next_work = 50

	// If you set this to false, it doesn't do any work
	var/does_work = TRUE


/*
	WORKING VARS - AKA THESE ARE JUST USED TO DO INTERNAL WORK
*/
	// How many times we have worked
	var/amount_of_times_SS_worked = 0
	// Next tick we work on
	var/next_scheduled_tick_to_do_work = 0
	// The last tick we worked on
	var/last_tick_SS_worked = 0
	// The object used to make the text on the stats panel clickable
	var/obj/stat_click_object/info_readout

	// it makes things look cool and people can bitch at us if something's load is xtra hot at the cost of xtra loads
	var/last_hotload_percentage = 0 // THE LAST
	var/peak_hotload_percentage = 0 // THE PEAK
	var/avg_hotload_percentage = 0 // THE AVERAGE
	// lets record a set of hot loads
	var/list/hotloads_averages = list()
	

// If you ..() your journey shall stop here brother, as there are no deeper realms I want you to journey into from here
// But here is where we rightfully occupy our title
// If something exists before us, then it is a problem that YOU shall solve
/datum/world_slave_system/New()
	

/*
	Write the code for initialization of its domain here
	As you've noticed its setup similarly to a benchmark, because it actually does that lol
*/
/datum/world_slave_system/proc/Initialize_Slave_System()
	var/benchmark_start_time = world.timeofday

		// CODE GOES HERE
	Initialize_Work()

	var/benchmark_end_time = (world.timeofday - benchmark_start_time) / 10
	world_msg("Initialized [name] slavesystem within [benchmark_end_time] seconds!")
	dd_msg("Initialized [name] slavesystem within [benchmark_end_time] seconds.")

// Mostly so you don't gotta repaste those stupid messages
/datum/world_slave_system/proc/Initialize_Work()

/*
	 The point of the slave system is to do work
	So we will do our work in this proc aptly named Do_Work which is called in the interval we specified on the system
*/
/datum/world_slave_system/proc/Do_Work()


/*
	In its current form we are just shooting our load straight into mob stats
	But perhaps one day we can have something else here
*/
/datum/world_slave_system/proc/stats_display(given_text)
	if(!info_readout)
		info_readout = new /obj/stat_click_object("Initializing...", src)
	var/msg = "CUR: [last_hotload_percentage]% | AVG: [avg_hotload_percentage]% | PEAK: [peak_hotload_percentage]% || \t[given_text]"

	stat("[name]", info_readout.update_text(msg))

/*
	When they click the stat click object, it calls click and just calls this proc on the thing it is attached onto
*/
/datum/world_slave_system/proc/stat_click_object_click()
	if(!usr.client.admin_data)
		return

	usr.client.View_Variable(src)
	admin_msg("Admin [usr.key] is debugging the [src.name] Slave System.")

/*
	We just handle the peak percentage and add a percentage to the list
	So we can calculate a average across many iterations
	Which we also do here
*/
/datum/world_slave_system/proc/handle_bookkeeping(latest_hotload_percentage)
	last_hotload_percentage = latest_hotload_percentage

	// We hit a new record of hottest load
	if(latest_hotload_percentage > peak_hotload_percentage)
		peak_hotload_percentage = latest_hotload_percentage

	var/hotloads_length = length(hotloads_averages)
	if(hotloads_length >= HOTLOADS_AVG_MAX_LIST_LENGTH)
		hotloads_averages.Cut(1, 2) // Cut the front aka the oldest
		hotloads_averages += latest_hotload_percentage // And add a fresh new load

	// avoid the potential division by zero error here
	if(hotloads_length)
		// The average across a set of numbers, is the sum of all numbers added up divided by the amount of numbers in the set
		var/nu_avg_percentage = 0
		for(var/percentage as anything in hotloads_averages)
			nu_avg_percentage += percentage

		avg_hotload_percentage = nu_avg_percentage/hotloads_length


// undefine it here, as i doubt anything else needs it
#undef HOTLOADS_AVG_MAX_LIST_LENGTH