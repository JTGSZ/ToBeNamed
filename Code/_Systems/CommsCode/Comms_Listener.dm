/*
	This object basically is on everything that wants to deal in communications
	It updates positions sometimes if the comms global procedures are being used.

	As to what handles what, the comms global procedures dictate whether these guys are even getting a message or not
	And these guys also try to determine whether we can even do anything with the message data received.
*/
GLOB_LIST(comms_listeners) = list()
 
/mob/comms_listener
	name = "comms listener"
	icon = 'zAssets/Filler_Icons.dmi' 
	icon_state = "green_check"

	//The thing we are supposed to send information to, which may not be what we are attached onto
	var/atom/data_linked_to

	density = 0
	invisibility = INVISIBILITY_DEBUGGING_REALITY

	// These are basically just flags to help decide what to do with the shit we are receiving
	var/list/comms_flags = list(COMMS_FLAG_NORMAL)

//We are only on mob for one purpose really, and its the native hearers() check, so no supercall
/mob/comms_listener/New(target_thing)
	..()

/mob/comms_listener/Initialize()
	..()
	GLOB.comms_listeners += src



//cleanup time, if we are at the point of needing to be deleted.
/mob/comms_listener/Destroy()
	data_linked_to = null
	GLOB.comms_listeners -= src
	..()

/*
	Basically this is where we are sending the data we receive
*/
/mob/comms_listener/proc/data_link_to_target(atom/target)
	data_linked_to = target
	

/*
	This is the thing we are currently moving with If we are moving at all
*/
/mob/comms_listener/proc/movement_link_to_target(atom/target)
	target = refind_movement_link_target(target)

	forceMove(target.pixloc)

	target.REGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_FORCED_INTO_CONTENTS, src, .proc/relink_movement_link_target)
	target.REGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, .proc/update_position)

/*
	Our old mans entered the contents of something, find the new mans who is currently at the top
	Its called monkeybranching and why should anyone have to settle for anything but the top chud
*/
/mob/comms_listener/proc/relink_movement_link_target(HOOK_SIG_ID, datum/INVOKER_REF, atom/old_loc, atom/new_loc)

	INVOKER_REF.UNREGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, .proc/update_position)
	INVOKER_REF.UNREGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_FORCED_INTO_CONTENTS, src, .proc/relink_movement_link_target)

	var/atom/new_movelink_target = refind_movement_link_target(INVOKER_REF)
	new_movelink_target.REGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_FORCED_INTO_CONTENTS, src, .proc/relink_movement_link_target)
	new_movelink_target.REGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, .proc/update_position)

/*
	The actual part where we refind the mans at the top
*/
/mob/comms_listener/proc/refind_movement_link_target(atom/current_movelink_target)
	while(!isturf(current_movelink_target.loc))
		if(isnull(current_movelink_target.loc)) // Idk how we got here, but if we do get here it will just infini-loop
			break
		current_movelink_target = current_movelink_target.loc
	return current_movelink_target


/*
	Update our position
*/
/mob/comms_listener/proc/update_position(HOOK_SIG_ID, atom/movable/INVOKER_REF, atom/Last_loc, atom/Current_loc)
	
	if(COMMS_FLAG_AUDIO in comms_flags)
		if(GLOB.map_chunk_cache.is_different_chunk_by_turf(Last_loc, Current_loc))
			GLOB.map_chunk_cache.unregister_by_turf_range(src, Last_loc)
			GLOB.map_chunk_cache.register_by_turf_range(src, Current_loc)

		var/list/sound_emissions = GLOB.map_chunk_cache.find_type_by_turf_range(/datum/sound_emitter, src, CONFIG_WORLD_VIEW * 2)
		if(length(sound_emissions))
			for(var/datum/sound_emitter/SE as anything in sound_emissions)
				if(SE.listener_register_check(src))
					SE.register_listener(src)
					continue


	forceMove(INVOKER_REF.pixloc)


/*
	I predict that there will be special behavior tied to comms flags
*/
/mob/comms_listener/proc/toggle_flag(target_flag)
	if(target_flag in comms_flags)
		// We are removing the comms flag from the list
		switch(target_flag)
			if(COMMS_FLAG_AUDIO)
				GLOB.map_chunk_cache.unregister_by_turf_range(src, loc)
		comms_flags -= target_flag
	else
		// We are adding the comms flag to the list
		switch(target_flag)
			if(COMMS_FLAG_AUDIO)
				GLOB.map_chunk_cache.register_by_turf_range(src, loc)
		comms_flags += target_flag
	
/*
*/
/mob/comms_listener/receive_message(datum/message_data/msg_data)
	if(msg_data.sender == data_linked_to) // ofc we can see our own damn messages
		data_linked_to.receive_message(msg_data)
		return TRUE
	if(msg_data.comms_flags)
		for(var/comms_flag in msg_data.comms_flags)
			if(comms_flag in src.comms_flags)
				data_linked_to.receive_message(msg_data)
				return TRUE