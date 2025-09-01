
// Just sets see_Invisible
/client/proc/toggle_debugvision()
	set name = "Toggle Debugvision"
	set desc = "Set see_Invisible to INVISIBILITY_DEBUGGING_REALITY or vice versa"
	set category = "Debug"

	if(src.mob.see_invisible == INVISIBILITY_DEBUGGING_REALITY)
		src.mob.see_invisible = initial(src.mob.see_invisible)
	else 
		src.mob.see_invisible = INVISIBILITY_DEBUGGING_REALITY