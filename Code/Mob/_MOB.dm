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

/mob/Initialize()
	..()
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


	
