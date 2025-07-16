GLOB_LIST(mobs_in_world) = list()
/*
	MOB PARENT
*/
/mob


/*
	Called when we are first created
*/
/mob/New()
	. = ..()
	GLOB.mobs_in_world += src
/*
	Called when we are qdel'd
*/
/mob/Destroy()
	GLOB.mobs_in_world -= src
	..()
/*
	ON_INITIAL_CONNECTION -
		Basically client/New() calls this before it returns
		Basically theres a few things to note, if ..() is called here it will iterate through every single turf in the world.
		This is in an attempt to force it as close as possible to the coordinate position of 1,1,1 on the map.
	ON_MOB_SWAP - The scenario where you either set key = newshit or client.mob = whatev fuckin mob
		Basically just calls this
*/
/mob/Move(NewLoc, Dir, step_x, step_y)
	. = ..()
	

/mob/Login()

	//world_msg("Mob Login")
	//..()

/*
	ON_INITIAL_CONNECTION -
		Basically when client/Del() runs this is called on first connect
		It don't do nothin unless you want it to do something.
	ON_MOB_SWAP - The scenario where you either set key = newshit or client.mob = whatev fuckin mob
		Basically just calls this
*/
/mob/Logout()
	//world_msg("Mob Logout")
	..()


/mob/receive_message(datum/message_data/msg_data)
	if(client)
		client.receive_message(msg_data)
/*
	A mob with a client clicked on an atom and supercalled. 
	Let us give them a response on the instance of their type or near it
*/
/mob/proc/clicked_an_atom(atom/A, params)
	return

// A stat panel if you are on a mob.
/mob/Stat()
	..()
	//MC Stat Panel
	if(client && client.admin_data && client.inactivity < 1200)
		if(statpanel("MC"))
			stat("Location:", "([x], [y], [z])")
			stat("CPU:", "[world.cpu]")
			stat("Total Instances in World:", "[world.contents.len]")
			stat("Map CPU:", "[world.map_cpu]")

			stat(null)
			if(Master)
				Master.stat_entry()
			else
				stat("Master Controller:", "ERROR")
			if(Failsafe)
				Failsafe.stat_entry()
			else
				stat("Failsafe Controller:", "ERROR")

			if(GLOB)
				GLOB.stat_entry()

			if(Master)
				stat(null)
				for(var/datum/subsystem/SS in Master.subsystems)
					SS.stat_entry()

		if(statpanel("Tickets"))
			GLOB.admin_tickets.stat_entry()
			stat(null)
			for(var/datum/admin_ticket/cur_ticket in GLOB.admin_tickets.open_tickets)
				cur_ticket.stat_entry()
	
