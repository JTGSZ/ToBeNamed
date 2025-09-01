/*
	Here is our flesh pilot
	the soul part of the trio and its the mob
*/

/mob/player_soul
	name = "ERROR" //These nigas need names
	icon = 'zAssets/Mob/unsorted.dmi'
	icon_state = "ghost"
	desc = "Effectively (probably) two parts of a three part being."

	//We a ghooost(soul)
	alpha = 128
	see_invisible = INVISIBILITY_DEBUGGING_REALITY
	invisibility = INVISIBILITY_SOULSPACE
	
	density = FALSE
	//The current body we are supposed to be piloting.
	var/atom/movable/the_body = null

/mob/player_soul/New(loc)
	..()

/mob/player_soul/Initialize()
	..()

	var/mob/comms_listener/CL = new()
	CL.data_link_to_target(src)
	CL.movement_link_to_target(src)
	CL.toggle_flag(COMMS_FLAG_AUDIO)

/mob/player_soul/MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
	//world_msg("[over_object]")

	if(src.client && usr.client.admin_data) // If this thing has a client, and the person mousedropping it into something else is an admin, as we get a usr from this.
		if(ismob(over_object))
			var/mob/cram_us_in = over_object
			src.client.eye = cram_us_in
			//target_mob.ckey = src.ckey This would straight up just transfer clients across mobs
			src.loc = cram_us_in // instead just slide us right into this things contents

	
	
