

/*
	We are adding a new listener
*/
/datum/sound_emitter/proc/register_listener(mob/comms_listener/CL)
	CL.REGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, .proc/update_listener)
	var/datum/message_data/msg_data = make_audio_start_message()
	var/sound/sound_data/SD = msg_data.sound_data

	if(9 > get_dist(CL, sound_source)) //CURRENTLY ONSCREEN
		current_listeners[CL] = SOUND_CL_ONSCREEN
		SD.volume = STD.volume * SOUND_VOL_ONSCREEN_PERCENT / 100
	else // CURRENTLY OFFSCREEN AKA THE DISTANCE IS GREATER THAN 9 WHICH IS ONE TURF HIGHER THAN THE DEFAULT WORLDVIEW OF 8
		SD.volume = STD.volume * SOUND_VOL_OFFSCREEN_PERCENT / 100
		if(STD.atom_tracking)
			current_listeners[CL] = SOUND_CL_OFFSCREEN
		else
			SD.x = sound_source.x
			SD.z = sound_source.y
			SD.y = 0
			current_listeners[CL] = get_dir(sound_source, CL)

	

	route_message_single_listener(CL, msg_data)

/*
	We are removing a listener
*/
/datum/sound_emitter/proc/unregister_listener(mob/comms_listener/CL)
	CL.UNREGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, .proc/update_listener)
	route_message_single_listener(CL, make_audio_stop_message())
	current_listeners.Remove(CL)

/*
	We are updating the sound on a listener
*/
/datum/sound_emitter/proc/update_listener(HOOK_SIG_ID, atom/movable/INVOKER_REF, atom/Last_loc, atom/Current_loc)
	var/mob/comms_listener/CL = INVOKER_REF
	var/current_dist = get_dist(CL, sound_source)

	if(current_dist > turf_range)
		unregister_listener(CL)
		return

	var/datum/message_data/msg_data
	if(current_dist > 9) //GOING OFFSCREEN
		if(current_listeners[CL] == SOUND_CL_ONSCREEN && STD.atom_tracking)
			msg_data = make_audio_update_message()
			msg_data.sound_data.volume = STD.volume * SOUND_VOL_OFFSCREEN_PERCENT / 100
			current_listeners[CL] = SOUND_CL_OFFSCREEN
		else if(!STD.atom_tracking)
			var/current_dir = get_dir(sound_source, CL)
			if(current_listeners[CL] != current_dir)
				msg_data = make_audio_update_message()
				msg_data.sound_data.volume = STD.volume *  SOUND_VOL_OFFSCREEN_PERCENT / 100
				msg_data.sound_data.x = sound_source.x - CL.x
				msg_data.sound_data.z = sound_source.y - CL.y
				current_listeners[CL] = current_dir
	else // GOING ONSCREEN
		if(current_listeners[CL] != SOUND_CL_ONSCREEN)
			msg_data = make_audio_update_message()
			msg_data.sound_data.volume = STD.volume * SOUND_VOL_ONSCREEN_PERCENT / 100
			current_listeners[CL] = SOUND_CL_ONSCREEN

			if(!STD.atom_tracking) // to make something 3d it either needs one of xyz to not be 0 or atom to be stuck on, and y is nearly non-functional but does the job so there u go
				msg_data.sound_data.y = 1



	if(msg_data)
		route_message_single_listener(CL, msg_data)


/*
		Unfortunately actually updating the sound constantly produces some nasty stuttering I cba to pick through right now
	
	var/datum/message_data/msg_data = make_audio_start_message()
	msg_data.sound_data.volume = dist_to_vol(CL)
	world_msg("d: [current_dist] - d2v: [dist_to_vol(CL)]")
	route_message_single_listener(CL, msg_data)
*/






	
/*
	Check to see if the listener can be registered under our criteria
*/
/datum/sound_emitter/proc/listener_register_check(mob/comms_listener/CL)
	// Doesn't care about audio, we don't care as we are in the domain of sound
	if(!COMMS_FLAG_AUDIO in CL.comms_flags)
		return FALSE
	// We already got them
	if(CL in current_listeners)
		return FALSE
	// They aren't in our turf range, so we also don't care
	if(turf_range < get_dist(CL, sound_source))
		return FALSE
	// They passed all the checks, thus we can register them
	return TRUE