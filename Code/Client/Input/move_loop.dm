
/client
	var/mloop = 0
	var/move_dir = 0 //keep track of the direction the player is currently trying to move in.
	var/true_dir = 0
	var/keypresses = 0

//thanks to ter13 and /vg/station for this.

	//First number - DIR
	//Second number - Keydown = 1, Keyup - 0
	//Directions:
	//NORTH = 1
	//SOUTH = 2
	//EAST = 4
	//WEST = 8
	//Diagonals
	//NORTHEAST = 5
	//NORTHWEST = 9
	//SOUTHEAST = 6
	//SOUTHWEST = 10

/client/verb/movement_key(Dir as num, State as num)
	set hidden = 1
	set name = ".movement_key"
	set instant = 1

	//if we are currently not moving at the start of this function call, set a flag for later
	if(!move_dir)
		. = 1
	//get the opposite direction
	var/opposite = opposite_dirs[Dir]
	if(State)
		//turn on the bitflags
		move_dir |= Dir
		keypresses |= Dir
		//make sure that conflicting directions result in the newest one being dominant.
		if(opposite&keypresses)
			move_dir &= ~opposite

	else
		//turn off the bitflags
		move_dir &= ~Dir
		keypresses &= ~Dir

		//restore non-dominant directional keypress
		if(opposite & keypresses)
			move_dir |= opposite

		else
			move_dir |= keypresses

	true_dir = move_dir

	//if earlier flag was set, and we now are going to be moving
	if(. && true_dir)
		move_loop()

/client/proc/move_loop()
	set waitfor = 0
	if(src.mloop) 
		return
	mloop = 1
	while(src.true_dir)
		sleep(world.tick_lag)
		if(src.true_dir)
			src.Move(mob.loc,true_dir)
	mloop = 0


