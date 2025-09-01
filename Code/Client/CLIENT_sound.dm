/*
	We are starting a new sound, so we gotta set it up and cache/track it
	The client tries to allocate and handle its own list of channels
	Thus we need some tracking in order to find them later for manipulation
*/
/client/proc/receive_sound_data(sound/sound_data/SD)
	AUDIO_TRACKER.sounds_heard++
	// We gotta find out whether we were already here or not
	if(audio_tracker_id_data?[SD.audio_tracking_id])
		SD.channel = audio_tracker_id_data[SD.audio_tracking_id]
		if(isnull(SD.file) && !(SD.status & SOUND_UPDATE)) // means we are putting a stop to this sound business on this channel, and its also not a sound update
			clean_out_used_channel_data(SD.channel)
	else
		SD.channel = find_next_free_soundchannel()
		audio_tracker_id_data[SD.audio_tracking_id] = SD.channel // so we can find the channel we ended up with via a ID you hopefully received
		used_sound_channels[SD.channel] = SD

		// You need a atom attached to the sound and want more than a screens worth of tracking otherwise doing the dumbass memory holding thing is worthless
		if(SD.atom && SD.offscreen_caching)
			SD.screen_cache_obj = new()
			SD.screen_cache_obj.vis_contents += SD.atom
			screen += SD.screen_cache_obj


	if(!SD.atom_tracking)
		SD.atom = null

	//Adjust for whatev the fuck the client has set on it, Its a percentage look at the divsion by 100 lol
	SD.volume = SD.volume * persist_data.client_game_volume / 100
	src << SD


// idk what more do you want, on runtime it picks a song out of the titlescreen_music folder
/client/proc/play_titlescreen_music()
	if(GLOB.titlescreen_music)
		play_direct_client_sound(src, GLOB.titlescreen_music, 70, TRUE, SOUND_ID_TITLESCREEN)

/client/proc/end_titlescreen_music()
	forcestop_direct_client_sound(src, SOUND_ID_TITLESCREEN)



/*
	Stop ALL the sound
*/
/client/proc/stop_all_sound()



//TODO make this faster than iterating upwards forever to find a free channel
/client/proc/find_next_free_soundchannel() 
	for(var/i in SOUND_CHANNEL_MIN to SOUND_CHANNEL_CLIENT_MAX)
		// If we exist, and are currently still before the endtime do not reallocate this guy
		if(used_sound_channels[i])
			var/sound/sound_data/SD = used_sound_channels[i]
			// sound is looping
			if(SD.repeat) 
				continue
			// They have not ended yet
			if(world.timeofday >= SD.deci_end_timestamp)
				continue
			// They are currently just paused
			if(SD.status & SOUND_PAUSED)
				continue
			// We are good to go on re-using this one
			clean_out_used_channel_data(i)
			return i
		// We found a clean one
		return i


// Cleans out the refs in a used channel list
/client/proc/clean_out_used_channel_data(target_channel)
	var/sound/sound_data/SD = used_sound_channels[target_channel]
	
	if(SD.screen_cache_obj)
		screen -= SD.screen_cache_obj
		qdel(SD.screen_cache_obj)
		SD.screen_cache_obj = null

	SD.atom = null
	audio_tracker_id_data.Remove(SD.audio_tracking_id)
	used_sound_channels.Remove(target_channel)


/*
	Jus dump all dis shit out
*/
/client/proc/clean_out_all_used_channel_data()
	for(var/channel_number in used_sound_channels)
		clean_out_used_channel_data(channel_number)