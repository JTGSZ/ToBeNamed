
/*
	Sound playing helpers
	For playing sound and making your life playing sound a whole lot easier
*/

/*
	Play a emissive atom tracked sound
*/
/proc/play_atom_emission_sound(atom/sound_source, audio_file_path = SFX_SOUND_ERROR, turf_range = 0, center_point_vol = 100, repeat = FALSE, audio_tracking_id = AUDIO_TRACKER.provide_new_audio_ID())
	if(isnull(sound_source))
		ERROR_MSG("play_atom_emission_sound called without a sound_source")
		return

	var/sound/sound_data/SD = new(soundcache_check(audio_file_path), repeat, FALSE, 0, center_point_vol)
	SD.atom = sound_source
	SD.atom_tracking = TRUE
	SD.audio_tracking_id = audio_tracking_id
	SD.find_soundfile_time_length()
	

	var/datum/sound_emitter/NSE = new()
	NSE.audio_tracker_id = audio_tracking_id
	NSE.slot_in_sound_data(SD, turf_range, TRUE)
	NSE.fire_sound_emission()

	return NSE.audio_tracker_id

/*
	Play a offset only tracked sound
*/
/proc/play_xyz_emission_sound(atom/sound_source, audio_file_path = SFX_SOUND_ERROR, turf_range = 0, center_point_vol = 100, repeat = FALSE, audio_tracking_id = AUDIO_TRACKER.provide_new_audio_ID())
	var/sound/sound_data/SD = new(soundcache_check(audio_file_path), repeat, FALSE, 0, center_point_vol)
	SD.atom = sound_source
	SD.atom_tracking = FALSE
	SD.audio_tracking_id = audio_tracking_id
	SD.find_soundfile_time_length()
	

	var/datum/sound_emitter/NSE = new()
	NSE.audio_tracker_id = audio_tracking_id
	NSE.slot_in_sound_data(SD, turf_range, FALSE)
	NSE.fire_sound_emission()

	return NSE.audio_tracker_id

/*
	Play a offset untracked sound, aka single fire to all the things we can reach
*/
/proc/play_xyz_untracked_sound(atom/sound_source, audio_file_path = SFX_SOUND_ERROR, turf_range = 0, center_point_vol = 100, repeat = FALSE, audio_tracking_id = AUDIO_TRACKER.provide_new_audio_ID())

	// Find all the listeners we can potentially have via the chunking system
	var/list/big_search = GLOB.map_chunk_cache.find_type_by_chunk_range(/mob/comms_listener, sound_source, turf_range)
	for(var/mob/comms_listener/CL as anything in big_search)
		var/gotten_dist = get_dist(CL, sound_source)

		if(gotten_dist > turf_range)
			continue

		var/sound/sound_data/SD = new(soundcache_check(audio_file_path), repeat, FALSE, 0, center_point_vol)
		SD.audio_tracking_id = audio_tracking_id
		SD.atom = sound_source
		SD.atom_tracking = FALSE

		if(9 > gotten_dist) //CURRENTLY ONSCREEN
			SD.volume = center_point_vol * SOUND_VOL_ONSCREEN_PERCENT / 100
		else // CURRENTLY OFFSCREEN
			SD.volume = center_point_vol * SOUND_VOL_OFFSCREEN_PERCENT / 100
			SD.x = sound_source.x
			SD.z = sound_source.y
			SD.y = 0

		var/datum/message_data/msg_data = new(sound_source, FALSE, turf_range, COMMS_FLAG_AUDIO)
		msg_data.sound_data = SD
		route_message_single_listener(CL, msg_data)


/*
	Ye olde regular route audio playing
	Fire once and forget, no fancy tracking etc
	Just comes out of a coord position
*/
/proc/play_simple_sound(atom/sound_source, audio_file_path = SFX_SOUND_ERROR, sound_volume = 100, needs_vision = FALSE, repeat = FALSE, sending_range = world.view, audio_tracking_id = AUDIO_TRACKER.provide_new_audio_ID())

	var/sound/sound_data/SD = new(soundcache_check(audio_file_path), repeat, FALSE, 0, sound_volume)
	SD.audio_tracking_id = audio_tracking_id
	SD.atom = sound_source
	SD.atom_tracking = FALSE

	var/datum/message_data/msg_data = new(sound_source, FALSE, sending_range, COMMS_FLAG_AUDIO)
	msg_data.sound_data = SD

	if(sending_range == SOUND_TO_WORLD)
		route_message_all_clients(msg_data)
	else if (needs_vision)
		route_message_hearers(msg_data)
	else
		route_message_distance(msg_data)

/*
	In case you want to play a sound directly to a client but don't want to invest much effort
	audio_tracker_id - In the offchance you want to find something playing on the client again later, just tag it with some shit

*/
/proc/play_direct_client_sound(target_client_or_mob, audio_file_path = SFX_SOUND_ERROR, sound_volume = 100, repeat = FALSE, audio_tracking_id = AUDIO_TRACKER.provide_new_audio_ID())
	var/sound/sound_data/SD = new(soundcache_check(audio_file_path), repeat, FALSE, 0, sound_volume)
	SD.audio_tracking_id = audio_tracking_id
	SD.atom_tracking = FALSE

	var/client/C
	if(isclient(target_client_or_mob))
		SD.atom = C.mob
		C = target_client_or_mob
		C.receive_sound_data(SD)
		return
	if(ismob(target_client_or_mob))
		var/mob/M = target_client_or_mob
		SD.atom = M
		if(M.client)
			C = M.client
			C.receive_sound_data(SD)
			return

/*
	Incase you want to stop a sound playing on the client with an ID, and want a shitty helper for it
*/
/proc/forcestop_direct_client_sound(target_client_or_mob, audio_tracking_id)
	var/sound/sound_data/SD = new()
	SD.audio_tracking_id = audio_tracking_id
	SD.atom_tracking = FALSE

	var/client/C
	if(isclient(target_client_or_mob))
		SD.atom = C.mob
		C = target_client_or_mob
		C.receive_sound_data(SD)
		return
	if(ismob(target_client_or_mob))
		var/mob/M = target_client_or_mob
		if(M.client)
			SD.atom = M
			C = M.client
			C.receive_sound_data(SD)
			return
/*
	Set a environment on a client or mob
*/
/proc/set_sound_environment(target_client_or_mob, target_environment)
	var/sound/sound_data/SD = new()
	SD.environment = target_environment

	var/client/C
	if(isclient(target_client_or_mob))
		C = target_client_or_mob
		C.receive_sound_data(SD)
		return
	if(ismob(target_client_or_mob))
		var/mob/M = target_client_or_mob
		if(M.client)
			C = M.client
			C.receive_sound_data(SD)
			return

/*
	Stop a environment on a client or mob
*/
/proc/remove_sound_environment(target_client_or_mob)
	var/sound/sound_data/SD = new()
	SD.environment = SOUND_ENVIRONMENT_GENERIC

	var/client/C
	if(isclient(target_client_or_mob))
		C = target_client_or_mob
		C.receive_sound_data(SD)
		return
	if(ismob(target_client_or_mob))
		var/mob/M = target_client_or_mob
		if(M.client)
			C = M.client
			C.receive_sound_data(SD)
			return