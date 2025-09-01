
/obj/debug/sound_emitter
	name = "Sound emitter"
	desc = "A object that just makes sound"
	icon_state = "gear"

	var/last_id

/obj/debug/sound_emitter/New()
	. = ..()

/obj/debug/sound_emitter/verb/emit_sound_center()
	set src in oview()
	set category = "Utility"

	sound_play()


/obj/debug/sound_emitter/proc/sound_play()
	last_id = play_atom_emission_sound(src, 'zAssets/Sounds/testing_shit/test_slop4.ogg', 16, 100, TRUE)


/*
/mob/verb/set_sound_eenvironment()
	var/num = input("Enter an sound_env value", "sound_env") as num
	set_sound_environment(usr, num)


/mob/verb/remove_sound_eenvironment()
	remove_sound_environment(usr)

*/