#define DIRS list(NORTH,SOUTH,EAST,WEST,NORTHWEST,SOUTHWEST,NORTHEAST,SOUTHEAST)
//Now has full inverted bitflag support!
var/static/list/opposite_dirs = list(SOUTH,NORTH,NORTH|SOUTH,WEST,SOUTHWEST,NORTHWEST,NORTH|SOUTH|WEST,EAST,SOUTHEAST,NORTHEAST,NORTH|SOUTH|EAST,WEST|EAST,WEST|EAST|NORTH,WEST|EAST|SOUTH,WEST|EAST|NORTH|SOUTH)

proc/dir2vector(dir)
	var/vector/v = vector(0,0)
	switch(dir&(EAST|WEST))
		if(EAST)
			v.x = 1
		if(WEST)
			v.x = -1
	switch(dir&(NORTH|SOUTH))
		if(NORTH)
			v.y = 1
		if(SOUTH)
			v.y = -1
	return v

/proc/dir2text(direction)
	switch(direction)
		if(NORTH)
			return "North"
		if(SOUTH)
			return "South"
		if(EAST)
			return "East"
		if(WEST)
			return "West"
		if(NORTHEAST)
			return "Northeast"
		if(SOUTHEAST)
			return "Southeast"
		if(NORTHWEST)
			return "Northwest"
		if(SOUTHWEST)
			return "Southwest"
		else
	return

/proc/text2dir(text)
	switch(text)
		if("NORTH")
			return NORTH
		if("SOUTH")
			return SOUTH
		if("EAST")
			return EAST
		if("WEST")
			return WEST
		if("NORTHEAST")
			return NORTHEAST
		if("NORTHWEST")
			return NORTHWEST
		if("SOUTHEAST")
			return SOUTHEAST
		if("SOUTHWEST")
			return SOUTHWEST