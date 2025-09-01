
/*
	Sound with some extra vars
*/
/sound/sound_data
	//This is mostly so each client handles its own channels and we can find this guy later
	var/audio_tracking_id


	//file
	repeat = FALSE
	wait = FALSE
	//volume
	//x
	//y
	//z
	//falloff
	var/atom_tracking = FALSE
	atom
	//status
	// Sound offset aka when we start in SECONDS on the file
	//offset
	//These in deciseconds
	var/deci_start_timestamp
	var/deci_end_timestamp
	var/file_time_length

	// Whether we do the offscreen caching hack
	var/offscreen_caching = FALSE

	var/obj/offscreen_caching_object/screen_cache_obj
	//environment
	//echo
	//transform
	//channel
	//frequency
	//len
	//pan
	//params
	//pitch
	//priority


/*
	THIS IS THE DEFAULT NEW PROC FOR A SOUND ACCORDING TO THE STDDEF

/sound/New(file,repeat,wait,channel,volume=100)
		src.file = istype(file,/list) ? file : fcopy_rsc(file)
		src.repeat = repeat
		src.wait = wait
		src.channel = channel
		src.volume = volume
		return ..()
*/
/*
	Cleanup our refs I guess, idk why we would be holding a screen cache object but whatev
*/
/sound/sound_data/proc/cleanup_refs()
	atom = null
	screen_cache_obj = null


/*
	So you can just find all the times
*/
/sound/sound_data/proc/handle_soundtimes()
	find_soundfile_time_length()
	find_timestamps()
	find_sound_offset()

/*
	Set our start and end timestamps
*/
/sound/sound_data/proc/find_timestamps()
	deci_start_timestamp = world.timeofday
	deci_end_timestamp = world.timeofday + file_time_length

/*
	find out how long the sound is in human time
*/
/sound/sound_data/proc/find_soundfile_time_length()
	if(file in GLOB.sound_length_cache)
		file_time_length = GLOB.sound_length_cache[file]
	else
		file_time_length = rustg_sound_length(file)
		GLOB.sound_length_cache[file] = file_time_length

/*
	Sound offset specifies seconds, and we have deciseconds times here
	anyways its the current time minus the sound start timestamp for the total duration thats occured
	Then that is divided by 10 to convert deciseconds into seconds
*/
/sound/sound_data/proc/find_sound_offset()
	offset = (world.timeofday - deci_start_timestamp) / 10

/*
	The emitter is looping, so we have to refind the offset for each iteration of it
	This is to give the offset to the client to keep them all in sync even 500 loops in
*/
/sound/sound_data/proc/refind_looping_offset()
	find_timestamps()
	find_sound_offset()

	// Re-add the timer
	ADD_REALTIMER(src, .proc/refind_looping_offset, file_time_length)
	


/*
	This is just a object that is invisible in the corner of the screen that keeps a atom loaded in the clients memory when it is not on their screen
*/
/obj/offscreen_caching_object
	screen_loc = "1,1"
	vis_flags = VIS_INHERIT_ICON|VIS_INHERIT_ICON_STATE
	invisibility = INVISIBILITY_DEBUGGING_REALITY // no lookies

/obj/offscreen_caching_object/Destroy()
	vis_contents.Cut()
	..()
