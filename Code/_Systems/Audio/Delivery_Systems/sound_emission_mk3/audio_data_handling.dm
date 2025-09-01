/*
	Make our audio message
*/
/datum/sound_emitter/proc/make_audio_start_message()
	var/datum/message_data/msg_data = new(sound_source, FALSE, FALSE, COMMS_FLAG_AUDIO)
	var/sound/sound_data/SD = new()

	// these are why we can't use the cock and balls operator to copy sounds
	// they r normally skipped except on sound lol

	var/list/skip_vars = list("type", "parent_type", "vars")
	var/curvar
	for(var/varkey in STD.vars)
		if(varkey in skip_vars)
			continue
		curvar = STD.vars[varkey]
		if(islist(curvar))
			curvar = curvar:Copy()
		SD.vars[varkey] = curvar

	SD.find_sound_offset()
	msg_data.sound_data = SD
	SD.falloff = 5

	//world_msg("d2v:[dist_to_vol(CL)]")

	return msg_data
	// x axis ranges on the sound datum represents audio balance from left and right
	//prepped_sound.x = sound_source.x - src.mob.x
	// z axis ranges are forwards and backwards
	//prepped_sound.z = sound_source.y - src.mob.y

	// y axis ranges on the sound datum is above and below your head
	// Can be set to 1 or 0 really, unless you the viewer figures out an audio effect with this one you want
	//prepped_sound.y = 1
/datum/sound_emitter/proc/make_audio_update_message()
	var/datum/message_data/msg_data = new(sound_source, FALSE, FALSE, COMMS_FLAG_AUDIO)
	var/sound/sound_data/SD = new()

	//SD.file = STD.file
	SD.audio_tracking_id = STD.audio_tracking_id
	SD.atom = sound_source
	SD.falloff = 5
	if(STD.atom_tracking)
		SD.atom_tracking = TRUE
		
	SD.repeat = STD.repeat
	SD.status = SOUND_UPDATE
	msg_data.sound_data = SD

	//world_msg("d2v:[dist_to_vol(CL)]")

	return msg_data

/datum/sound_emitter/proc/make_audio_stop_message()
	var/datum/message_data/msg_data = new(sound_source, FALSE, FALSE, COMMS_FLAG_AUDIO)
	var/sound/sound_data/SD = new()
	SD.file = null
	SD.audio_tracking_id = audio_tracker_id
	msg_data.sound_data = SD
	return msg_data
/*
	Returns a calculated Vol according to distance and other crap
*/
/datum/sound_emitter/proc/dist_to_vol(mob/comms_listener/CL)
/*
	=- ACTUAL CALC -=
 	EX NUMBERS:
	dist = 4
	turf_range = 12
	max_vol = 80
 	vol_falloff_range = 2 

	// 4
	var/g_dist = get_dist(CL, sound_source) 
	// 12 - 2 = 10
	var/t_range = turf_range - STD.falloff
	// 10 - 4 = 8
	var/t_left = t_range - g_dist
	// 8 / 10 = 0.8 (Percent)
	var/percentage = t_left / t_range
	// 80 * 0.8 = 64 (Final Vol Percentage)
	var/calc_vol = round(STD.volume * percentage)
	calc_vol = clamp(calc_vol, 0, 100)
*/
	. = clamp(round(STD.volume * ( ( (turf_range - STD.falloff) - get_dist(CL, sound_source) ) / (turf_range - STD.falloff) ) ), 0, 100)
