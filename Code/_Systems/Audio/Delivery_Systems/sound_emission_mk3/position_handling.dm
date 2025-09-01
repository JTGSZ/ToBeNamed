/*
	We are updating our chunk position cause the sound source is movin
	There is too much of a diff between this situation and the initial search proc
*/
/datum/sound_emitter/proc/update_position(HOOK_SIG_ID, atom/movable/INVOKER_REF, atom/Last_loc, atom/Current_loc)
	// Make sure we are actually moving into a new chunk
	if(GLOB.map_chunk_cache.is_different_chunk_by_turf(Last_loc, Current_loc))
		GLOB.map_chunk_cache.unregister_by_turf_range(src, sound_source, turf_range)
		GLOB.map_chunk_cache.register_by_turf_range(src, sound_source, turf_range)
	
	for(var/mob/comms_listener/CL in current_listeners)
		update_listener(HOOK_SIG_ID, CL, Last_loc, Current_loc)

	// Find all the listeners we can potentially have, its either this or you are gonna be typechecking everything from a mainline parent
	var/list/big_search = GLOB.map_chunk_cache.find_type_by_chunk_range(/mob/comms_listener, sound_source, turf_range)

	// Iterate the nu list, give it the ol listener register check
	for(var/mob/comms_listener/CL as anything in big_search)
		// Doesn't care about audio, we don't care as we are in the domain of sound
		if(!COMMS_FLAG_AUDIO in CL.comms_flags)
			continue
		// We already got them
		if(CL in current_listeners)
			continue
		// They aren't in our turf range, so we also don't care
		if(turf_range < get_dist(CL, sound_source))
			return FALSE
		// They passed all the checks so we register them
		register_listener(CL)


/*
	In the off-chance a box is better than the current circle for listener handling diameter (get_dist makes it a circle)
*/
/datum/sound_emitter/proc/box_check(atom/target)
	// Max X and Min X
	if(target.x > (sound_source.x - turf_range) && (sound_source.x + turf_range) > target.x)
		// Max Y and Min Y
		if(target.y > (sound_source.y - turf_range) && (sound_source.y + turf_range) > target.y)
			return TRUE
	return FALSE