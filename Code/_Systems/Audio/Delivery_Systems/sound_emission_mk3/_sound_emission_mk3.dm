/*
	Sound emitter datum
	Basically this guy represents a emission of sound and the data related to that
*/

/datum/sound_emitter
	// this helps us keep track of what channel we are currently occupying on listeners with clients along with the actual sound
	// Also its requested from the AUDIO_TRACKER so every random shit trying to emit noise can find a non-conflicting ID
	var/audio_tracker_id
	// The thing that is supposed to be playing the sound
	var/atom/sound_source
	var/turf_range


	/*
		Working Vars - aka just used to do work
	*/
	// this is a set of mob/listeners that we have reached
	var/list/current_listeners = list()
	// the ID of the timer we are using to call the proc for when a sound has finished playing completely
	var/sound_endtime_timer = null
	// sound template data
	// A fun fact is if you ref_one_sound = ref_two_sound it just copies everything onto ref_two according to the stddef
	// Except doing this usually just breaks because lummox forgot he can't copy certain vars while making his operator override as seen in the stddef
	var/sound/sound_data/STD


/datum/sound_emitter/Destroy()
	if(sound_source)
		sound_source.UNREGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, .proc/update_position)
		sound_source.UNREGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_ON_DESTROY, src, .proc/Remote_Destroy)
		GLOB.map_chunk_cache.unregister_by_turf_range(src, sound_source, turf_range)

	AUDIO_TRACKER.unhold_emission_ref(src)
	unregister_all_listeners()
	sound_source = null
	current_listeners = null
	if(STD)
		STD.cleanup_refs()
		STD = null

	..()
	
/datum/sound_emitter/proc/Remote_Destroy(HOOK_SIG_ID, datum/INVOKER_REF)
	qdel(src)

/*
	Someone has crammed a sound data into our slot
	Now we are ready to deliver a thicc load unto our listeners
*/
/datum/sound_emitter/proc/slot_in_sound_data(sound/sound_data/SD, target_turf_range)
	if(!audio_tracker_id)
		audio_tracker_id = AUDIO_TRACKER.provide_new_audio_ID()
	AUDIO_TRACKER.hold_emission_ref(src)

	STD = SD

	sound_source = STD.atom
	turf_range = target_turf_range

		
	// So we can get cleaned up if our source dies
	sound_source.REGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_ON_DESTROY, src, .proc/Remote_Destroy)
	
	if(turf_range >= CONFIG_WORLD_VIEW * 2 && STD.atom_tracking == TRUE)
		STD.offscreen_caching = TRUE

	return audio_tracker_id

/*
	We are setup, now we fire the sound emission
*/
/datum/sound_emitter/proc/fire_sound_emission()

	GLOB.map_chunk_cache.register_by_turf_range(src, sound_source, turf_range)
	
	// Register a hook on the soundsource so we can update our position if it moves
	sound_source.REGISTER_CALLHOOK(HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED, src, .proc/update_position)

	// Tell our STD to get its time shit together
	STD.handle_soundtimes()

	// Find all the listeners we can potentially have, its either this or you are gonna be typechecking everything from a mainline parent
	var/list/big_search = GLOB.map_chunk_cache.find_type_by_chunk_range(/mob/comms_listener, sound_source, turf_range)
	
	// Iterate the nu list, give it the ol listener register check
	for(var/mob/comms_listener/CL as anything in big_search)
		if(listener_register_check(CL))
			register_listener(CL)


	// We aren't going to forcibly end if we are looping
	if(STD.repeat) // This tries to keep all the new listeners still synced even though the sound is looping, by refinding some times
		sound_endtime_timer = ADD_REALTIMER(STD, /sound/sound_data/proc/refind_looping_offset, STD.file_time_length)
	else  // Normal end, we just end it all when we hit the length time
		sound_endtime_timer = ADD_REALTIMER(src, /proc/qdel, STD.file_time_length, src)

/*	
	What starts also one day must stop
*/
/datum/sound_emitter/proc/unregister_all_listeners()
	for(var/mob/comms_listener/CL as anything in current_listeners)
		unregister_listener(CL)
