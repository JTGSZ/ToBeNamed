var/datum/world_slave_system/timer_callbacks/SSTimerCallbacks

/*
	This guy just tries to perform a proc call with args of ur choice at a specified time
	You can pause, resume, or modify the shits too if you needed to hitup your bitch 4 minutes from now but might be late by two
	Which is one of two reasons you would consider using this over a spawn call
	this won't help you with sleeps though, set your procs src to null or some shit for those if you even care about refs

*/

/datum/world_slave_system/timer_callbacks
	name = "Timer Callbacks"
	
	initialize_order = SS_INIT_TIMER_CALLBACKS
	tick_usage_priority = SS_PRIORITY_TIMER_CALLBACKS
	stat_panel_display_rank = SS_DISPLAY_TIMER_CALLBACKS
	tickdelay_before_next_work = 2

	var/alist/list_of_active_timers = alist()
	var/alist/paused_timers = alist()
	var/current_timer_id = 1

/datum/world_slave_system/timer_callbacks/New()
	SSTimerCallbacks = src


// As you can see, this is the part where we do the work and call all the retarded shit hooked onto us
// TODO figure out a way to sort things that is more performant than iterating all the timers so we aren't iterating all the timers
/datum/world_slave_system/timer_callbacks/Do_Work()
	for(var/timer_id as anything in list_of_active_timers)
		if(world.timeofday > list_of_active_timers[timer_id]:target_firetime) // there should hopefully only be the datums for this ss in here lol
			Fire_Timer_Callback(timer_id)

/*
	That last one is where you'd put your arguments for the proc call ur trying to do later btw
	So the syntax would be something like Add_Time(src, .proc/this_proc_on_ref, 5 SECONDS, TRUE, FALSE, "STRING", NUM, arguments etc )
	We have a convenient define for this too ADD_REALTIMER() with the same params
*/
/datum/world_slave_system/timer_callbacks/proc/Add_Timer(datum/target_ref, proc_ref, delay_time, ...)
	var/datum/timed_callback_data/nu_data = new()

	nu_data.timer_id = current_timer_id
	nu_data.string_ref = "[ref(target_ref)]"
	nu_data.proc_ref = proc_ref
	nu_data.delay_time = delay_time
	nu_data.target_firetime = world.timeofday + delay_time
	nu_data.arguments = args.Copy(4) // we copy everything at position 4 and afterwards into a list lol


	// TODO probably convert random shit in args that is a ref into a string ref, and vice versa while allowing actual string arguments to not hold a ref
	list_of_active_timers[nu_data.timer_id] = nu_data
	current_timer_id++
	return nu_data.timer_id


// Idk, if you feel like removing it i guess
/datum/world_slave_system/timer_callbacks/proc/Remove_Timer(timer_id)
	var/datum/timed_callback_data/target_data

	if(timer_id in list_of_active_timers)
		target_data = list_of_active_timers[timer_id]
		list_of_active_timers.Remove(timer_id)
		qdel(target_data)

	if(timer_id in paused_timers)
		target_data = paused_timers[timer_id]
		paused_timers.Remove(timer_id)
		qdel(target_data)


/*
	Of course here is the point to even use these guys over spawn which would be the ability to do anything to it after we schedule it
	If keep_initial_delay is set to TRUE then that means you basically just restart the entire time when you resume it
*/
/datum/world_slave_system/timer_callbacks/proc/Pause_Timer(timer_id, keep_initial_delay = FALSE)
	var/datum/timed_callback_data/target_data = list_of_active_timers[timer_id]

	if(target_data)
		if(!keep_initial_delay)
			// To note we are here because we have not yet fired in the first place... soooo
			// We can get the remaining delay time by subtracting the current timeofday from the end point
			target_data.delay_time = target_data.target_firetime - world.timeofday

		paused_timers[timer_id] = target_data
		list_of_active_timers.Remove(timer_id)

/*
	And we resume it after doing some math to find the new firetime
*/
/datum/world_slave_system/timer_callbacks/proc/Resume_Timer(timer_id)
	if(paused_timers[timer_id])
		var/datum/timed_callback_data/target_data = paused_timers[timer_id]
		target_data.target_firetime = world.timeofday + target_data.delay_time // here is our new target fire time
		list_of_active_timers[timer_id] = target_data
		paused_timers.Remove(timer_id)

/*
	We just fire it to the best of our abilities
*/
/datum/world_slave_system/timer_callbacks/proc/Fire_Timer_Callback(timer_id)
	var/datum/timed_callback_data/target_data = list_of_active_timers[timer_id]

	var/datum/actual_ref = locate(target_data.string_ref)

	if(!actual_ref) // the thing is gone, idk we need to clean out the refs if we just dump the list out, but we will find out
		list_of_active_timers.Remove(timer_id)
		return

	call(actual_ref, target_data.proc_ref)(arglist(target_data.arguments))
	list_of_active_timers.Remove(timer_id)
	qdel(target_data)


/datum/world_slave_system/timer_callbacks/stats_display()
	var/msg = "Active Timers: [list_of_active_timers.len], On Timer ID: [current_timer_id]"
	..(msg)


/*
	Just a datum so I'm not using a list with index number targeting all over this file
*/
/datum/timed_callback_data
	var/timer_id
	var/string_ref
	var/proc_ref

	var/delay_time
	var/target_firetime

	var/list/arguments

/datum/timed_callback_data/Destroy()
	arguments.Cut()
	. = ..()
	
