var/global/datum/fancy_stats/audio_tracker/AUDIO_TRACKER

/*
	This guy used to be simple
	Now he is taking on more of a job, but

*/
/datum/fancy_stats/audio_tracker
	var/current_audio_ID = 1
	// just the total amount of sounds the client hears
	var/sounds_heard = 0

	// Instead lists on mobs, we just cram the ref here so our guy don't get cleaned up
	var/list/sound_emissions = list()


/*
	Hold a emission ref
*/
/datum/fancy_stats/audio_tracker/proc/hold_emission_ref(datum/sound_emitter)
	sound_emissions += sound_emitter
/*
	Unhold a emission ref
*/
/datum/fancy_stats/audio_tracker/proc/unhold_emission_ref(datum/sound_emitter)
	sound_emissions -= sound_emitter

/*
	Just counts up per every request
	Which means you will never have a conflict problem across every thing requesting one...
*/
/datum/fancy_stats/audio_tracker/proc/provide_new_audio_ID()
	var/provided_id = current_audio_ID
	current_audio_ID++
	return provided_id


/datum/fancy_stats/audio_tracker/stats_panel_entry()
	stat("Audio Tracking:", stat_click_object.update_text("Sounds Heard:[sounds_heard], Emissions: [sound_emissions.len], On ID: [current_audio_ID]"))