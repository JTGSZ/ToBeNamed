/*
	Idk lets give world/Tick() a try over alternatives
	maybe it will bring amusement
*/

// Some States
#define WORLD_SS_STARTUP			1
#define WORLD_SS_INITIALIZING 	2
#define WORLD_SS_RUNNING			3
#define WORLD_ENDING			4


//to get the proper tick firing increments we can do
//ticks_since_last_fire = if 0 or negative entered queue
//ticks_since_last_fire - current_world_tick

//ok so we need to either add or subtract world tick from the last time it fired to figure out whether it needs to fire again ok



/*
	A stupid fact is global vars are apparently 2 times faster in all cases according to my dumb benchmark
	Realistically its only going to matter across 10,000,000 loops just like my dumb benchmark though
	
	Also before you shit out raw globals everywhere bypassing the global holder we have
	realize these guys are still gonna be tracked and clickable ingame for checking
*/



// If we put it in all caps it gets highlighted and looks pretty
// But this is just the current tick the world is on for no reason other than aesthetic purposes honestly
var/CURRENT_WORLD_TICK = 0

// The amount of the tick we want to allow our slaves to occupy
// Keep in mind, they may go over if something stupid occurs before they hit a check comparing the world.tick_usage to the limit
// If we hit 100 or go over that is where you encounter THE FREEZE (as there is no time to send updates to the client over work on the server)
var/CURRENT_SS_TICK_LIMIT = 100

var/CURRENT_SS_STATUS = WORLD_SS_STARTUP

// Idk if for some reason we are stuck unable to complete the internal contents we should skip work until we are next free
var/lodged_in_tickwork = FALSE

/world/Tick()
	CURRENT_WORLD_TICK++

	// we begin our work after everything has been initialized anyways
	if(CURRENT_SS_STATUS == WORLD_SS_RUNNING)
		
		// still haven't gotten out of the contents of the last world/Tick()
		//if(lodged_in_tickwork)
		//	return

		lodged_in_tickwork = TRUE // we are currently lodged in tickwork

		// We go down the firing order based on set priority, and we exit if we go over the tick usage limit.
		// Both DoWork() and this will check, so the slave loop breaks free if it can't get its work done in time
		// This is also like we done and also breaks free instead of queuing more slaves if we near the limit
		for(var/datum/world_slave_system/slave_to_the_system in world_slave_system_firing_order)
			if(!slave_to_the_system.does_work) // this guy does no work... for reasons
				continue

			if(CURRENT_WORLD_TICK >= slave_to_the_system.next_scheduled_tick_to_do_work)
				slave_to_the_system.next_scheduled_tick_to_do_work = CURRENT_WORLD_TICK + slave_to_the_system.tickdelay_before_next_work

				var/slave_tick_usage = WORLD_TICK_USAGE // Get the tick usage before we begin
				slave_to_the_system.Do_Work()

				// Get the tick usage after we are done
				// You get a number between 0 and 100 too, cause we can get a negative here which is basically 0%
				slave_tick_usage = clamp( (slave_tick_usage - WORLD_TICK_USAGE), 0, 100) 
				slave_to_the_system.handle_bookkeeping(slave_tick_usage) 

				slave_to_the_system.amount_of_times_SS_worked += 1 // One to your workscore
				slave_to_the_system.last_tick_SS_worked = CURRENT_WORLD_TICK

				

			CURRENT_SS_TICK_LIMIT = 100 - WORLD_RESERVED_TICK_USAGE - world.map_cpu
			// We are currently over the maximum limit given to our slaves get out of here and try again next time
			if(WORLD_TICK_USAGE > CURRENT_SS_TICK_LIMIT)
				break

		lodged_in_tickwork = FALSE // we are currently not lodged in tickwork


