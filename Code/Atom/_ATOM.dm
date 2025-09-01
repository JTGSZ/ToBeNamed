/*
	Atom Parent
	Theres an icon and no state on it yeah.
	If shit appears in the world thats invisible, then by default the no name icon in that file will be set onto it which is a error message
*/
/atom
	name = "ERROR"
	desc = "If you see this then I fucked up"
	icon = 'zAssets/Filler_Icons.dmi' 

// The first step in the process you make something new
/atom/New(loc, ...)
	. = ..()
	// mapload is ogre, time to just initialize
	if(mapload_ogre)
		Initialize(arglist(args))
		total_atoms_initialized++
	else // mapload is not ogre, time to put our nice ass in a list
		atoms_init_queue |= src
		
// A proc called after New() so we aren't stuck with timing problems in New()
/atom/Initialize()
	. = ..()

/*
	Called when you try to qdel something
	Don't do it to turfs and areas
*/
/atom/Destroy()
	..()
	invisibility = 101 //WE are trying to delete it, why let people even attempt to see or fucks with it
	

/*
	In an effort to keep things dynamic Ill just make all the normal flag checks here
	To note everything that can listen and that a message reaches will receive it
	But they might not do anything with it.
*/
/atom/proc/receive_message(message_data)
	return FALSE

//We clicked the thing, we can tell the user it happened and they clicked on something too
/atom/Click(location, control, params)
	usr.clicked_an_atom(src, params)
	