/*
	This guy just sits in the contents of something and forces it to step with a loop
*/
/obj/debug/retarded_forced_movement_thing
	name = "Retarded movement forcer"
	desc = "You cram it in something and it forces movement to whatever direction it is"
	var/atom/movable/our_slave = null
	var/forced_moving = FALSE
	var/current_forcemove_delay = 0.6

// When you put a atom movable thing(Object or Mob types) into the params, it should try to link up
/obj/debug/retarded_forced_movement_thing/New(loc)	
	..()

/obj/debug/retarded_forced_movement_thing/Initialize()
	..()
	handle_linkage()

// clean up the refs, and preferably stop that while loop while we are at it
/obj/debug/retarded_forced_movement_thing/Destroy()
	forced_moving = FALSE
	our_slave = null
	..()
	
// Link us to something, aka put the ref in and slam us into said thing
/obj/debug/retarded_forced_movement_thing/proc/handle_linkage(atom/movable/link_to_this)
	if(link_to_this)
		our_slave = link_to_this
		force_into_contents(link_to_this)
		forced_moving = TRUE
		dumbass_movement_loop()
	else // If this exists on the map its going to just search the turf its on and force itself into the first object or mob that is ontop of it
		var/turf/T = get_turf(src)
		for(var/atom/movable/victim in T.contents)
			if(victim == src)
				continue
			our_slave = victim // the ref
			force_into_contents(victim) // And now we insert it into their ass
			forced_moving = TRUE
			dumbass_movement_loop()
			return TRUE
		// If we don't find anything in the loop, just delete it
		qdel(src)
		return FALSE
	
/obj/debug/retarded_forced_movement_thing/proc/dumbass_movement_loop()
	
	if(!our_slave) // what is the point of it existing without being attached to something
		qdel(src)
		return
	while(forced_moving)
		step(our_slave, dir)
		sleep(current_forcemove_delay)

/*
	When something with the retarded forced movement thing in its contents passes over this,
	it should change the direction of the retarded forced movement thing,
	which in turn forces the thing that its currently linked to to also change direction in its forced march
*/
/obj/debug/dir_changer
	name = "Direction Changer"
	desc = "A object that changes the direction of something that steps on it"
	icon_state = "dir_arrows"

// This forces the dumb object in the contents of something to swap its dir to the direction of this thing its slave just walked over
/obj/debug/dir_changer/Crossed(atom/movable/AM)
	for(var/obj/debug/retarded_forced_movement_thing/RFMT in AM.contents)
		RFMT.dir = dir

/*
	retarded set of things so you don't have to set dir with a mapvar
*/
/obj/debug/dir_changer/north
	dir = NORTH

/obj/debug/dir_changer/south
	dir = SOUTH

/obj/debug/dir_changer/east
	dir = EAST

/obj/debug/dir_changer/west
	dir = WEST

/obj/debug/dir_changer/northeast
	dir = NORTHEAST

/obj/debug/dir_changer/northwest
	dir = NORTHWEST

/obj/debug/dir_changer/southeast
	dir = SOUTHEAST

/obj/debug/dir_changer/southwest
	dir = SOUTHWEST
