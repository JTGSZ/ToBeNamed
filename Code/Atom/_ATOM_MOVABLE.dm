/*
	Atom movable parent and the things below it which would be obj and mob
	USE THIS FOR WHEN YOU WANT TO ADD MOVEMENT SHIT TO EVERYTHING RELATED TO IT
	AKA OBJ AND MOB
*/

/atom/movable
	var/hard_deleted //Deletion check
	step_size = 6

	// The last loc we wuz at
	var/atom/Last_loc

/atom/movable/New()
	. = ..()

/*
	Loc is a reference, on atom is apparently a constant value, so we nab it here right below obj and mob
	Also make sure to cleanup all ur references
*/
/atom/movable/Destroy()
	INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_ON_DESTROY, src)
	Last_loc = null
	loc = null
	..()

/*
	From we hit key, client has move called on it
	client sees its mob is in a thing, it calls relay move
	Thing sees its in a thing, we continue the chain.
*/
/atom/movable/proc/relayMove(move_inputter, dir)
	if(!isturf(src.loc)) // If we are yet another thing inside of a thing, time to continue relaying the move
		var/atom/movable/vore_mommy = src.loc 
		vore_mommy.relayMove(src, dir)
	else
		step(src, dir)



/*
	THERE ARE SOME THINGS TO NOTE
	PIXLOC.loc IS A REFERENCE THAT LOSES ITS TYPE IN THE COMPILER FOR SOME REASON
	PIXLOC = ATOM DOES WORK INSERTING IT INTO SOMETHING ELSE
	PIXLOC = ATOM ALSO OBLITERATES PIXLOC TURNING IT INTO NULL
	PIXLOC WILL NOT REPLACE LOC AT THE MOMENT

	Also this is just so you can get all the movement procs called and also force something to another location
*/
/atom/movable/proc/forceMove(target)
	var/list/atom/prev_locs = locs
	var/atom/old_loc = loc
	var/list/atom/uncrossed

	if(isturf(loc))
		uncrossed = obounds(src)
	else
		uncrossed = loc?.contents 

	pixloc = target

	if(Last_loc != loc)
		INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, old_loc, loc)
		Last_loc = loc

	// If pixloc is null then we are now inside of something, the null check is probably faster than a type check
	if(isnull(pixloc))
		INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_CONTENTS_FORCED_INTO, loc, old_loc, loc)
		INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_FORCED_INTO_CONTENTS, src, old_loc, loc)
		INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_ON_MOVE, src, loc, dir, target:pixloc:step_x, target:pixloc:step_y)
	else
		INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_ON_MOVE, src, loc, dir, pixloc.step_x, pixloc.step_y) 

	for(var/atom/A in prev_locs)
		A.Exited(src, loc)
	for(var/atom/A in uncrossed)
		A.Uncrossed(src)

	if(loc)
		for(var/atom/A in locs)
			A.Entered(src, old_loc)
		if(isturf(loc))
			var/area/A = loc.loc
			A.Entered(src, old_loc)

			for(var/atom/movable/AM in obounds(src))
				AM.Crossed(src)


/*
	Similar to what you can do with forcemove
	except it doesn't call the movement procs
*/
/atom/movable/proc/force_into_contents(atom/movable/target)
	INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_CONTENTS_FORCED_INTO, target, loc, target)
	INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_FORCED_INTO_CONTENTS, src, loc, target)
	loc = target

//If this doesn't return anything, you do in fact not move.
/atom/movable/Move(NewLoc, Dir, step_x, step_y)
	// shitty performance measure as we are no longer one turf locked, but we are one still coord locked
	if(Last_loc != loc)
		INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, Last_loc, loc)
		Last_loc = loc

	INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_ON_MOVE, src, NewLoc, Dir, step_x, step_y)
	glide_size = (CONFIG_WORLD_ICON_SIZE / step_size) * world.tick_lag
	//glide_size = 1
	// TODO: MAKE A WORKING CALCULATION FOR THIS SHIT SOMEDAY
	. = ..()


/atom/movable/proc/force_move(spd, dist, _dir)
	glide_size = (spd * dist)
	step(src, _dir, glide_size)