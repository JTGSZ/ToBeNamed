/*
	All this guy does is move around the map
	Or really whereve the fuck you want people to look at something while they are on the title screen
	Should potentially make it a object o well
	I imagine you will only have one, but if you add more i guess the new_player will pick from one to be shoved into
*/
GLOB_LIST(titlescreen_roamers) = list()

/mob/titlescreen_roamer
	name = "Titlescreen Roamer"
	desc = "All the new players are contained deep within its invisible ass."
	icon_state = "gear"
	density = FALSE
	invisibility = INVISIBILITY_DEBUGGING_REALITY

/mob/titlescreen_roamer/New()
	. = ..()

/mob/titlescreen_roamer/Initialize()
	..()
	GLOB.titlescreen_roamers += src
	SSGenericProcess.Add(src)

// I think it moving around retardedly is funny, but this should really be delayed at some point via a ticker or its own SS
/mob/titlescreen_roamer/Process()
	walk(src, dir)
	// walk_rand(src)

/mob/titlescreen_roamer/Move(NewLoc, Dir, step_x, step_y)
	. = ..()
	if(!.)
		dir = pick(DIRS-Dir)

	
