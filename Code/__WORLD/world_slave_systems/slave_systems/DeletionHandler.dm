var/datum/world_slave_system/DeletionHandler/SSDeletionHandler
/*
	El deletion handler and tracker, its not the actual garbage collector,
	Instead it exists to tell you hey you missed some damn refs, enjoy the upcoming lag from this del() proc call
	Basically the main goal is to get everything to be garbage collected via having no refs on what we want gone.
	
	- Scenarios -
	1. If Del() is called you potentially get a loop through everything in the world to forcibly clean those refs after it checks the "most likely" shit for refs to clean
	2. If nothing is called and you have refs it just lingers in memory forever, it could take hours to days/weeks for the OOM crash to occur honestly.
	3. If the thing has no refs, byond will garbage collect it at some point or another (Normally immediately) making it disappear into the void

	To note, ATOM can have areas and turfs, you have 1 area and 1 turf per every segment of the map so you can't really delete those worth a shit
	This is represented by the loc not being able to be nulled out, and yes the loc is in fact a weirdo ref
	If you do manage to delete either retarded shit occurs.

	Which means we try to run objects and mobs primarily through here (Atom/Movable), and anything else that has no loc that can hold refs like datums

*/

/datum/world_slave_system/DeletionHandler
	name = "Deletion Handler"

	initialize_order = SS_INIT_DELETION_HANDLER
	tick_usage_priority = SS_PRIORITY_DELETION_HANDLER
	stat_panel_display_rank = SS_DISPLAY_DELETION_HANDLER
	tickdelay_before_next_work = 100

	// This is the asslist of things queued for deletion
	// \ref is https://www.byond.com/docs/ref/index.html#/DM/text/macros/ref
	// Which is basically a text macro which can be used for a weakref that also can be used to provide a ref in html shit too
	// You can find the exact object via using locate(\ref[thing]), the value is the world.timeofday qdel() was called with it
	// CONTENTS - alist("[\ref[REF_TO_THING]]" = world.timeofday)
	var/alist/queued_deletions = alist()

	// Total amount of times del() got called on something here for reasons
	var/hard_deletions = 0
	// Total amount of deletions of both the del() and refcleaned variety
	var/total_deletions = 0

/datum/world_slave_system/DeletionHandler/New()
	SSDeletionHandler = src

// the thing that was qdel'd gets this many seconds to live uselessly before it is forced to perish if it still exists
#define TIMELIMIT_BEFORE_DEL (CONFIG_GARBAGE_QDEL_QUEUE_DELAY_IN_SECONDS SECONDS)

/datum/world_slave_system/DeletionHandler/Do_Work()
	var/timelimit_before_forcedelete = world.timeofday - TIMELIMIT_BEFORE_DEL
	// Curious as to what a reference ID is and didn't look at the var comments in the definition of the list?
	// Take a look at this! https://www.byond.com/docs/ref/index.html#/DM/text/macros/ref
	for(var/reference_id as anything in queued_deletions)

		var/qdel_was_called_at_this_time = queued_deletions[reference_id]

		// If qdel occurred earlier than the current timelimit before we force a del() call on something otherwise we continue on
		if(qdel_was_called_at_this_time > timelimit_before_forcedelete)
			break

		var/datum/D = locate(reference_id)
		// As you can see something has a lingering attachment and won't move the fuck on
		if(D)
			if(isnull(D.gcDestroyed))
				removeTrash(reference_id)
				continue

			if(ismovable(D))
				var/atom/movable/AM = D
				AM.hard_deleted = 1

			#ifdef CONFIG_GARBAGE_QDEL_HARDREF_INFORM_MSG
				world_msg("[D] hard deleted, you left some hardrefs attached")
			#endif

			#ifdef CONFIG_GARBAGE_STOP_DEL_TURN_ON_REF_FIND
				Find_Ref(D)
			#else
				del D
			#endif

			removeTrash(reference_id)
			hard_deletions++

		else // This guy has passed on and all that is left is the weakref in the form of the /ref text macro as a key, get rid of it
			removeTrash(reference_id)

		
		// If world.tick_usage is currently over the allocated limit for us slaves we stop our work and try again next run
		if(WSSLAVE_ALLOCATION_CHECK)
			return


/datum/world_slave_system/DeletionHandler/proc/addTrash(datum/D)
	if(istype(D, /atom) && !istype(D, /atom/movable))
		return

	removeTrash("\ref[D]") //This makes sure the new entry is at the end in the event D is using a recycled ref already in the queue.
	queued_deletions["\ref[D]"] = world.timeofday

/datum/world_slave_system/DeletionHandler/proc/removeTrash(reference_id)
	if(queued_deletions.Remove(reference_id))
		total_deletions++

/datum/world_slave_system/DeletionHandler/stats_display()
	var/msg = "In Queue:[length(queued_deletions)] | Total:[total_deletions] | HardDelCalls:[hard_deletions]"
	..(msg)
	


/*
	The queue deletion proc, this just checks us into the deletionhandler to be tracked and handled
*/
/proc/qdel(datum/D)
	// Good job putting jackshit into qdel()
	if(isnull(D))
		return

	// We are about to delete either a area or a turf which probably will go pretty retardedly, lets not support this behavior right now
	if(istype(D, /atom) && !istype(D, /atom/movable))
		ERROR_MSG("AREA OR TURF PASSED INTO qdel(). [D.type]. THESE CAN'T BE DELETED WORTH A SHIT.")
		return

	// We have no deletion handler, just straight up try to delete it
	if(isnull(SSDeletionHandler))
		del(D)
		return

	// We currently don't have a status string in that var, so it is time to do the needful
	if(isnull(D.gcDestroyed))
		// Let our friend know they're about to get fucked up.
		D.Destroy()
		SSDeletionHandler.addTrash(D)

/*
	Listen man Im trying, this currently still sucks and hasn't found shit for me yet though
*/
/datum/world_slave_system/DeletionHandler/proc/Find_Ref(datum/D)
	if(istype(D,/atom/movable))
		var/atom/movable/A = D
		if(A.loc != null)
			world_msg("[A.type] still has a loc aka on the map")
		if(length(A.contents))
			world_msg("[A.type] has contents inside of it")

	for(var/our_var_key in D.vars)
		var/current_var = D.vars[our_var_key]
		if(isdatum(current_var))
			world_msg("Found a ref of [current_var:type]:[ref(current_var)] in \"var/[our_var_key]\" - [D.type]:[ref(D)]")

	for(var/atom/A in world)
		if(A == D)
			continue
		for(var/var_key in A.vars)
			if(var_key == "vars")
				continue
			var/current_thing = A.vars[var_key]

			if(current_thing == D)
				world_msg("Found the ref of [D.type]:[ref(D)] in \"var/[var_key]\" - [A.type]:[ref(A)]")
				continue

			if(islist(current_thing))
				for(var/in_list as anything in current_thing)
					if(in_list == D)
						world_msg("Found the ref of [D.type]:[ref(D)] in \"var/[var_key]\" - [A.type]:[ref(A)]")
						continue
				continue

	for(var/global_thing_key in global.vars)
		if(global_thing_key == "vars")
			continue

		var/datum/actual_global = global.vars[global_thing_key]
		if(isdatum(actual_global))
			for(var/actual_global_varkey in actual_global.vars)
				var/thing_in_global = actual_global.vars[actual_global_varkey]
				if(thing_in_global == "vars")
					continue
				if(thing_in_global == D)
					world_msg("Found the ref in [thing_in_global]")
			
